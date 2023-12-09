import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:regester/api_connection/api_connection.dart';
import 'package:regester/height_screen/dimensions.dart';
import 'package:regester/users/fragments/Main/itemCategories_screen.dart';
import 'package:regester/users/fragments/Main/qrScanner_screen.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class MenuItem extends StatefulWidget {
  final int page;

  const MenuItem({super.key, required this.page});

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {

  static bool isLoadingList = true;
  static var Loading = 1;

  String idCategories = "", nameCategories = "";

  static var num_rows = 0;
  static List _idCategories = [];
  static List _nameCategories = [];
  static List _imgCategories = [];

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

  @override
  void initState() {
    if(Loading==1){
      Loading=0;
      loadCategories();}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F3),
      body: Column(
        children: [
          _buildMainText(),
          _buildListCategories(),
        ],
      ),

    );
  }

  Widget _buildMainText() {
    if (isLoadingList==true) {
      return Shimmer(
        child: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top*1.25),
          padding: EdgeInsets.only(left: Dimensions.width15, right: Dimensions.width20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 140,
                height: Dimensions.height30,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        padding: EdgeInsets.only(
            left: Dimensions.width20, right: Dimensions.width20),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
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
              IconButton(onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => qrScanner()));
              },
                icon: Icon(Icons.qr_code_scanner,), splashRadius: 24,)
            ]),
      );}
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
                  padding: EdgeInsets.only(top: Dimensions.height20, left: Dimensions.width10, right:  Dimensions.width10),
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
    } else {return Expanded(
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
    );}
  }

}
