import 'dart:convert';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:regester/users/fragments/Main/item_detail.dart';

import '../../../api_connection/api_connection.dart';
import '../../../height_screen/dimensions.dart';

class FoodPageBody extends StatefulWidget {
  const FoodPageBody({super.key});

  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  var num_rows = 1;

  List img = [];

  var saleif = 0;
  var screen = 0;
  String idItem='',
      imgMain = "",
      imgSecond = "",
      name = "",
      discription = "",
      calories = "",
      time = "",
      info = "",
      price = "",
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
          num_rows = data['num'];
          img = data['dataImg'];
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
    loadInfoOffer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: Dimensions.pageViewContainer,
          child: PageView.builder(
              controller: pageController,
              itemCount: img == null ? 0 : img.length,
              itemBuilder: (context, position) {
                return _buildPageItem(position);
              }),
        ),
        SizedBox(height: Dimensions.height15),
        new DotsIndicator(
          dotsCount: num_rows,
          position: _currPageValue,
          decorator: DotsDecorator(
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            color: Color(0xFFccc7c5),
            // Inactive color
            activeColor: Colors.amber,
          ),
        ),
        SizedBox(height: Dimensions.height20),
        Container(
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
      ],
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
}
