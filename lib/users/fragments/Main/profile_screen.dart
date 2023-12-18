import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:regester/api_connection/api_connection.dart';
import 'package:regester/height_screen/dimensions.dart';
import 'package:regester/users/authentication/login_screen.dart';
import 'package:regester/users/userPreferences/user_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

signOutUser() async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.remove("user_login");
  RememberUserPrefs.removeUserInfo().then((value){
    Get.off(LoginScreen());
  });
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Профиль",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: Dimensions.font24,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      backgroundColor: Color(0xFFF5F5F3),
      body: Column(children: [
        SizedBox(height: Dimensions.height10),
        Container(
          height: 120,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  child: Image.asset(
                    "images/icon_user.png",
                    fit: BoxFit.cover,
                    color: Colors.amber,
                  ),
                  margin: EdgeInsets.all(15),
                  width: 100,
                  height: 100,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Dimensions.height20),
        GestureDetector(
          onTap: () {

          },
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "История заказов",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: Colors.amber,
                  ),
                ],
              ),
            ),
          ),
        ),

      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          Container(
                width: Dimensions.buttonfullwidgt,
                height: Dimensions.height45,
                child: RawMaterialButton(
                  fillColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Выйти из профиля",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: Dimensions.font18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    signOutUser();
                  },
                ),
      ),
    );
  }
}
