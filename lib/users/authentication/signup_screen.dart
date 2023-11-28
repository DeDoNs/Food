import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:regester/api_connection/api_connection.dart';
import 'package:regester/users/authentication/login_screen.dart';
import 'package:regester/users/model/user.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var loginController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;

  validateUserLogin() async {
    try{
      var res2 = await http.post(
        Uri.parse(API.validateLogin),
        body: {
          'user_login': loginController.text.trim(),
        },
      );

      if(res2.statusCode == 200){  //200 - API OK
        var resBody = jsonDecode(res2.body);

        if(resBody['loginFound'] == true){
          Fluttertoast.showToast(msg: "Логин уже использует кто-то другой.");
        }
        else{
          // добавление в базу нового пользователя
          SaveUser();
        }
      }
    }
    catch(e){
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  validateUserEmail() async
  {
    try{
      var res1 = await http.post(
          Uri.parse(API.validateEmail),
          body: {
            'user_email': emailController.text.trim(),
          },
      );

      if(res1.statusCode == 200){  //200 - API OK
        var resBody = jsonDecode(res1.body);

        if(resBody['emailFound'] == true){
          Fluttertoast.showToast(msg: "Email уже использует кто-то другой.");
        }
        else{
          // проверка login
          validateUserLogin();
        }
      }
    }
    catch(e){
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  SaveUser() async
  {
    User userModel = User(
      1,
      loginController.text.trim(),
      passwordController.text.trim(),
      emailController.text.trim(),
    );

    try{
      var res = await http.post(
        Uri.parse(API.signUp),
        body: userModel.toJson(),
      );

      if(res.statusCode == 200){  //200 - API OK
        var resBodyReg = jsonDecode(res.body);

        if(resBodyReg['success'] == true){
          Fluttertoast.showToast(msg: "Пользователь успешно зарегистрирован.");
          Get.to(LoginScreen());
        }
        else{
          Fluttertoast.showToast(msg: "Произошла ошибка, попробуйте снова.");
        }
        }
    }
    catch(e){
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, cons)
        {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: cons.maxHeight,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [

                  // signup screen

                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 200, 30, 30),
                    child: Column(
                      children: [
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
                        // login-password + login button
                        Form(
                          key: formKey,
                          child: Column(
                            children: [

                              //email
                              TextFormField(
                                controller: emailController,
                                validator: (val) => val != null && !EmailValidator.validate(val) ? "Пожалуйста введите корректный Email": null,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.email,
                                    color: Colors.black,
                                  ),
                                  hintText: "Email",
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
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                              ),

                              const SizedBox(height: 18,),

                              //login
                              TextFormField(
                                controller: loginController,
                                validator: (val) => val == "" ? "Пожалуйста введите логин": null,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.account_circle,
                                    color: Colors.black,
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
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                              ),

                              const SizedBox(height: 18,),

                              //password
                              Obx(
                                    ()=> TextFormField(
                                  controller: passwordController,
                                  obscureText: isObsecure.value,
                                  validator: (val) => val == "" ? "Пожалуйста введите пароль": null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.vpn_key_sharp,
                                      color: Colors.black,
                                    ),
                                    suffixIcon: Obx(
                                          ()=> GestureDetector(
                                        onTap: ()
                                        {
                                          isObsecure.value = !isObsecure.value;
                                        },
                                        child: Icon(
                                          isObsecure.value ? Icons.visibility_off : Icons.visibility,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    hintText: "Пароль",
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
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 6,
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20,),

                              //button
                              Material(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(30),
                                child: InkWell(
                                  onTap: (){
                                    if(formKey.currentState!.validate()){
                                      //проверка email
                                      validateUserEmail();
                                    }
                                    else{
                                      Fluttertoast.showToast(msg: "Заполните все поля.");
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                    height: 50,
                                    width: 350,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 28,
                                          ),
                                          child: Text(
                                            "Зарегистрироваться",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // text-button (войти)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                                "У вас уже есть учетная запись?"
                            ),
                            TextButton(
                              onPressed: ()
                              {
                                Get.to(LoginScreen());
                              },
                              child: const Text(
                                "Войти",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
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
