import 'dart:async';
import 'dart:convert';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:regester/height_screen/dimensions.dart';
import 'package:regester/users/fragments/Main/board.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../api_connection/api_connection.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int num_cart = 1;
  String dataLogin="";

  static bool isLoadingBanner = true;
  static bool isLoadingList = true;
  static var Loading = 1;

  static var num_rows_dots = 1;

  static List img = [];
  static List imgUrl = [];

  static List _idItem = [];
  static List _imgMain = [];
  static List _imgSecond = [];
  static List _nameItem = [];
  static List _discriptionItem = [];
  static List _keyStateItem = [];
  static List _massItem = [];
  static List _caloriesItem = [];
  static List _belkiItem = [];
  static List _fatsItem = [];
  static List _carbonsItem = [];
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
      keyState = "",
      mass = "",
      calories = "",
      belki = "",
      fats = "",
      carbons = "",
      time = "",
      info = "",
      price = "",
      sale = "",
      priceSale = "",
      priceFull = "";

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
          _keyStateItem = dataPop['dataKeyStateItem'];
          _massItem = dataPop['dataMassItem'];
          _caloriesItem = dataPop['dataCaloriesItem'];
          _belkiItem = dataPop['dataBelkiItem'];
          _fatsItem = dataPop['dataFatsItem'];
          _carbonsItem = dataPop['dataCarbonsItem'];
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
                      API.loadImagelib + img[index]['img'],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    if (isLoadingBanner == false) {
      if(isLoadingList == false){
        return SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                height: 225,
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
        );
      }
    }
    return Shimmer(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              height: 225,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(Dimensions.radius30),
              ),
            ),
            SizedBox(height: Dimensions.height15),
          ],
        ),
      );
  }

  Widget _buildDotsIndicator() {
    if (isLoadingBanner == false){
      if(isLoadingList == false){
        return Column(children: [
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
        ],);
      }}
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
  }

  Widget _buildFirstText() {
    if(isLoadingBanner == false){
      if(isLoadingList == false){
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
  }

  Widget _buildListView() {
    if(isLoadingBanner == false){
      if(isLoadingList == false){
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
                        discription = discription[0].toUpperCase() + discription.substring(1).toLowerCase();
                        keyState = _keyStateItem[index]['key_state'];
                        mass = _massItem[index]['mass'];
                        calories = _caloriesItem[index]['calories_item'];
                        belki = _belkiItem[index]['belki_item'];
                        fats = _fatsItem[index]['fats_item'];
                        carbons = _carbonsItem[index]['carbons_item'];
                        info = _infoItem[index]['info_item'];
                        price = _priceItem[index]['price_sale'];
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
                                                          titlePadding: EdgeInsets.only(top: Dimensions.height10, left: Dimensions.height10),
                                                          contentPadding: EdgeInsets.only(top: Dimensions.height10, left: Dimensions.height10, right: Dimensions.height10),
                                                          content: Container(
                                                            height: Dimensions.AlertCalories,
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
                                                                SizedBox(height: Dimensions.height5),
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
                                                                SizedBox(height: Dimensions.height5),
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
                                                                SizedBox(height: Dimensions.height5),
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
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              BorderRadius.circular(Dimensions.radius15),
                              color: Colors.white38,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  API.loadImagelib + _imgMain[index]['img_main'],
                                ),
                              ),
                            ),
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
                                ),
                                child: Container(
                                  margin: EdgeInsets.only(top: Dimensions.height5, bottom: Dimensions.height5),
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
                                      SizedBox(height: Dimensions.height5),
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
                                      SizedBox(height: Dimensions.height5),
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
    }
}
