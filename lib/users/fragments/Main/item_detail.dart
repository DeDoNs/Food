import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:regester/api_connection/api_connection.dart';
import 'package:regester/users/fragments/Main/board.dart';
import 'package:regester/users/fragments/Main/itemCategories_screen.dart';
import 'package:regester/users/fragments/Main/shopCart_screen.dart';
import 'package:regester/users/fragments/mainboard_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../height_screen/dimensions.dart';

class ItemDetail extends StatefulWidget {
  final String id;
  final int page;
  final int screen;
  final String
      idItem,
      imgMain,
      imgSecond,
      name,
      calories,
      belki,
      fats,
      carbons,
      discription,
      time,
      info,
      price,
      sale,
      idCategories,
      nameCategories;

  const ItemDetail(
      {super.key,
      required this.id,
      required this.idItem,
      required this.imgMain,
      required this.imgSecond,
      required this.name,
      required this.discription,
      required this.calories,
      required this.belki,
      required this.fats,
      required this.carbons,
      required this.time,
      required this.info,
      required this.price,
      required this.screen,
      required this.sale,
      required this.page,
      required this.idCategories,
      required this.nameCategories});

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {

  String dataLogin="";
  int num_cart=1;

  loadLogin() async{
    SharedPreferences pre = await SharedPreferences.getInstance();
    dataLogin = pre.getString("user_login") ?? "";
    print(dataLogin);}

  saveCart() async{
    int price = int.parse(widget.price);
    int price_all = price*num_cart;
    try{
      var res = await http.post(
        Uri.parse(API.saveCart),
        body: {
          'id_ItemCart': widget.idItem,
          'name_ItemCart' : widget.name,
          'imgMain_ItemCart' : widget.imgMain,
          'calories_itemCart' : widget.calories,
          'belki_itemCart' : widget.belki,
          'fats_itemCart' : widget.fats,
          'carbons_itemCart' : widget.carbons,
          'user_login' : dataLogin,
          'number_ItemCart': num_cart.toString(),
          'price_one': widget.price,
          'price_full': price_all.toString(),
        },
      );
      if(res.statusCode == 200){  //200 - API OK
      }
    }
    catch(e){
      print(e.toString());
    }
  }

  @override
  void initState() {
    loadLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 50,
                  left: 0,
                  right: 25,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RawMaterialButton(
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        if (widget.screen == 1) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemCategories(page: widget.page, idCategories: widget.idCategories, nameCategories: widget.nameCategories),
                              ));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MainBoardScreen(page: widget.page),
                              ));
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(spreadRadius: 2, color: Colors.grey.withOpacity(0.5), blurRadius: 10, offset: Offset(0,3))],
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_back_ios_sharp,
                              color: Colors.black,
                              size: Dimensions.iconSize24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: Dimensions.itemScreenHeight,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(flex: 1, child: Container()),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50),
                                    topRight: Radius.circular(50)),
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        child: Image.network(
                          API.loadImagelib + widget.imgSecond,
                          fit: BoxFit.cover,
                        ),
                        margin: EdgeInsets.all(15),
                        width: 220,
                        height: 220,
                      ),
                    ),
                  ],
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: Dimensions.itemScreenDesc),
                child: Container(
                  padding: EdgeInsets.only(
                      right: Dimensions.width20,
                      left: Dimensions.width20,
                      bottom: Dimensions.height10),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Text(
                        widget.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: Dimensions.font24,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: Dimensions.height10),
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Row(
                          children: [
                            Icon(Icons.access_time_outlined,
                                color: Colors.blue, size: Dimensions.iconSize12),
                            SizedBox(width: 5),
                            Text(
                              widget.time,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: Dimensions.font12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        Row(
                          children: [
                            Icon(Icons.local_fire_department_outlined,
                                color: Colors.red, size: Dimensions.iconSize12),
                            SizedBox(width: 5),
                            Text(
                              "К: ${widget.calories}, Б: ${widget.belki}, Ж: ${widget.fats}, У: ${widget.carbons}",
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: Dimensions.font12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        )
                      ]),
                      SizedBox(height: Dimensions.height20),
                      Container(
                        width: double.maxFinite,
                        height: 40,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment(-0.3, 0),
                              child: Container(
                                width: 120,
                                height: double.maxFinite,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: 15),
                                    Text(
                                      widget.price,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: Dimensions.font18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      "₽",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: Dimensions.font12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment(0.3, 0),
                              child: Container(
                                height: double.maxFinite,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          if(num_cart>1){num_cart--;}
                                        });
                                      },
                                      child: Text(
                                        "-",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: Dimensions.font18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      child: Text(
                                        '${num_cart}',
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: Dimensions.font8,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          num_cart++;
                                        });
                                      },
                                      child: Text(
                                        "+",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: Dimensions.font18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Dimensions.height20),
                      Container(
                        width: 250,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.discription,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: Dimensions.font12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Dimensions.height20),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              "Описание",
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
                      SizedBox(height: Dimensions.height15),
                      Container(
                        width: 300,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.info,
                                maxLines: 99,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: Dimensions.font12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 100,
        height: 50,
        child: RawMaterialButton(
          fillColor: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.shopping_bag_outlined,
                  color: Colors.black, size: Dimensions.iconSize24),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${num_cart}',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: Dimensions.font12,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
            saveCart();
            if (widget.screen == 1) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemCategories(page: widget.page, idCategories: widget.idCategories, nameCategories: widget.nameCategories),
                  ));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MainBoardScreen(page: widget.page),
                  ));
            }
          },
        ),
      ),
    );
  }
}
