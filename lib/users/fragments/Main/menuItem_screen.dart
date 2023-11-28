import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:regester/api_connection/api_connection.dart';
import 'package:regester/height_screen/dimensions.dart';
import 'package:regester/users/fragments/Main/itemCategories_screen.dart';

class MenuItem extends StatefulWidget {
  final int page;

  const MenuItem({super.key, required this.page});

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  String idCategories = "", nameCategories = "";

  var num_rows = 0;
  List _idCategories = [];
  List _nameCategories = [];
  List _imgCategories = [];

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
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    loadCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          padding: EdgeInsets.zero,
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: num_rows == null ? 0 : num_rows,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50, bottom: Dimensions.height15),
                  padding: EdgeInsets.only(
                      left: Dimensions.width20, right: Dimensions.width20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                      ]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        idCategories = _idCategories[0]['id'];
                        nameCategories = _nameCategories[0]['name_categories'];
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
                        margin: EdgeInsets.only(left: 15),
                        width: 175,
                        height: 175,
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
                                      _nameCategories[0]['name_categories'],
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
                                      height: 100,
                                      width: 100,
                                      margin:
                                          EdgeInsets.only(left: 37, top: 20),
                                      child: Image(
                                        image: NetworkImage(API.loadImagelib +
                                            _imgCategories[0]
                                                ['img_categories']),
                                        fit: BoxFit.cover,
                                      )),
                                ])
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        idCategories = _idCategories[1]['id'];
                        nameCategories = _nameCategories[1]['name_categories'];
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
                        margin: EdgeInsets.only(right: 15),
                        width: 175,
                        height: 175,
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
                                      _nameCategories[1]['name_categories'],
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
                                      height: 100,
                                      width: 100,
                                      margin:
                                          EdgeInsets.only(left: 37, top: 20),
                                      child: Image(
                                        image: NetworkImage(API.loadImagelib +
                                            _imgCategories[1]
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        idCategories = _idCategories[2]['id'];
                        nameCategories = _nameCategories[2]['name_categories'];
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
                        margin: EdgeInsets.only(left: 15, top: 15),
                        width: 175,
                        height: 175,
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
                                      _nameCategories[2]['name_categories'],
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
                                      height: 100,
                                      width: 100,
                                      margin:
                                          EdgeInsets.only(left: 37, top: 20),
                                      child: Image(
                                        image: NetworkImage(API.loadImagelib +
                                            _imgCategories[2]
                                                ['img_categories']),
                                        fit: BoxFit.cover,
                                      )),
                                ])
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        idCategories = _idCategories[3]['id'];
                        nameCategories = _nameCategories[3]['name_categories'];
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
                        margin: EdgeInsets.only(right: 15, top: 15),
                        width: 175,
                        height: 175,
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
                                      _nameCategories[3]['name_categories'],
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
                                      height: 100,
                                      width: 100,
                                      margin:
                                          EdgeInsets.only(left: 37, top: 20),
                                      child: Image(
                                        image: NetworkImage(API.loadImagelib +
                                            _imgCategories[3]
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
          }),
    );
  }
}
