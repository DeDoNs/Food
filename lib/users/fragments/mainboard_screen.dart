import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:regester/users/fragments/user_screen.dart';
import 'package:regester/users/userPreferences/current_user.dart';

import 'car_screen.dart';
import 'office_screen.dart';
import 'org/org_screen.dart';

void main() {
  runApp(MainBoard());
  ThemeData(primaryColor: Colors.grey[800],);
  MainBoardOne();
}

class MainBoard extends StatefulWidget {
  MainBoard({Key? key}): super(key: key);

  @override
  MainBoardTwo createState() => MainBoardTwo();
}

class MainBoardOne extends State {

  final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CurrentUser(),
      initState: (currentState){
        _rememberCurrentUser.getUserInfo();
        },
      builder: (controller){
        return MainBoard();
        },
    );
  }

}

class MainBoardTwo extends State {

  final List<Widget> _widgetOptions = <Widget>[

    OfficeScreen(),
    CarScreen(),
    UserScreen(),
  ];

  var _currenPage = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom navigation bar',
      home: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_currenPage),
        ),
        bottomNavigationBar: Theme(data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
            primaryColor: Colors.red,
            textTheme: Theme
                .of(context)
                .textTheme
                .copyWith(bodySmall: const TextStyle(color: Colors.yellow))),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: Colors.black,
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: Colors.grey[100]!,
            color: Colors.black,
            tabs: const [
              GButton(
                icon: Icons.home_outlined,
              ),
              GButton(
                icon: Icons.place_outlined,
              ),
              GButton(
                icon: Icons.shopping_bag_outlined,
              ),
              GButton(
                icon: Icons.account_circle_outlined,
              ),
            ],
            selectedIndex: _currenPage,
            onTabChange: (index) {
              setState(() {
                _currenPage = index;
              });
            },
          )),
      ),);

  }
}

//return GetBuilder(
//init: CurrentUser(),
//initState: (currentState){
//_rememberCurrentUser.getUserInfo();
//},
//builder: (controller){
//return const Scaffold();
//},
//);
