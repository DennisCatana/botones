import 'package:flutter/material.dart';
import 'package:flutter_application_2/testing_app/main.dart' as testing_app;
import 'package:flutter_application_2/infinite_list/main.dart' as infinite_list;

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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const testing_app.TestingApp()),
                );
              },
              child: const Text('Go to Testing App'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const infinite_list.MyApp()),
                );
              },
              child: const Text('Go to Infinite List App'),
            ),
            // Agregar otros botones para proyectos adicionales aquí después
          ],
        ),
      ),
    );
  }
}
