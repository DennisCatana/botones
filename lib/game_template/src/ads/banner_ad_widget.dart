// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'ads_controller.dart';
import 'preloaded_banner_ad.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  static final _log = Logger('BannerAdWidget');

  static const useAnchoredAdaptiveSize = false;
  BannerAd? _bannerAd;
  _LoadingState _adLoadingState = _LoadingState.initial;

  late Orientation _currentOrientation;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (_currentOrientation == orientation &&
            _bannerAd != null &&
            _adLoadingState == _LoadingState.loaded) {
          _log.info(() => 'We have everything we need. Showing the ad '
              '${_bannerAd.hashCode} now.');
          return SizedBox(
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          );
        }
        // Reload the ad if the orientation changes.
        if (_currentOrientation != orientation) {
          _log.info('Orientation changed');
          _currentOrientation = orientation;
          _loadAd();
        }
        return const SizedBox();
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentOrientation = MediaQuery.of(context).orientation;
  }

  @override
  void dispose() {
    _log.info('disposing ad');
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final adsController = context.read<AdsController>();
    final ad = adsController.takePreloadedAd();
    if (ad != null) {
      _log.info("A preloaded banner was supplied. Using it.");
      _showPreloadedAd(ad);
    } else {
      _loadAd();
    }
  }

  /// Load (another) ad, disposing of the current ad if there is one.
  Future<void> _loadAd() async {
    if (!mounted) return;
    _log.info('_loadAd() called.');
    if (_adLoadingState == _LoadingState.loading ||
        _adLoadingState == _LoadingState.disposing) {
      _log.info('An ad is already being loaded or disposed. Aborting.');
      return;
    }
    _adLoadingState = _LoadingState.disposing;
    await _bannerAd?.dispose();
    _log.fine('_bannerAd disposed');
    if (!mounted) return;

    setState(() {
      _bannerAd = null;
      _adLoadingState = _LoadingState.loading;
    });

    AdSize size;

    if (useAnchoredAdaptiveSize) {
      final AnchoredAdaptiveBannerAdSize? adaptiveSize =
          await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
              MediaQuery.of(context).size.width.truncate());

      if (adaptiveSize == null) {
        _log.warning('Unable to get height of anchored banner.');
        size = AdSize.banner;
      } else {
        size = adaptiveSize;
      }
    } else {
      size = AdSize.mediumRectangle;
    }

    if (!mounted) return;

    assert(Platform.isAndroid || Platform.isIOS,
        'AdMob currently does not support ${Platform.operatingSystem}');
    _bannerAd = BannerAd(
      adUnitId: Theme.of(context).platform == TargetPlatform.android
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716',
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _log.info(() => 'Ad loaded: ${ad.responseInfo}');
          setState(() {

            _bannerAd = ad as BannerAd;
            _adLoadingState = _LoadingState.loaded;
          });
        },
        onAdFailedToLoad: (ad, error) {
          _log.warning('Banner failedToLoad: $error');
          ad.dispose();
        },
        onAdImpression: (ad) {
          _log.info('Ad impression registered');
        },
        onAdClicked: (ad) {
          _log.info('Ad click registered');
        },
      ),
    );
    return _bannerAd!.load();
  }

  Future<void> _showPreloadedAd(PreloadedBannerAd ad) async {

    _adLoadingState = _LoadingState.loading;
    try {
      _bannerAd = await ad.ready;
    } on LoadAdError catch (error) {
      _log.severe('Error when loading preloaded banner: $error');
      unawaited(_loadAd());
      return;
    }
    if (!mounted) return;

    setState(() {
      _adLoadingState = _LoadingState.loaded;
    });
  }
}

enum _LoadingState {
  initial,


  loading,

  disposing,


  loaded,
}
