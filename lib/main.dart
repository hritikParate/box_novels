import 'package:flutter/material.dart';
import 'views/home_screen.dart';
import 'views/search_result_list.dart';
import 'views/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreenPage.id,
      routes: {
        SplashScreenPage.id: (context) => SplashScreenPage(),
        HomeScreen.id: (context) => HomeScreen(),
        SearchResultList.id: (context) => SearchResultList(),
      },
      theme: ThemeData(
          primaryColor: Colors.white,
          accentColor: Colors.teal,
          primaryIconTheme: IconThemeData(color: Colors.white)),
    );
  }
}
