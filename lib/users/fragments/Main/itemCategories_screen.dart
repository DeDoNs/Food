import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:regester/api_connection/api_connection.dart';
import 'package:regester/height_screen/dimensions.dart';
import 'package:regester/users/fragments/Main/board.dart';
import 'package:regester/users/fragments/Main/item_detail.dart';

class ItemCategories extends StatefulWidget {
  final int page;
  final String idCategories, nameCategories;

  const ItemCategories(
      {super.key,
      required this.idCategories,
      required this.nameCategories,
      required this.page});

  @override
  State<ItemCategories> createState() => _ItemCategoriesState();
}

class _ItemCategoriesState extends State<ItemCategories> {
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

  var screen = 1;
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
      priceSale = "";

  Future loadItemCategories() async {
    try {
      var res = await http.post(
        Uri.parse(API.loadCategoriesItem),
        body: {
          'id_categories': widget.idCategories,
        },
      );

      if (res.statusCode == 200) {
        setState(() {
          final data = jsonDecode(res.body);
          _idItem = data['dataIdItem'];
          _imgMain = data['dataImgMainItem'];
          _imgSecond = data['dataImgSecondItem'];
          _nameItem = data['dataNameItem'];
          _discriptionItem = data['dataDiscriptionItem'];
          _caloriesItem = data['dataCaloriesItem'];
          _belkiItem = data['dataBelkiItem'];
          _fatsItem = data['dataFatsItem'];
          _carbonsItem = data['dataCarbonsItem'];
          _timeItem = data['dataTimeItem'];
          _infoItem = data['dataInfoItem'];
          _priceItem = data['dataPriceItem'];
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    loadItemCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F3),
      body: Column(children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top, bottom: Dimensions.height10
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RawMaterialButton(
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MainBoardScreen(page: 1),
                            ));
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(spreadRadius: 2, color: Colors.grey.withOpacity(0.2), blurRadius: 10, offset: Offset(0,3))],
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
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: Dimensions.height10),
                child: Text(
                  widget.nameCategories,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: Dimensions.font24,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: []),
        ]),
        Expanded(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ListView.separated(
              padding: EdgeInsets.only(top: Dimensions.height10),
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: _imgMain == null ? 0 : _imgMain.length,
              separatorBuilder: (context, index) => Divider(color: Colors.black26, height: 1, indent: Dimensions.CatdividerInd, endIndent: Dimensions.CatdividerEndInd, thickness: 2),
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(
                      top: 10,
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                      bottom: 10),
                  child: GestureDetector(
                    onTap: () {
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
                      price = _priceItem[index]['price_item'];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItemDetail(
                              screen: screen,
                              idItem: idItem,
                              imgMain: imgMain,
                              imgSecond: imgSecond,
                              name: name,
                              discription: discription,
                              calories: calories,
                              belki: belki,
                              fats: fats,
                              carbons: carbons,
                              time: time,
                              info: info,
                              price: price,
                              sale: '',
                              id: '',
                              page: widget.page,
                              idCategories: widget.idCategories,
                              nameCategories: widget.nameCategories,
                            ),
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
                                    _discriptionItem[index]['discription_item'],
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
                                              _priceItem[index]['price_item'],
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
              },
            ),
          ),
        ),
      ]),
      floatingActionButton: Container(
        width: 50,
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
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) =>
                MainBoardScreen(page: 2)));
            }
        ),
      ),
    );}
  }