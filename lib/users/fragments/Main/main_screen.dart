import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:regester/height_screen/dimensions.dart';
import 'package:regester/users/fragments/Main/food_page_body.dart';
import 'package:regester/users/fragments/Main/item_detail.dart';

import '../../../api_connection/api_connection.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List _idItem = [];
  List _imgMain = [];
  List _imgSecond = [];
  List _nameItem = [];
  List _discriptionItem = [];
  List _caloriesItem = [];
  List _belkiItem = [];
  List _fatsItem = [];
  List _carbonsItem = [];
  List _timeItem = [];
  List _infoItem = [];
  List _priceItem = [];
  List _priceSale = [];

  var saleif = 1;
  var screen = 0;
  String idItem="",
      imgMain = "",
      imgSecond = "",
      name = "",
      discription = "",
      calories = "",
      belki = "",
      fats = "",
      carbons = "",
      time = "",
      info = "",
      price = "",
      sale = "",
      priceSale = "";

  Future loadPopItem() async {
    try {
      final responsePop = await http.get(Uri.parse(API.loadInfoSaleItem));

      if (responsePop.statusCode == 200) {
        setState(() {
          final dataPop = jsonDecode(responsePop.body);
          _idItem = dataPop['dataIdItem'];
          _imgMain = dataPop['dataImgMainItem'];
          _imgSecond = dataPop['dataImgSecondItem'];
          _nameItem = dataPop['dataNameItem'];
          _discriptionItem = dataPop['dataDiscriptionItem'];
          _caloriesItem = dataPop['dataCaloriesItem'];
          _belkiItem = dataPop['dataBelkiItem'];
          _fatsItem = dataPop['dataFatsItem'];
          _carbonsItem = dataPop['dataCarbonsItem'];
          _timeItem = dataPop['dataTimeItem'];
          _infoItem = dataPop['dataInfoItem'];
          _priceItem = dataPop['dataPriceSale']; //запись цены со скидкой, тк меню Акции
          _priceSale = dataPop['dataPriceItem']; //запись цены без скидки
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    loadPopItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: Column(children: [
        Container(
          margin: EdgeInsets.only(top: 50, bottom: Dimensions.height15),
          padding: EdgeInsets.only(
              left: Dimensions.width20, right: Dimensions.width20),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
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
          ]),
        ),
        SizedBox(height: 0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Предложения дня",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: Dimensions.font20,
                color: Colors.amber,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Expanded(
            child: SingleChildScrollView(
          child: FoodPageBody(),
        )),
        Expanded(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: _imgMain == null ? 0 : _imgMain.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(
                        left: Dimensions.width20,
                        right: Dimensions.width20,
                        bottom: 10),
                    child: GestureDetector(
                      onTap: (){
                        idItem = _idItem[index]['id'];
                        imgMain = _imgMain[index]['img_main'];
                        imgSecond = _imgSecond[index]['img_second'];
                        name = _nameItem[index]['name_item'];
                        discription = _discriptionItem[index]['discription_item'];
                        calories = _caloriesItem[index]['calories_item'];
                        belki = _belkiItem[index]['belki_item'];
                        fats = _fatsItem[index]['fats_item'];
                        carbons = _carbonsItem[index]['carbons_item'];
                        time = _timeItem[index]['time_item'];
                        info = _infoItem[index]['info_item'];
                        price = _priceItem[index]['price_sale'];
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ItemDetail(screen: screen, idItem: idItem, imgMain: imgMain, imgSecond: imgSecond, name: name, discription: discription, calories: calories, belki: belki, fats: fats, carbons: carbons, time: time, info: info, price: price, sale: '', id: '', page: 0, idCategories: '', nameCategories: '', ),
                            ));
                      },
                      child: Row(
                          children: [
                            Container(
                              width: Dimensions.listViewImgSize,
                              height: Dimensions.listViewImgSize,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(Dimensions.radius20),
                                  color: Colors.white38,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(API.loadImagelib +
                                        _imgMain[index]['img_main']),
                                  )),
                            ),
                            Expanded(
                              child: Container(
                                height: Dimensions.listViewTextContSize,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight:
                                          Radius.circular(Dimensions.radius20),
                                      bottomRight:
                                          Radius.circular(Dimensions.radius20)),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: Dimensions.width20,
                                      right: Dimensions.width20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
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
                                      SizedBox(height: Dimensions.height10),
                                      Text(
                                        _discriptionItem[index]
                                            ['discription_item'],
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: Dimensions.font8,
                                          color: Color(0xFFccc7c5),
                                        ),
                                      ),
                                      SizedBox(
                                        height: Dimensions.height10,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                                color: Colors.amber,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _priceItem[index]['price_sale'],
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
                                          SizedBox(width: 5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                _priceSale[index]['price_item'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.lineThrough,
                                                  fontFamily: 'Roboto',
                                                  fontSize: Dimensions.font12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Text(
                                                "₽",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.lineThrough,
                                                  fontFamily: 'Roboto',
                                                  fontSize: Dimensions.font8,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                    ),
                  );
                }),
          ),
        )
      ]),
    );
  }
}
