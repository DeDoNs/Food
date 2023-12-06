import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
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
  List _nameItem = [];
  List _imgMain = [];
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
          _calories = data['dataCaloriesItem'];
          _belki = data['dataBelkiItem'];
          _fats = data['dataFatsItem'];
          _carbons = data['dataCarbonsItem'];
          _numberItem = data['dataNumberItem'];
          _priceOne = data['dataPriceOne'];
          _priceFull = data['dataPriceFull'];
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future sumload() async {
    try {
      SharedPreferences pre = await SharedPreferences.getInstance();
      var resp1 = await http.post(
        Uri.parse(API.sumLoad),
        body: {
          'user_login': pre.getString("user_login") ?? "",
        },
      );
      if (resp1.statusCode == 200) {
        //200 - API OK
        setState(() {
          final data = jsonDecode(resp1.body);
          _priceAll = data['SUM(price_full)'];
        });
      }
    } catch (e) {
      _priceAll = "0";
      print(e.toString());
    }
  }

  Future deleteItemCart() async {
    try {
      var resp = await http.post(
        Uri.parse(API.deleteCart),
        body: {'id': id},
      );
      if (resp.statusCode == 200) {
        loadItem();
        sumload();
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
        sumload();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    sumload();
    loadItem();
    super.initState();
    Timer(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Color(0xFFF5F5F3),
        body: Column(children: [
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top*1.8, bottom: Dimensions.height15),
            padding: EdgeInsets.only(
                left: Dimensions.width20, right: Dimensions.width20),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
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
            ]),
          ),
          Container(
            padding: EdgeInsets.only(top: Dimensions.screenHeight / 3),
            child: JumpingDotsProgressIndicator(
              fontSize: 50.0,
            ),
          )
        ],),
      );}
    else {
      if (num_rows == 0) {
        return Scaffold(
          backgroundColor: Color(0xFFF5F5F3),
          body: Column(children: [
            Container(
              margin: EdgeInsets.only(top: Dimensions.height40, bottom: Dimensions.height15),
              padding: EdgeInsets.only(
                  left: Dimensions.width20, right: Dimensions.width20),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(
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
              ]),
            ),
            Container(
              padding: EdgeInsets.only(top: Dimensions.screenHeight / 3),
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
                        left: Dimensions.width50, right: Dimensions.width50),
                    child: Text(
                      "Ваша корзина пуста, откройте «Меню» и выберите понравившийся товар.",
                      maxLines: 2,
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
            )
          ],),
        );
      } else {
        return Scaffold(
            backgroundColor: Color(0xFFF5F5F3),
            body: Column(children: [
              Container(
                margin: EdgeInsets.only(top: Dimensions.height40, bottom: Dimensions.height15),
                padding: EdgeInsets.only(
                    left: Dimensions.width20, right: Dimensions.width20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text(
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
                ]),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ListView.separated(
                          padding: EdgeInsets.zero,
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _numberItem == null ? 0 : _numberItem
                              .length,
                          separatorBuilder: (context, index) =>
                              Divider(color: Colors.black26,
                                  height: 1,
                                  indent: Dimensions.CartdividerInd,
                                  endIndent: Dimensions.CartdividerEndInd,
                                  thickness: 2),
                          itemBuilder: (context, index) {
                            cart = _numberItem[index]['number_item'];
                            cart_all = int.parse(cart);
                            return Container(
                              margin: EdgeInsets.only(
                                  top: 10,
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
                                        borderRadius:
                                        BorderRadius.circular(
                                            Dimensions.radius15),
                                        color: Colors.white38,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(API.loadImagelib +
                                              _imgMain[index]['imgMain_item']),
                                        )),
                                  ),
                                  Stack(alignment: Alignment.bottomRight,
                                      children: [
                                        Container(
                                          height: Dimensions
                                              .listViewTextContSizeCart,
                                          width: Dimensions
                                              .listViewTextContWedthCart,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight:
                                                Radius.circular(
                                                    Dimensions.radius20),
                                                bottomRight:
                                                Radius.circular(
                                                    Dimensions.radius20)),
                                            color: Colors.white,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: Dimensions.width20,
                                                right: Dimensions.width20),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              children: [
                                                Text(
                                                  _nameItem[index]['name_item'],
                                                  maxLines: 1,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: Dimensions.font18,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.all(
                                                          5.0),
                                                      decoration: BoxDecoration(
                                                          color: Colors.amber,
                                                          borderRadius: BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  10.0))),
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
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: 10, bottom: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: [
                                              Container(
                                                height: Dimensions.height30,
                                                width: 70,
                                                padding: EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                    color: Color(0xFFECEFF1),
                                                    borderRadius: BorderRadius
                                                        .all(
                                                        Radius.circular(
                                                            100.0))),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        cart =
                                                        _numberItem[index]
                                                        ['number_item'];
                                                        cart_all =
                                                            int.parse(cart);
                                                        if (cart_all > 1) {
                                                          cart =
                                                          _numberItem[index]
                                                          ['number_item'];
                                                          cart_all =
                                                              int.parse(cart);
                                                          cart_all--;
                                                          id = _id[index]['id'];
                                                          cart_update = cart_all
                                                              .toString();
                                                          updateNumber();
                                                          setState(() {
                                                            cart =
                                                            _numberItem[index]
                                                            ['number_item'];
                                                            cart_all =
                                                                int.parse(cart);
                                                            priceUpdate =
                                                                int.parse(
                                                                    _priceFull[index]
                                                                    ['price_full']) -
                                                                    int.parse(
                                                                        _priceOne[index]
                                                                        ['price_one']);
                                                          });
                                                          updatePrice();
                                                        } else {
                                                          id = _id[index]['id'];
                                                          setState(() {
                                                            deleteItemCart();
                                                          });
                                                        }
                                                      },
                                                      child: Text(
                                                        "- ",
                                                        maxLines: 1,
                                                        textAlign: TextAlign
                                                            .center,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontSize: Dimensions
                                                              .font8,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight
                                                              .w400,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          top: 5,
                                                          bottom: 5,
                                                          right: 5,
                                                          left: 5),
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape
                                                              .circle,
                                                          color: Colors.white),
                                                      child: Text(
                                                        cart_all.toString(),
                                                        textAlign: TextAlign
                                                            .center,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontSize: 10,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight
                                                              .w500,
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        cart =
                                                        _numberItem[index]
                                                        ['number_item'];
                                                        cart_all =
                                                            int.parse(cart);
                                                        cart_all++;
                                                        id = _id[index]['id'];
                                                        cart_update =
                                                            cart_all.toString();
                                                        updateNumber();
                                                        setState(() {
                                                          cart =
                                                          _numberItem[index]
                                                          ['number_item'];
                                                          cart_all = int.parse(
                                                              cart);
                                                          priceUpdate = int
                                                              .parse(
                                                              _priceFull[index]
                                                              ['price_full']) +
                                                              int.parse(
                                                                  _priceOne[index]
                                                                  ['price_one']);
                                                          updatePrice();
                                                        });
                                                      },
                                                      child: Text(
                                                        "+",
                                                        maxLines: 1,
                                                        textAlign: TextAlign
                                                            .center,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontSize: Dimensions
                                                              .font8,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight
                                                              .w100,
                                                        ),
                                                      ),
                                                    ),
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
                      Divider(color: Colors.black26,
                          height: 1,
                          indent: Dimensions.width30,
                          endIndent: Dimensions.width30,
                          thickness: 0.2),
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
                                  _priceAll,
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
                              "${num_rows} позиции",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: Dimensions.font12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Container(
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
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return Container(
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(30),
                                        topLeft: Radius.circular(30)),
                                  ),
                                  padding: EdgeInsets.only(
                                      bottom: Dimensions.height15,
                                      left: Dimensions.width30),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: Dimensions.height15),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
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
                                            RawMaterialButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(30)),
                                              constraints: BoxConstraints.tight(
                                                  Size(40, 40)),
                                              highlightColor: Colors
                                                  .transparent,
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
                                      Container(
                                        width: Dimensions.buttonfullwidgt,
                                        height: Dimensions.height45,
                                        child: RawMaterialButton(
                                          fillColor: Colors.amber,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                50),
                                          ),
                                          elevation: 2,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
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
                                          onPressed: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Оформить заказ на ${_priceAll} ₽",
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
                  ),
                ],
              ),
            ])
        );
      }
    }
  }}
