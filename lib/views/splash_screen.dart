import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'home_screen.dart';

// firebaseUser == null ? WelcomeScreen.id : ChatScreen.id
class SplashScreenPage extends StatelessWidget {
  static const String id = 'splash_screen';

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: HomeScreen(),
      backgroundColor: Colors.teal,
      loaderColor: Colors.white,
      useLoader: true,
      loadingText: Text(
        'Box Novel',
        textScaleFactor: 2,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }
}
