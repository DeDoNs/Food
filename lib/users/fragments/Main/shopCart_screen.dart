import 'dart:async';
import 'dart:convert';

import 'package:animated_toggle/animated_toggle.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:regester/api_connection/api_connection.dart';
import 'package:regester/height_screen/dimensions.dart';
import 'package:http/http.dart' as http;
import 'package:regester/users/fragments/Main/board.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopCart extends StatefulWidget {
  const ShopCart({
    super.key,
  });

  @override
  State<ShopCart> createState() => _ShopCartState();
}

class _ShopCartState extends State<ShopCart> {

  var floorController = TextEditingController();
  var timeController = TextEditingController();
  bool backSpace = false;
  int previousLength = 0;
  final KeyboardVisibilityController _keyboardVisibilityController = KeyboardVisibilityController();
  late StreamSubscription<bool> _keyboardVisibilitySubscription;
  bool isTextFromField = false;

  static int valueToggle = 0;

  bool _isLoading = true;

  String priceUpdateSt = "";
  int priceUpdate = 0;
  String price_string = "";
  int price_int = 0;
  int price_all = 0;
  String price_all_string = "";

  String id = "";
  int cart_status = 0;
  String cart = "";
  String cart1 = "";
  int cart_all = 0;
  String cart_update = "";
  List update_number = [];

  int num_cart = 0;
  int num_rows = 0;

  String _priceAll = "0";
  List _id = [];
  List _idItem = [];
  List _numberItem = [];
  List _priceOne = [];
  List _priceFull = [];
  List _priceFullAll = [];
  List _nameItem = [];
  List _imgMain = [];
  List _keyState = [];
  List _mass = [];
  List _calories = [];
  List _belki = [];
  List _fats = [];
  List _carbons = [];

  Future loadItem() async {
    try {
      SharedPreferences pre = await SharedPreferences.getInstance();
      var resp = await http.post(
        Uri.parse(API.loadCart),
        body: {
          'user_login': pre.getString("user_login") ?? "",
        },
      );
      if (resp.statusCode == 200) {
        //200 - API OK
        setState(() {
          final data = jsonDecode(resp.body);
          num_rows = data['num'];
          _id = data['dataId'];
          _idItem = data['dataIdItem'];
          _nameItem = data['dataNameItem'];
          _imgMain = data['dataImgMainItem'];
          _keyState = data['dataKeyStateItem'];
          _calories = data['dataCaloriesItem'];
          _belki = data['dataBelkiItem'];
          _fats = data['dataFatsItem'];
          _carbons = data['dataCarbonsItem'];
          _numberItem = data['dataNumberItem'];
          _priceOne = data['dataPriceOne'];
          _priceFull = data['dataPriceFull'];
          _priceFullAll = data['dataPriceFullAll'];
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future deleteItemCart() async {
    try {
      var resp = await http.post(
        Uri.parse(API.deleteCart),
        body: {
          'key' : '',
          'id': id
        },
      );
      if (resp.statusCode == 200) {
        loadItem();
      } //200 - API OK
    } catch (e) {
      print(e.toString());
    }
  }

  Future updateNumber() async {
    try {
      var resp = await http.post(
        Uri.parse(API.updateNumber),
        body: {'number_item': cart_update, 'id': id},
      );
      if (resp.statusCode == 200) {
        //200 - API OK
        setState(() {
          final data = jsonDecode(resp.body);
          _numberItem = data['number_update'];
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future updatePrice() async {
    try {
      var resp = await http.post(
        Uri.parse(API.updatePrice),
        body: {'price_full': priceUpdate.toString(), 'id': id},
      );
      if (resp.statusCode == 200) {
        //200 - API OK
        setState(() {
          final data = jsonDecode(resp.body);
          _priceFull = data['price_update'];
        });
        loadItem();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future saveOrder() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      var resp = await http.post(
        Uri.parse(API.saveOrder),
        body: {
          'id_item': _idItem.toString(),
          'number_item': _numberItem.toString(),
          'user_login': pref.getString("user_login") ?? "",
          'key_order': valueToggle.toString(),
          'floor': floorController.text.trim().toString(),
          'time': timeController.text.trim().toString(),
          'full_price': _priceFullAll[0]['SUM(price_full)']
        },
      );
      if (resp.statusCode == 200) {
        deleteFullCart();
      } //200 - API OK
    } catch (e) {
      print(e.toString());
    }
  }

  Future deleteFullCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var resp = await http.post(
        Uri.parse(API.deleteCart),
        body: {
          'key' : 'full',
          'login_user': prefs.getString("user_login") ?? ""
        },
      );
      if (resp.statusCode == 200) {
        Navigator.pop(context);
        loadItem();
      } //200 - API OK
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    loadItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Корзина",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: Dimensions.font24,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          elevation: 0,
        ),
        backgroundColor: Color(0xFFF5F5F3),
        body: Column(children: [
        ],),
      );}
    else {
      if (num_rows == 0) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              "Корзина",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: Dimensions.font24,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            elevation: 0,
          ),
          backgroundColor: Color(0xFFF5F5F3),
          body: Center(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
                  child: Column(
                    children: [
                      Text(
                        "Ой, пусто!",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: Dimensions.font24,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: Dimensions.height10),
                      Container(
                        padding: EdgeInsets.only(
                            left: Dimensions.width40, right: Dimensions.width40),
                        child: Text(
                          "Ваша корзина пуста, откройте «Меню» и выберите понравившийся товар.",
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: Dimensions.font12,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.height10),
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
                                "Перейти в меню",
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MainBoardScreen(page: 1)));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
            ),
          )
        );
      } else {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                "Корзина",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: Dimensions.font24,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              elevation: 0,
            ),
            backgroundColor: Color(0xFFF5F5F3),
            body: Padding(
              padding: EdgeInsets.only(top: 0),
              child: Column(children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        ListView.separated(
                            padding: EdgeInsets.zero,
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _numberItem == null ? 0 : _numberItem.length,
                            separatorBuilder: (context, index) => Divider(color: Colors.black26, height: 2, thickness: 0.5),
                            itemBuilder: (context, index) {
                              cart = _numberItem[index]['number_item'];
                              cart_all = int.parse(cart);
                              return Container(
                                margin: EdgeInsets.only(
                                    top: index==0 ? 0 : 10,
                                    left: Dimensions.width20,
                                    right: Dimensions.width20,
                                    bottom: 10),
                                child: Row(
                                  children: [
                                    SizedBox(width: Dimensions.width20),
                                    Container(
                                      width: Dimensions.listViewImgSizeCart,
                                      height: Dimensions.listViewImgSizeCart,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(Dimensions.radius15),
                                          color: Colors.white38,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(API.loadImagelib + _imgMain[index]['imgMain_item']),
                                          )),
                                    ),
                                    Stack(alignment: Alignment.bottomRight,
                                        children: [
                                          Container(
                                            height: Dimensions.listViewTextContSizeCart,
                                            width: Dimensions.listViewTextContWedthCart,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(topRight: Radius.circular(Dimensions.radius20), bottomRight: Radius.circular(Dimensions.radius20)),
                                              color: Colors.white,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: Dimensions.width20,
                                                  right: Dimensions.width20),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(top: 10),
                                                      child: Text(
                                                        _nameItem[index]['name_item'],
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontSize: Dimensions.font18,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(bottom: 5),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.all(5.0),
                                                            decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  _priceFull[index]['price_full'],
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: TextStyle(
                                                                    fontFamily: 'Roboto',
                                                                    fontSize: Dimensions
                                                                        .font12,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight: FontWeight
                                                                        .w700,
                                                                  ),
                                                                ),
                                                                SizedBox(width: 2),
                                                                Text(
                                                                  "₽",
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  style: TextStyle(
                                                                    fontFamily: 'Roboto',
                                                                    fontSize: Dimensions
                                                                        .font12,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight: FontWeight
                                                                        .w700,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(right: 10, bottom: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: Dimensions.height30,
                                                  width: 90,
                                                  padding: EdgeInsets.all(5.0),
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey.shade200,
                                                      borderRadius: BorderRadius.all(Radius.circular(100.0))),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      IconButton(
                                                        constraints: const BoxConstraints(minWidth: 22, maxWidth: 22),
                                                        splashRadius: 0.0001,
                                                        padding: EdgeInsets.only(top: 2),
                                                        onPressed: (){
                                                          cart = _numberItem[index]['number_item'];
                                                          cart_all = int.parse(cart);
                                                          if (cart_all > 1) {
                                                            cart = _numberItem[index]['number_item'];
                                                            cart_all = int.parse(cart);
                                                            cart_all--;
                                                            id = _id[index]['id'];
                                                            cart_update = cart_all.toString();
                                                            updateNumber();
                                                            setState(() {
                                                              cart = _numberItem[index]
                                                              ['number_item'];
                                                              cart_all = int.parse(cart);
                                                              priceUpdate = int.parse(_priceFull[index]['price_full']) - int.parse(_priceOne[index]['price_one']);
                                                            });
                                                            updatePrice();
                                                          } else {
                                                            id = _id[index]['id'];
                                                            setState(() {
                                                              deleteItemCart();
                                                            });
                                                          }
                                                        },
                                                        icon: Icon(Icons.remove, size: Dimensions.iconSize18),
                                                      ),
                                                      Text(
                                                          cart_all.toString(),
                                                          textAlign: TextAlign.center,
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            fontFamily: 'Roboto',
                                                            fontSize: Dimensions.font12,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      IconButton(
                                                        constraints: const BoxConstraints(minWidth: 22, maxWidth: 22),
                                                        splashRadius: 0.0001,
                                                        padding: EdgeInsets.only(top: 2),
                                                        onPressed: (){
                                                          cart = _numberItem[index]['number_item'];
                                                          cart_all = int.parse(cart);
                                                          cart_all++;
                                                          id = _id[index]['id'];
                                                          cart_update = cart_all.toString();
                                                          updateNumber();
                                                          setState(() {cart = _numberItem[index]['number_item'];cart_all = int.parse(cart);priceUpdate = int.parse(_priceFull[index]['price_full']) + int.parse(_priceOne[index]['price_one']);
                                                          updatePrice();
                                                          });
                                                        },
                                                        icon: Icon(Icons.add, color: Colors.black, size: Dimensions.iconSize18),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]),
                                  ],
                                ),
                              );
                            }),
                        Divider(color: Colors.black26, height: 2, thickness: 0.5),
                        SizedBox(height: Dimensions.height10),
                        Container(
                          padding: EdgeInsets.only(
                              left: Dimensions.width30,
                              right: Dimensions.width30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Итого",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: Dimensions.font24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    _priceFullAll[0]['SUM(price_full)'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: Dimensions.font24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    " ₽",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: Dimensions.font18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: Dimensions.width30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                num_rows==1 ? "${num_rows} позиция" : num_rows>=2 && num_rows<=4 ? "${num_rows} позиции" : "${num_rows} позиций",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: Dimensions.font12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              IconButton(
                                  constraints: const BoxConstraints(minWidth: 22, maxWidth: 22),
                                  splashRadius: 0.0001,
                                  padding: EdgeInsets.only(top: 2),
                                  onPressed: (){
                                    showDialog(context: context, builder: (BuildContext context){
                                      return AlertDialog(
                                        title: Text(
                                          "Итого",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: Dimensions.font18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        titlePadding: EdgeInsets.only(top: 15, left: 15),
                                        contentPadding: EdgeInsets.only(top: 15, left: 15, right: 15),
                                        content: Container(
                                          height: 100,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Пищевая ценность",
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: Dimensions.font12,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${_calories[0]['SUM(calories_item)']} ккал",
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: Dimensions.font12,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Белки",
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: Dimensions.font12,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${_belki[0]['SUM(belki_item)']} г",
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: Dimensions.font12,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Жиры",
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: Dimensions.font12,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${_fats[0]['SUM(fats_item)']} г",
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: Dimensions.font12,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Углеводы",
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: Dimensions.font12,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${_carbons[0]['SUM(carbons_item)']} г",
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: Dimensions.font12,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );});
                                  },
                                  icon: Icon(Icons.info_outline, size: Dimensions.iconSize12, color: Colors.grey,))
                            ],
                          ),
                        ),
                        SizedBox(height: 10)
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Stack(
                      children: [
                        Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Container(
                            width: Dimensions.screenWedth,
                            height: Dimensions.BottomButtonAddCart,
                            color: Colors.white,
                            child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                  Container(
                                    width: Dimensions.buttonfullwidgt,
                                    height: Dimensions.height45,
                                    child: RawMaterialButton(
                                      fillColor: Colors.amber,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      elevation: 2,
                                      onPressed: () {
                                        showModalBottomSheet(context: context,
                                            isDismissible: false,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (context) {
                                              return StatefulBuilder(builder: (BuildContext context, StateSetter setModalState){
                                                _keyboardVisibilitySubscription = _keyboardVisibilityController.onChange.listen((bool visible) {
                                                  if(visible){
                                                    setModalState(() {
                                                      isTextFromField = true;
                                                    });
                                                  }else{
                                                    setModalState(() {
                                                      isTextFromField = false;
                                                    });
                                                  }
                                                });
                                                    return Container(
                                                            height: Dimensions.screenHeight/1.07,
                                                            decoration: BoxDecoration(
                                                              color: Color(0xFFF5F5F3),
                                                              borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets.only(left: 20, right: 6, top: 6),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        "Оформление заказа",
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                          fontFamily: 'Roboto',
                                                                          fontSize: Dimensions.font24,
                                                                          color: Colors.black,
                                                                          fontWeight: FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                      RawMaterialButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                                        constraints: BoxConstraints.tight(Size(40, 40)),
                                                                        highlightColor: Colors.transparent,
                                                                        onPressed: () {
                                                                          Navigator.pop(context);
                                                                        },
                                                                        child: Icon(
                                                                          Icons.close,
                                                                          color: Colors.amber,
                                                                          size: Dimensions.iconSize24,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(height: 15),
                                                                AnimatedHorizontalToggle(
                                                                  taps: const ['В заведении', 'На доставку'],
                                                                  width: MediaQuery.of(context).size.width - 40,
                                                                  height: 35,
                                                                  duration: const Duration(milliseconds: 100),
                                                                  initialIndex: valueToggle,
                                                                  background: Colors.grey.shade300,
                                                                  activeColor: Colors.white,
                                                                  activeTextStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500,),
                                                                  inActiveTextStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400,),
                                                                  // the next 2 line if you need to put padding for the inactive buttons
                                                                  horizontalPadding: 4,
                                                                  verticalPadding: 4,
                                                                  // the next 2 line if you need to put padding for the active button
                                                                  activeHorizontalPadding: 1,
                                                                  activeVerticalPadding: 3,
                                                                  radius: 10,
                                                                  // you can control the radius for the Animated widget
                                                                  activeButtonRadius: 10,
                                                                  // you can control the radius for the active button
                                                                  onChange: (int currentIndex, int targetIndex) {
                                                                    if(valueToggle!=targetIndex){
                                                                      valueToggle = targetIndex;
                                                                      setModalState(() {});
                                                                    }
                                                                  },
                                                                  showActiveButtonColor: true,
                                                                  local: 'en',
                                                                ),
                                                                SizedBox(height: 15),
                                                                ConstrainedBox(
                                                                  constraints: BoxConstraints(maxHeight: isTextFromField == false ? (Dimensions.screenHeight/1.07)/2.3 : (Dimensions.screenHeight/1.07)/4.8),
                                                                    child: CupertinoScrollbar(
                                                                      thumbVisibility: true,
                                                                      child: SingleChildScrollView(
                                                                        physics: BouncingScrollPhysics(),
                                                                          child: ListView.separated(
                                                                              padding: EdgeInsets.zero,
                                                                              physics: BouncingScrollPhysics(),
                                                                              shrinkWrap: true,
                                                                              itemCount: _numberItem == null ? 0 : _numberItem.length,
                                                                              separatorBuilder: (context, index) => Divider(color: Colors.black26, height: 2, thickness: 0.5),
                                                                              itemBuilder: (context, index) {
                                                                                cart = _numberItem[index]['number_item'];
                                                                                cart_all = int.parse(cart);
                                                                                return Container(
                                                                                  margin: EdgeInsets.only(
                                                                                      top: index==0 ? 0 : 10,
                                                                                      bottom: 10),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Container(
                                                                                        padding: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                                                                                        height: Dimensions.listViewTextContSizeCart/1.2,
                                                                                        width: Dimensions.listViewTextContWedthCart*1.45,
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius20)),
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                        child: Padding(
                                                                                          padding: EdgeInsets.only(
                                                                                              left: Dimensions.width20,
                                                                                              right: Dimensions.width20),
                                                                                          child: Row(
                                                                                            children: [
                                                                                              Container(
                                                                                                child: Text(
                                                                                                  '${_numberItem[index]['number_item']}',
                                                                                                  textAlign: TextAlign.center,
                                                                                                  maxLines: 1,
                                                                                                  overflow: TextOverflow.ellipsis,
                                                                                                  style: TextStyle(
                                                                                                    fontFamily: 'Roboto',
                                                                                                    fontSize: Dimensions.font16,
                                                                                                    color: Colors.black,
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              Text(
                                                                                                'x',
                                                                                                textAlign: TextAlign.center,
                                                                                                maxLines: 1,
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                                style: TextStyle(
                                                                                                  fontFamily: 'Roboto',
                                                                                                  fontSize: Dimensions.font12,
                                                                                                  color: Colors.black,
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(width: Dimensions.width30),
                                                                                              VerticalDivider(color: Colors.black26, width: 2, thickness: 0.5),
                                                                                              SizedBox(width: Dimensions.width30),
                                                                                              Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Expanded(
                                                                                                    child: Container(
                                                                                                      margin: EdgeInsets.only(top: 5),
                                                                                                      child: Text(
                                                                                                        _nameItem[index]['name_item'],
                                                                                                        maxLines: 1,
                                                                                                        overflow: TextOverflow.ellipsis,
                                                                                                        style: TextStyle(
                                                                                                          fontFamily: 'Roboto',
                                                                                                          fontSize: Dimensions.font18,
                                                                                                          color: Colors.black,
                                                                                                          fontWeight: FontWeight.w700,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Expanded(
                                                                                                    child: Container(
                                                                                                      margin: EdgeInsets.only(bottom: 5),
                                                                                                      child: Row(
                                                                                                        children: [
                                                                                                          Container(
                                                                                                            padding: EdgeInsets.all(5.0),
                                                                                                            decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                                                            child: Row(
                                                                                                              mainAxisAlignment:
                                                                                                              MainAxisAlignment.start,
                                                                                                              children: [
                                                                                                                Text(
                                                                                                                  _priceFull[index]['price_full'],
                                                                                                                  maxLines: 1,
                                                                                                                  overflow: TextOverflow
                                                                                                                      .ellipsis,
                                                                                                                  style: TextStyle(
                                                                                                                    fontFamily: 'Roboto',
                                                                                                                    fontSize: Dimensions
                                                                                                                        .font12,
                                                                                                                    color: Colors
                                                                                                                        .black,
                                                                                                                    fontWeight: FontWeight
                                                                                                                        .w700,
                                                                                                                  ),
                                                                                                                ),
                                                                                                                SizedBox(width: 2),
                                                                                                                Text(
                                                                                                                  "₽",
                                                                                                                  maxLines: 1,
                                                                                                                  overflow: TextOverflow
                                                                                                                      .ellipsis,
                                                                                                                  style: TextStyle(
                                                                                                                    fontFamily: 'Roboto',
                                                                                                                    fontSize: Dimensions
                                                                                                                        .font12,
                                                                                                                    color: Colors
                                                                                                                        .black,
                                                                                                                    fontWeight: FontWeight
                                                                                                                        .w700,
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              }),
                                                                  ),
                                                                    ),
                                                                ),
                                                                Divider(color: Colors.black26, height: 2, thickness: 0.5),
                                                                Visibility(
                                                                  visible: valueToggle == 1 ? true : false,
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsets.only(left: 25, top: 10),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              'Доставка',
                                                                              textAlign: TextAlign.center,
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(
                                                                                fontFamily: 'Roboto',
                                                                                fontSize: Dimensions.font18,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.w700,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(height: 10),
                                                                      Padding(
                                                                        padding: EdgeInsets.only(left: 15, right: 15),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Container(
                                                                                  width: Dimensions.screenWedth/2.2,
                                                                                  height: 50,
                                                                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child:
                                                                                        TextFormField(
                                                                                          onTap: (){

                                                                                          },
                                                                                          keyboardType: TextInputType.phone,
                                                                                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp("[0-9]")),],
                                                                                          controller: floorController,
                                                                                          maxLength: 2,
                                                                                          decoration: InputDecoration(
                                                                                            counterText: "",
                                                                                            labelText: "Этаж",
                                                                                            labelStyle: TextStyle(
                                                                                            fontSize: Dimensions.iconSize12,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            color: Colors.grey
                                                                                            ),
                                                                                            border: InputBorder.none,
                                                                                            fillColor: Colors.transparent,
                                                                                            filled: true,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      floorController.text.trim()!="" ? IconButton(onPressed: (){
                                                                                        FocusManager.instance.primaryFocus?.unfocus();
                                                                                        setModalState(() {
                                                                                          floorController.clear();
                                                                                        });
                                                                                        }, icon: Icon(Icons.close, color: Colors.grey, size: 18,), splashRadius: 20) : Container()
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              Container(
                                                                                  width: Dimensions.screenWedth/2.2,
                                                                                  height: 50,
                                                                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child:
                                                                                        TextFormField(
                                                                                          onChanged: (text){
                                                                                            final RegExp numRegExp = RegExp('[a-zA-Z]');
                                                                                            setModalState(() {
                                                                                              if(previousLength > text.length){backSpace = true;}else{backSpace = false;}
                                                                                              previousLength = text.length;
                                                                                            });
                                                                                            if(!numRegExp.hasMatch(text)){
                                                                                              if(text.length == 2){
                                                                                                if(backSpace == false){
                                                                                                  String value1=text.trim();
                                                                                                  try
                                                                                                  {
                                                                                                    int.parse(value1);
                                                                                                    String s = timeController.text.replaceRange(text.length, text.length, ':');
                                                                                                    timeController.text = s;
                                                                                                    timeController.selection = TextSelection.fromPosition(TextPosition(offset: timeController.text.length));
                                                                                                  }catch(e){}
                                                                                                }
                                                                                              }
                                                                                            }
                                                                                          },
                                                                                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r"[0-9:]")),],
                                                                                          keyboardType: TextInputType.phone,
                                                                                          controller: timeController,
                                                                                          maxLength: 5,
                                                                                          decoration: InputDecoration(
                                                                                            counterText: "",
                                                                                            labelText: "Время",
                                                                                            labelStyle: TextStyle(
                                                                                                fontSize: Dimensions.iconSize12,
                                                                                                fontWeight: FontWeight.w500,
                                                                                                color: Colors.grey
                                                                                            ),
                                                                                            border: InputBorder.none,
                                                                                            fillColor: Colors.transparent,
                                                                                            filled: true,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      timeController.text.trim()!="" ? IconButton(onPressed: (){
                                                                                        FocusManager.instance.primaryFocus?.unfocus();
                                                                                        setModalState(() {
                                                                                          timeController.clear();
                                                                                        });
                                                                                      }, icon: Icon(Icons.close, color: Colors.grey, size: 18,), splashRadius: 20) : Container()
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                    ],
                                                                  )
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsets.only(left: 25, top: 10),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            'Оплата',
                                                                            textAlign: TextAlign.center,
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: TextStyle(
                                                                              fontFamily: 'Roboto',
                                                                              fontSize: Dimensions.font18,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w700,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 10),
                                                                    Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                            padding: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                                                                            height: Dimensions.height45,
                                                                            width: Dimensions.listViewTextContWedthCart*1.45,
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                              color: Colors.white,
                                                                            ),
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: EdgeInsets.only(left: 5),
                                                                                      child: Icon(Icons.credit_card, size: Dimensions.iconSize18),
                                                                                    ),
                                                                                    SizedBox(width: 10),
                                                                                    Text(
                                                                                      'Картой в приложении',
                                                                                      textAlign: TextAlign.center,
                                                                                      maxLines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: TextStyle(
                                                                                        fontFamily: 'Roboto',
                                                                                        fontSize: Dimensions.font12,
                                                                                        color: Colors.black,
                                                                                        fontWeight: FontWeight.w500,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                IconButton(
                                                                                  constraints: const BoxConstraints(minWidth: 22, maxWidth: 22),
                                                                                  splashRadius: 0.0001,
                                                                                  padding: EdgeInsets.only(top: 2),
                                                                                  onPressed: (){},
                                                                                  icon: Icon(Icons.arrow_forward_ios),
                                                                                  iconSize: Dimensions.iconSize18,
                                                                                )
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                  ],
                                                                ),
                                                                Expanded(
                                                                  child: Align(
                                                                    alignment: FractionalOffset.bottomCenter,
                                                                    child: Stack(
                                                                        children:[
                                                                          Align(
                                                                            alignment: FractionalOffset.bottomCenter,
                                                                            child: Container(
                                                                              width: Dimensions.screenWedth,
                                                                              height: Dimensions.BottomButtonAddCart*1.55,
                                                                              color: Colors.white,
                                                                              child: Padding(
                                                                                padding: EdgeInsets.only(top: Dimensions.height15, bottom: Dimensions.height15, left: 20, right: 20),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      "Стоимость заказа",
                                                                                      maxLines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: TextStyle(
                                                                                        fontFamily: 'Roboto',
                                                                                        fontSize: Dimensions.font18,
                                                                                        color: Colors.black,
                                                                                        fontWeight: FontWeight.w500,
                                                                                      ),
                                                                                    ),
                                                                                    Text(
                                                                                      "${_priceFullAll[0]['SUM(price_full)']} ₽",
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
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Align(
                                                                            alignment: FractionalOffset.bottomCenter,
                                                                            child: Container(
                                                                              margin: EdgeInsets.only(bottom: Dimensions.height15),
                                                                              width: Dimensions.buttonfullwidgt,
                                                                              height: Dimensions.height45,
                                                                              child: RawMaterialButton(
                                                                                fillColor: Colors.amber,
                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),),
                                                                                elevation: 2,
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text(
                                                                                      "Оплатить",
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
                                                                                  if(valueToggle==1){
                                                                                    if(floorController.text.trim()=="" || timeController.text.trim()==""){
                                                                                      DelightToastBar(
                                                                                        autoDismiss: true,
                                                                                        builder: (context) => const ToastCard(
                                                                                          leading: Icon(
                                                                                            Icons.error_outline,
                                                                                            color: Colors.red,
                                                                                            size: 28,
                                                                                          ),
                                                                                          title: Text(
                                                                                            "Заполните все поля!",
                                                                                            style: TextStyle(
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: 18,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ).show(context);
                                                                                    }else{
                                                                                      DelightToastBar(
                                                                                        autoDismiss: true,
                                                                                        builder: (context) => const ToastCard(
                                                                                          leading: Icon(
                                                                                            Icons.check_circle,
                                                                                            color: Colors.green,
                                                                                            size: 28,
                                                                                          ),
                                                                                          title: Text(
                                                                                            "Заказ принят! Статус заказа доступен в профиле.",
                                                                                            style: TextStyle(
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: 18,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ).show(context);
                                                                                      saveOrder();
                                                                                    }
                                                                                  }else{
                                                                                    DelightToastBar(
                                                                                      autoDismiss: true,
                                                                                      builder: (context) => const ToastCard(
                                                                                        leading: Icon(
                                                                                          Icons.check_circle,
                                                                                          color: Colors.green,
                                                                                          size: 28,
                                                                                        ),
                                                                                        title: Text(
                                                                                          "Успешно, спасибо за покупку!",
                                                                                          style: TextStyle(
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: 18,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ).show(context);
                                                                                    saveOrder();
                                                                                  }
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ]
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                  ),
                                                );});
                                            });
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Оформить заказ на ${_priceFullAll[0]['SUM(price_full)']} ₽",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: Dimensions.font18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],)
                          ),
                        ),
                      ],
                    ),
                  ),
              ]),
            )
        );
      }
    }
  }}