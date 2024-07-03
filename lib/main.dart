import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(VortexLauncher());
}

class VortexLauncher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vortex Launcher',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
