import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main.dart';

void main() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  runApp(bg());
}

class bg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  //Переход на следующий экран через 2 секунды
  Future<void> _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xFFFE832A),
                Color(0xFFFFBF00),
              ],
              stops: [0.0, 1.0],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              "ОБЕДОСЕРВИС",
              style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  decoration: TextDecoration.none // Убираем подчеркивание
              ),
            ),
          ),
        ),
        Center(
          child: Image.asset(
            'images/ava.png',
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}