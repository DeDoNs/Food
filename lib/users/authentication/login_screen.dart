import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:regester/height_screen/dimensions.dart';
import 'package:regester/users/authentication/signup_screen.dart';
import 'package:regester/users/fragments/Main/board.dart';
import 'package:regester/users/fragments/mainboard_screen.dart';
import 'package:regester/users/userPreferences/user_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api_connection/api_connection.dart';
import '../model/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();
  var loginController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;
  String user_login="";
  String data="1";

  loginUser() async {
    user_login = loginController.text.trim();
    try {
      var res = await http.post(
        Uri.parse(API.login),
        body: {
          'user_login': user_login,
          'user_password': passwordController.text.trim()
        },
      );

      if (res.statusCode == 200) {
        //200 - API OK
        var resBodyLogin = jsonDecode(res.body);

        if (resBodyLogin['success'] == true) {
          User userInfo = User.fromJson(resBodyLogin['userData']);// запись полных данных пользователя в User.dart
          await RememberUserPrefs.saveUserInfo(userInfo);
          saveLogin();
          loadLogin();
          Future.delayed(Duration(milliseconds: 2000), () {
            Get.to(MainBoardScreen(page: 0));
          });
        } else {
          Fluttertoast.showToast(msg: "Введены некорректные данные.");
        }
      }else{print(res.statusCode);}
    } catch (e) {
      print(e.toString());
    }
  }

  saveLogin() async{
    SharedPreferences pre = await SharedPreferences.getInstance();
    pre.setString("user_login", user_login);
  }
  loadLogin() async{
    SharedPreferences pre = await SharedPreferences.getInstance();
    String data = pre.getString("user_login") ?? "";
  print(data);}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F3),
      body: LayoutBuilder(
        builder: (context, cons) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: cons.maxHeight,
            ),
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // login screen
                  Padding(
                    padding: EdgeInsets.only(left: 30, right: 30, top: Dimensions.screenHeight/4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // login-password + login button
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 150,
                            height: 150,
                            child: Image(
                              image: AssetImage('images/icon_user.png'),
                              color: Colors.amber,
                            ),
                          ),
                        ),
                        SizedBox(height: 50),
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              //email
                              TextFormField(

                                controller: loginController,
                                validator: (val) => val == ""
                                    ? "Пожалуйста введите логин"
                                    : null,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.account_circle,
                                    color: Colors.amber,
                                  ),
                                  hintText: "Логин",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                      color: Colors.amber,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                      color: Colors.amber,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                      color: Colors.amber,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                      color: Colors.amber,
                                    ),
                                  ),
                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                              ),

                              const SizedBox(
                                height: 18,
                              ),

                              //password
                              Obx(
                                    () => TextFormField(
                                  controller: passwordController,
                                  obscureText: isObsecure.value,
                                  validator: (val) => val == ""
                                      ? "Пожалуйста введите пароль"
                                      : null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.password,
                                      color: Colors.amber,
                                    ),
                                    suffixIcon: Obx(
                                          () => GestureDetector(
                                        onTap: () {
                                          isObsecure.value =
                                          !isObsecure.value;
                                        },
                                        child: Icon(
                                          isObsecure.value
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    hintText: "Пароль",
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),


                                      borderSide: const BorderSide(
                                        color: Colors.amber,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.amber,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.amber,
                                      ),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.amber,
                                      ),
                                    ),
                                    contentPadding:
                                    const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 6,
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Material(

                                child: InkWell(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: 350,
                                        height: 50,
                                        child: RawMaterialButton(
                                          fillColor: Colors.amber,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: Text(
                                            "Войти",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          onPressed: () {
                                            if (formKey.currentState!.validate()) {
                                              loginUser();}
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),

                        // text-button (регистрация)
                        Row(

                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            const Text("У вас нет учетной записи?"),
                            TextButton(
                              onPressed: () {
                                Get.to(SignupScreen());
                              },
                              child: const Text(
                                "Регистрация",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                  ),
                ],
              ),
            ),

          );
        },
      ),
    );
  }
}
