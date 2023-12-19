import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:regester/api_connection/api_connection.dart';
import 'package:regester/height_screen/dimensions.dart';
import 'package:regester/users/fragments/Main/board.dart';
import 'package:regester/users/fragments/Main/itemCategories_screen.dart';
import 'package:regester/users/fragments/Main/qrScanner_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  var complete = 0;
  bool noSearch = false;
  int num_cart = 1;
  String dataLogin="";

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
  List _keyStateItem = [];
  List _massItem = [];
  List _caloriesItem = [];
  List _belkiItem = [];
  List _fatsItem = [];
  List _carbonsItem = [];
  List _infoItem = [];
  List _priceItem = [];

  var screen = 1;
  String idItem="",
      imgMain = "",
      imgSecond = "",
      name = "",
      discription = "",
      keyState = "",
      mass = "",
      calories = "",
      belki = "",
      fats = "",
      carbons = "",
      time = "",
      info = "",
      price = "",
      priceFull = "";

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
          _keyStateItem = data['dataKeyStateItem'];
          _massItem = data['dataMassItem'];
          _caloriesItem = data['dataCaloriesItem'];
          _belkiItem = data['dataBelkiItem'];
          _fatsItem = data['dataFatsItem'];
          _carbonsItem = data['dataCarbonsItem'];
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
              _keyStateItem = [];
              _massItem = [];
              _caloriesItem = [];
              _belkiItem = [];
              _fatsItem = [];
              _carbonsItem = [];
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

  loadLogin() async{
    SharedPreferences pre = await SharedPreferences.getInstance();
    dataLogin = pre.getString("user_login") ?? "";
  }

  saveCart() async{
    try{
      var res = await http.post(
        Uri.parse(API.saveCart),
        body: {
          'id_ItemCart': idItem,
          'name_ItemCart' : name,
          'imgMain_ItemCart' : imgMain,
          'keyState_itemCart' : keyState,
          'mass_itemCart' : mass,
          'calories_itemCart' : calories,
          'belki_itemCart' : belki,
          'fats_itemCart' : fats,
          'carbons_itemCart' : carbons,
          'user_login' : dataLogin,
          'number_ItemCart': num_cart.toString(),
          'price_one': price,
          'price_full': priceFull=="" ? price : priceFull,
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
                              _keyStateItem = [];
                              _massItem = [];
                              _caloriesItem = [];
                              _belkiItem = [];
                              _fatsItem = [];
                              _carbonsItem = [];
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
                        _keyStateItem = [];
                        _massItem = [];
                        _caloriesItem = [];
                        _belkiItem = [];
                        _fatsItem = [];
                        _carbonsItem = [];
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
                  physics: BouncingScrollPhysics(),
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
                        discription = discription[0].toUpperCase() + discription.substring(1).toLowerCase();
                        keyState = _keyStateItem[index]['key_state'];
                        mass = _massItem[index]['mass'];
                        calories = _caloriesItem[index]['calories_item'];
                        belki = _belkiItem[index]['belki_item'];
                        fats = _fatsItem[index]['fats_item'];
                        carbons = _carbonsItem[index]['carbons_item'];
                        info = _infoItem[index]['info_item'];
                        price = _priceItem[index]['price_item'];
                        showModalBottomSheet(context: context,
                            isDismissible: false,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              return StatefulBuilder(builder: (BuildContext context, StateSetter setModalState){
                              return Container(
                                height: Dimensions.screenHeight/1.07,
                                decoration: BoxDecoration(
                                  color: Color(0xFFF5F5F3),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      topLeft: Radius.circular(30)),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          RawMaterialButton(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                            constraints: BoxConstraints.tight(Size(40, 40)),
                                            highlightColor: Colors.transparent,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.only(bottom: 9),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              child:
                                                  Center(
                                                    child: RotatedBox(
                                                      quarterTurns: 3,
                                                      child: Icon(
                                                        Icons.arrow_back_ios,
                                                        color: Colors.amber,
                                                        size: Dimensions.iconSize24,
                                                      ),
                                                    ),
                                                  ),
                                            ),
                                          ),
                                          RawMaterialButton(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                            constraints: BoxConstraints.tight(Size(40, 40)),
                                            highlightColor: Colors.transparent,
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => MainBoardScreen(page: 2),
                                                  ));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.only(bottom: 2),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              child: Center(
                                                child: Icon(
                                                      Icons.shopping_bag_outlined,
                                                      color: Colors.amber,
                                                      size: Dimensions.iconSize24,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        child: Image.network(API.loadImagelib + imgSecond, fit: BoxFit.cover),
                                        margin: EdgeInsets.all(5),
                                        width: Dimensions.ImgItemAddCart,
                                        height: Dimensions.ImgItemAddCart,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 18, right: 5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    name,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: Dimensions.font24,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                  Text(
                                                    keyState=="0" ? "${mass} грамм" : "${mass} л",
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: Dimensions.font12,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight.w300,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              IconButton(
                                                  onPressed: (){
                                                    showDialog(context: context, builder: (BuildContext context){
                                                    return AlertDialog(
                                                      title: Text(
                                                        name,
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
                                                                  "${calories} ккал",
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
                                                                  "${belki} г",
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
                                                                  "${fats} г",
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
                                                                  "${carbons} г",
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
                                                  icon: Icon(Icons.info_outline, size: Dimensions.iconSize24))
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            discription,
                                            maxLines: 6,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: Dimensions.font16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Divider(color: Colors.black26, height: 2, thickness: 0.5),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        physics: BouncingScrollPhysics(),
                                        child: Container(
                                          padding: EdgeInsets.only(left: 18, right: 18, top: 11),
                                          child: Text(
                                            info,
                                            maxLines: 99,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: Dimensions.font12,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                      ),
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
                                                height: Dimensions.BottomButtonAddCart,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Align(
                                              alignment: FractionalOffset.bottomCenter,
                                              child: Container(
                                              margin: EdgeInsets.only(bottom: Dimensions.height15, left: 20, right: 20),
                                              child:
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Container(
                                                    height: Dimensions.height40,
                                                    width: Dimensions.PickButtonAddCart,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.spaceAround,
                                                      children: [
                                                        IconButton(
                                                          onPressed: (){
                                                            setModalState(() {
                                                              if(num_cart>1){num_cart--;}
                                                              priceFull = (int.parse(price)*num_cart).toString();
                                                            });
                                                          },
                                                          icon: Icon(Icons.remove, color: num_cart == 1 ? Colors.grey[350] : Colors.black, size: Dimensions.iconSize12),
                                                        ),
                                                        Text(
                                                          '${num_cart}',
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
                                                            onPressed: (){
                                                              setModalState(() {
                                                                num_cart++;
                                                                priceFull = (int.parse(price)*num_cart).toString();
                                                              });
                                                            },
                                                            icon: Icon(Icons.add, color: Colors.black, size: Dimensions.iconSize12),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: (){
                                                      saveCart();
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      width: Dimensions.AddButtonAddCart,
                                                      height: Dimensions.height40,
                                                      decoration: BoxDecoration(
                                                        color: Colors.amber,
                                                        borderRadius: BorderRadius.circular(5),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "Добавить за ${priceFull == "" ? price : priceFull} ₽",
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
                                                    ),
                                                  ),
                                                ],
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
