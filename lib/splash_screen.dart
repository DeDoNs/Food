import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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

  String dataLogin="";
  static var tokenLogin=0;

  @override
  void initState() {
    loadLogin();
    super.initState();
    _navigateToNextScreen();
  }

  loadLogin() async{
    SharedPreferences pre = await SharedPreferences.getInstance();
    dataLogin = pre.getString("user_login") ?? "";
  }

  //Переход на следующий экран через 2 секунды
  Future<void> _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 3));
    if(dataLogin!=""){tokenLogin=1;}
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp(token: tokenLogin)),
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