import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:regester/users/fragments/Main/main_screen.dart';
import 'package:regester/users/fragments/Main/menuItem_screen.dart';
import 'package:regester/users/fragments/Main/profile_screen.dart';
import 'package:regester/users/fragments/Main/shopCart_screen.dart';

class MainBoardScreen extends StatefulWidget {
  final int page;

  const MainBoardScreen({super.key, required this.page});

  @override
  State<MainBoardScreen> createState() => _MainBoardState();
}

class _MainBoardState extends State<MainBoardScreen> {
  final List<Widget> _widgetOptions = <Widget>[
    MainScreen(),
    MenuItem(page: _currenPage),
    ShopCart(),
    ProfileScreen(),
  ];

  static int _currenPage = 0;

  @override
  void initState() {
    _currenPage = widget.page;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);  // to re-show bars
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bottom navigation bar',
      home: Scaffold(
        backgroundColor: Color(0xFFFAFAFA),
        body: Center(
          child: _widgetOptions.elementAt(_currenPage),
        ),
        bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
                canvasColor: Colors.white,
                primaryColor: Colors.red,
                textTheme: Theme.of(context).textTheme.copyWith(
                    bodySmall: const TextStyle(color: Colors.yellow))),
            child: GNav(
              gap: 8,
              activeColor: Colors.amber,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              color: Colors.black,
              tabs: const [
                GButton(
                  icon: Icons.home_outlined,
                ),
                GButton(
                  icon: Icons.menu,
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
      ),
    );
  }
}

