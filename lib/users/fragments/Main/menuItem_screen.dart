import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:regester/api_connection/api_connection.dart';
import 'package:regester/height_screen/dimensions.dart';
import 'package:regester/users/fragments/Main/itemCategories_screen.dart';
import 'package:regester/users/fragments/Main/item_detail.dart';
import 'package:regester/users/fragments/Main/qrScanner_screen.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class MenuItem extends StatefulWidget {
  final int page;

  const MenuItem({super.key, required this.page});

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {

  var searchController = TextEditingController();
  bool isTextFromField = false;
  late StreamSubscription<bool> _keyboardVisibilitySubscription;
  final KeyboardVisibilityController _keyboardVisibilityController = KeyboardVisibilityController();
  var complete=0;
  bool noSearch = false;

  static bool isLoadingList = true;
  static var Loading = 1;

  String idCategories = "", nameCategories = "";

  static var num_rows = 0;
  static List _idCategories = [];
  static List _nameCategories = [];
  static List _imgCategories = [];

  var num_rows_search=0;
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

  Future loadCategories() async {
    try {
      final res = await http.get(Uri.parse(API.load));

      if (res.statusCode == 200) {
        setState(() {
          final data = jsonDecode(res.body);
          num_rows = data['num'];
          _idCategories = data['dataIdCategories'];
          _nameCategories = data['dataNameCategories'];
          _imgCategories = data['dataImgCategories'];
          isLoadingList = false;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future searchItem() async {
    try {
      var res = await http.post(
        Uri.parse(API.searchItem),
        body: {
          'search': searchController.text.trim(),
        },
      );

      if (res.statusCode == 200) {
        setState(() {
          final data = jsonDecode(res.body);
          num_rows_search = data['num'];
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
          if(num_rows_search==0){
            setState(() {
              noSearch = true;
              _idItem = [];
              _imgMain = [];
              _imgSecond = [];
              _nameItem = [];
              _discriptionItem = [];
              _caloriesItem = [];
              _belkiItem = [];
              _fatsItem = [];
              _carbonsItem = [];
              _timeItem = [];
              _infoItem = [];
              _priceItem = [];
            });
          }else{
            setState(() {
              noSearch = false;
            });
          }
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    if(Loading==1){
      Loading=0;
      loadCategories();}
    super.initState();
    _keyboardVisibilitySubscription = _keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible) {}
      else {
        if(searchController.text.trim()==""){
          if(complete==0){
            setState(() {
              isTextFromField = false;
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _keyboardVisibilitySubscription.cancel(); // Don't forget to cancel the subscription!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Категории",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: Dimensions.font24,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => qrScanner()));
            }, icon: Icon(Icons.qr_code_scanner, color: Colors.black), splashRadius: 20,)
          ],
          bottom: PreferredSize(
            child: Container(
              width: double.infinity,
              height: 50,
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 5),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFEEEEEE),
                borderRadius: BorderRadius.all(Radius.circular(50.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        onTap: (){
                          setState(() {
                            isTextFromField = true;
                          });
                        },
                        onChanged: (val){
                          if(searchController.text.trim()==""){
                            setState(() {
                              complete=0;
                              _idItem = [];
                              _imgMain = [];
                              _imgSecond = [];
                              _nameItem = [];
                              _discriptionItem = [];
                              _caloriesItem = [];
                              _belkiItem = [];
                              _fatsItem = [];
                              _carbonsItem = [];
                              _timeItem = [];
                              _infoItem = [];
                              _priceItem = [];
                            });
                          }
                          else{
                            searchItem();
                          }
                        },
                        onEditingComplete: (){
                          if(searchController.text.trim()!=""){
                            setState(() {
                              complete=1;
                            });
                            FocusManager.instance.primaryFocus?.unfocus();
                          }else{
                            setState(() {
                              complete=0;
                            });}
                        },
                        controller: searchController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          hintText: "Поиск блюд...",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey
                          ),
                          fillColor: Colors.transparent,
                          filled: true,
                        ),
                      ),
                    ),
                    searchController.text.trim()!="" ? IconButton(onPressed: (){
                      FocusManager.instance.primaryFocus?.unfocus();
                      setState(() {
                        searchController.clear();
                        complete=0;
                        isTextFromField = false;
                        _idItem = [];
                        _imgMain = [];
                        _imgSecond = [];
                        _nameItem = [];
                        _discriptionItem = [];
                        _caloriesItem = [];
                        _belkiItem = [];
                        _fatsItem = [];
                        _carbonsItem = [];
                        _timeItem = [];
                        _infoItem = [];
                        _priceItem = [];
                      });
                      }, icon: Icon(Icons.close, color: Colors.grey, size: 18,), splashRadius: 20) : Container()
                  ],
                ),
              ),
            preferredSize: Size.fromHeight(70),
          ),
          elevation: 0,
        ),
        backgroundColor: Color(0xFFF5F5F3),
        body: Column(
          children: [
            _buildListCategories(),
          ],
        ),
      ),
    );
  }

  Widget _buildListCategories() {
    if (isLoadingList==true) {
      return Expanded(
        child: Shimmer(
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                GridView.builder(
                  padding: EdgeInsets.only(top: 20, left: Dimensions.width10, right:  Dimensions.width10),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemCount: 8,
                  itemBuilder: (BuildContext context, index){
                    return Column(
                      children: [
                        Container(
                          width: Dimensions.CategoriesCartSize,
                          height: Dimensions.CategoriesCartSize,
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(Dimensions.radius20),
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          )
        ),
      );
    } else {
      if(isTextFromField){
        if(noSearch){
          return Expanded(
            child: Center(
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                  child: Container(
                    padding: EdgeInsets.only(left: Dimensions.width40, right: Dimensions.width40),
                    child: Column(
                      children: [
                        Container(
                            width: Dimensions.ImgNoSearch,
                            height: Dimensions.ImgNoSearch,
                            child: Image.asset("images/icon_nosearch.png", fit: BoxFit.cover,)
                        ),
                        SizedBox(height: Dimensions.height15,),
                        Text(
                          "Хорошая попытка! Но такого нигде нет. Попробуете изменить запрос?",
                          maxLines: 3,
                          textAlign: TextAlign.center,
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
          );
        }else{
          return Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: ListView.builder(
                padding: EdgeInsets.only(top: 20),
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
                                idCategories: "",
                                nameCategories: "",
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
                                    SizedBox(height: Dimensions.height10),
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
          );
        }
      }
      else{
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  GridView.builder(
                    padding: EdgeInsets.only(top: Dimensions.height10, left: Dimensions.width10, right:  Dimensions.width10),
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemCount: num_rows == null ? 0 : num_rows,
                    itemBuilder: (BuildContext context, index){
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  idCategories = _idCategories[index]['id'];
                                  nameCategories = _nameCategories[index]['name_categories'];
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ItemCategories(
                                            idCategories: idCategories,
                                            nameCategories: nameCategories,
                                            page: widget.page),
                                      ));
                                },
                                child: Container(
                                  width: Dimensions.CategoriesCartSize,
                                  height: Dimensions.CategoriesCartSize,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(Dimensions.radius20),
                                    color: Color(0xFFEEEEEE),
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 15, top: 15),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _nameCategories[index]['name_categories'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: Dimensions.font12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ]),
                                      ),
                                      SizedBox(height: 5),
                                      Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                                height: Dimensions.CategoriesImgSize,
                                                width: Dimensions.CategoriesImgSize,
                                                margin: EdgeInsets.only(left: Dimensions.CategoriesImgLeft, top: Dimensions.width30),
                                                child: Image(
                                                  image: NetworkImage(API.loadImagelib +
                                                      _imgCategories[index]
                                                      ['img_categories']),
                                                  fit: BoxFit.cover,
                                                )),
                                          ])
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
  }

}
