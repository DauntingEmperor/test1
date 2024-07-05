import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import your HomeScreen widget here

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(repositories: []), // Pass repositories or any required parameters here
    );
  }
}
