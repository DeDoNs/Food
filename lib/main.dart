import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:regester/height_screen/dimensions.dart';
import 'package:regester/users/authentication/login_screen.dart';
import 'package:regester/users/fragments/Main/board.dart';
import 'package:regester/users/userPreferences/user_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Food app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: RememberUserPrefs.readUserInfo(),
        builder: (context, dataSnapShot)
        {
          if (dataSnapShot.data == null){
            return LoginScreen();
          }
          else{
            return MainBoardScreen(page: 0);
          }
        },
      ),
    );
  }
}
