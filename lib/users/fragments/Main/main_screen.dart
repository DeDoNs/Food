import 'dart:async';
import 'dart:convert';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:regester/height_screen/dimensions.dart';
import 'package:regester/users/fragments/Main/item_detail.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../api_connection/api_connection.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  static bool isLoadingBanner = true;
  static bool isLoadingList = true;
  static var Loading = 1;

  static var num_rows_dots = 1;

  static List img = [];

  static List _idItem = [];
  static List _imgMain = [];
  static List _imgSecond = [];
  static List _nameItem = [];
  static List _discriptionItem = [];
  static List _caloriesItem = [];
  static List _belkiItem = [];
  static List _fatsItem = [];
  static List _carbonsItem = [];
  static List _timeItem = [];
  static List _infoItem = [];
  static List _priceItem = [];
  static List _priceSale = [];

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

  PageController pageController = PageController(viewportFraction: 0.88);
  double _currPageValue = 0.0;
  double _scaleFactor = 0.8;
  double _height = Dimensions.pageViewContainer;

  Future loadInfoOffer() async {
    try {
      final res = await http.get(Uri.parse(API.loadBanner));

      if (res.statusCode == 200) {
        setState(() {
          final data = jsonDecode(res.body);
          num_rows_dots = data['num'];
          img = data['dataImg'];
          isLoadingBanner = false;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

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
          isLoadingList = false;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!;
      });
    });
    if(Loading==1){
      Loading=0;
      loadInfoOffer();
      loadPopItem();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Добрый день!",
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
        _buildBanner(),
        _buildDotsIndicator(),
        _buildFirstText(),
        _buildListView()
      ]),
    );
  }

  Widget _buildPageItem(int index) {
    Matrix4 matrix = new Matrix4.identity();
    if (index == _currPageValue.floor()) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      if (index == _currPageValue.floor() + 1) {
        var currScale =
            _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
        var currTrans = _height * (1 - currScale) / 2;
        matrix = Matrix4.diagonal3Values(1, currScale, 1);
        matrix = Matrix4.diagonal3Values(1, currScale, 1)
          ..setTranslationRaw(0, currTrans, 0);
      } else {
        if (index == _currPageValue.floor() - 1) {
          var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
          var currTrans = _height * (1 - currScale) / 2;
          matrix = Matrix4.diagonal3Values(1, currScale, 1);
          matrix = Matrix4.diagonal3Values(1, currScale, 1)
            ..setTranslationRaw(0, currTrans, 0);
        } else {
          var currScale = 0.8;
          matrix = Matrix4.diagonal3Values(1, currScale, 1)
            ..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 1);
        }
      }
    }

    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              height: Dimensions.pageViewContainer,
              margin: EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius30),
                color: Colors.white,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      API.loadImagelib + img[index]['img']),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    if (isLoadingBanner == true && isLoadingList == true) {
      return Shimmer(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              height: Dimensions.pageViewContainer,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(Dimensions.radius30),
              ),
            ),
            SizedBox(height: Dimensions.height15)
          ],
        ),
      );
    } else {return SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              height: Dimensions.pageViewContainer,
              child: PageView.builder(
                  controller: pageController,
                  itemCount: img == null ? 0 : img.length,
                  itemBuilder: (context, position) {
                    return _buildPageItem(position);
                  }),
            ),
            SizedBox(height: Dimensions.height15),
          ],
        ),
      );}
  }

  Widget _buildDotsIndicator() {
    if (isLoadingBanner == true && isLoadingList == true) {
      return Shimmer(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 6),
                  width: 45,
                  height: Dimensions.height15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height20),
          ],
        ),
      );
    } else {return Column(children: [
        new DotsIndicator(
          dotsCount: num_rows_dots,
          position: _currPageValue,
          decorator: DotsDecorator(
            size: const Size.square(9),
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            color: Color(0xFFccc7c5),
            // Inactive color
            activeColor: Colors.amber,
          ),
        ),
        SizedBox(height: Dimensions.height20),
      ],);}
  }

  Widget _buildFirstText() {
    if (isLoadingBanner == true && isLoadingList == true) {
      return Shimmer(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: Dimensions.width20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 260,
                    height: 27,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height10),
          ],
        ),
      );
    } else {
      return Column(children: [
        Container(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.only(left: Dimensions.width30),
          child: Row(
            children: [
              Text(
                "Выгодно и вкусно",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: Dimensions.font18,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                " · Акции",
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
        ),
        SizedBox(height: Dimensions.height10),
      ],);
    }
  }

  Widget _buildListView() {
    if (isLoadingBanner == true && isLoadingList == true) {
      return Expanded(
          child: Shimmer(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    height: Dimensions.listViewImgSize,
                    margin: EdgeInsets.only(
                        top: 0,
                        left: Dimensions.width20,
                        right: Dimensions.width20,
                        bottom: 10),
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(Dimensions.radius15),
                        color: Colors.grey[300]),

                  ),
                  Container(
                    height: Dimensions.listViewImgSize,
                    margin: EdgeInsets.only(
                        top: 0,
                        left: Dimensions.width20,
                        right: Dimensions.width20,
                        bottom: 10),
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(Dimensions.radius15),
                        color: Colors.grey[300]),

                  ),
                  Container(
                    height: Dimensions.listViewImgSize,
                    margin: EdgeInsets.only(
                        top: 0,
                        left: Dimensions.width20,
                        right: Dimensions.width20,
                        bottom: 10),
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(Dimensions.radius15),
                        color: Colors.grey[300]),

                  ),
                ],
              ),
            ),
          ),
      );
    } else {
      return Expanded(
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
                      top: 0,
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
                              BorderRadius.circular(Dimensions.radius15),
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
                                  right: Dimensions.width20,
                                  top: 5,
                                  bottom: 5
                              ),
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
                                  SizedBox(height: 8),
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
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(Dimensions.pricePadding),
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
      );
    }
  }

}
