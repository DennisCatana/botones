import 'package:flutter/material.dart';
import 'package:flutter_application_2/testing_app/main.dart' as testing_app;
import 'package:flutter_application_2/infinite_list/main.dart' as infinite_list;
import 'package:flutter_application_2/game_template/main.dart' as game_template;

import 'package:flutter_application_2/game_template/src/player_progress/persistence/local_storage_player_progress_persistence.dart';
import 'package:flutter_application_2/game_template/src/settings/persistence/local_storage_settings_persistence.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildButton(
              context,
              'Go to Testing App',
              Colors.blue,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => testing_app.TestingApp()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildButton(
              context,
              'Go to Infinite List App',
              Colors.green,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => infinite_list.MyApp()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildButton(
              context,
              'Go to Game Template App',
              Colors.red,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => game_template.MyApp(
                      playerProgressPersistence: LocalStoragePlayerProgressPersistence(),
                      settingsPersistence: LocalStorageSettingsPersistence(),
                      inAppPurchaseController: null,
                      adsController: null,
                      gamesServicesController: null,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Background color
        foregroundColor: Colors.white, // Text color
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        elevation: 5, // Shadow effect
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }
}
