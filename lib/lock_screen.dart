import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LockScreen extends StatelessWidget {
  final VoidCallback onUnlock;

  const LockScreen({Key? key, required this.onUnlock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgrounds/lock_screen_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('HH:mm').format(DateTime.now()), // iOS-like clock format
                style: TextStyle(
                  fontSize: 80,
                  fontFamily: 'HelveticaNeue', // Using HelveticaNeue font
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  onUnlock(); // Callback to unlock
                },
                child: Text('Slide to Unlock'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  textStyle: TextStyle(
                    fontFamily: 'HelveticaNeue', // Button text font
                    fontSize: 20,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  side: BorderSide(width: 2, color: Colors.white), // Button border
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
