import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown_alert/dropdown_alert.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:lottie/lottie.dart';
import 'package:regester/height_screen/dimensions.dart';
import 'package:regester/users/authentication/login_screen.dart';
import 'package:regester/users/fragments/Main/board.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:show_up_animation/show_up_animation.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(SplashScreen());
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{
  late final AnimationController _lottieAnimation;
  String dataLogin="";
  static var tokenLogin=0;
  bool isLoading=true;

  @override
  void initState() {
    loadLogin();
    super.initState();
    _lottieAnimation = AnimationController(vsync: this);
    FlutterNativeSplash.remove();
    Future.delayed(Duration(seconds: 1)).then((value) => _lottieAnimation.forward().then((value) => setState(() {isLoading = false; if(dataLogin!=""){setState(() {tokenLogin=1;});}})));
    // 1 секунда для релиз версии (6)
    //Timer(Duration(seconds: 7), () => setState(() {isLoading = false; if(dataLogin!=""){setState(() {tokenLogin=1;});}}));
  }

  @override
  void dispose() {
    _lottieAnimation.dispose();
    super.dispose();
  }

  loadLogin() async{
    SharedPreferences pre = await SharedPreferences.getInstance();
    dataLogin = pre.getString("user_login") ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Food app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: _LogoAnim(),
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

  Widget _LogoAnim() {
    if (isLoading){
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                'images/Logo.json',
                onLoaded: (composition) {
                  _lottieAnimation..duration = composition.duration;
                },
                controller: _lottieAnimation,
                repeat: false,
                animate: false,
              ),
              ShowUpAnimation(
                delayStart: Duration(seconds: 1), //1 секунда для релиз версии (4)
                animationDuration: Duration(seconds: 1),
                curve: Curves.bounceIn,
                direction: Direction.vertical,
                offset: 0.5,
                child: Text(
                  "Обедо Сервис",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Splash',
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }else{
      if (tokenLogin==0){
        return LoginScreen();
      }
      else{
        return MainBoardScreen(page: 0);
      }
    }
  }
}
