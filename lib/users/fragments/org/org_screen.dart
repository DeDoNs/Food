import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:regester/height_screen/dimensions.dart';
import 'package:regester/users/userPreferences/current_user.dart';

import '../../userPreferences/current_user.dart';

class OrgScreen extends StatelessWidget {
  final CurrentUser _currentUser = Get.put(CurrentUser());

  Widget userInfoItem(String userData){
    return Container(
      margin: EdgeInsets.only(top: 50, bottom: Dimensions.height15),
      padding: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Добрый день!",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: Dimensions.font18,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: 5),
          Text(
            _currentUser.user.user_login,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: Dimensions.font18,
              color: Colors.amber,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          userInfoItem(_currentUser.user.user_login),
          Expanded(child: SingleChildScrollView(
            child: Column(),
          )),
        ],
      ),
    );
  }}