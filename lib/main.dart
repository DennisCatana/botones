import 'package:flutter/material.dart';
import 'project1/main.dart' as project1;
import 'project2/main.dart' as project2;
import 'project3/main.dart' as project3;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: {
        '/project1': (context) => project1.MyApp(),
        '/project2': (context) => project2.MyApp(),
        '/project3': (context) => project3.MyApp(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Project'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/project1');
              },
              child: Text('Open Project 1'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/project2');
              },
              child: Text('Open Project 2'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/project3');
              },
              child: Text('Open Project 3'),
            ),
          ],
        ),
      ),
    );
  }
}
