import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown_alert/dropdown_alert.dart';
import 'package:get/get.dart';
import 'package:regester/height_screen/dimensions.dart';
import 'package:regester/users/authentication/login_screen.dart';
import 'package:regester/users/fragments/Main/board.dart';
import 'package:regester/users/userPreferences/user_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
  ));
  runApp(MyApp(token: 1));
}

class MyApp extends StatelessWidget {
  final int token;
  const MyApp({super.key, required this.token});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Food app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: RememberUserPrefs.readUserInfo(),
        builder: (context, dataSnapShot)
        {
          if (token==0){
            return LoginScreen();
          }
          else{
            return MainBoardScreen(page: 0);
          }
        },
      ),
      builder: (context, child) => Stack(
        children: [
          child!,
          DropdownAlert(
            position: AlertPosition.BOTTOM,
          )
        ],
      ),
    );
  }
}
