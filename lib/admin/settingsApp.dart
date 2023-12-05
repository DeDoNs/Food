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
      backgroundColor: Color(0xFFF5F5F3),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
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
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  GridView.builder(
                    padding: EdgeInsets.only(top: Dimensions.height15, left: Dimensions.width10, right:  Dimensions.width10),
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
                                            page: widget.page
                                        ),
                                      )
                                  );
                                },
                                child: Container(
                                  width: Dimensions.CategoriesCartSize,
                                  height: Dimensions.CategoriesCartSize,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(Dimensions.radius20),
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
                                          ],
                                        ),
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
                                              image: NetworkImage(API.loadImagelib + _imgCategories[index]['img_categories']),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                          onPressed: () {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) => AlertDialog(
                                                title: const Text('AlertDialog Title'),

                                                content: Column(
                                                  children: [
                                                    Expanded(
                                                      child: SingleChildScrollView(
                                                        child: Column(
                                                          children: [
                                                            TextFormField(
                                                              decoration: InputDecoration(
                                                                hintText: "Переименовать",
                                                                border: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(30),
                                                                  borderSide: const BorderSide(
                                                                    color: Colors.amber,
                                                                  ),
                                                                ),
                                                                enabledBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(30),
                                                                  borderSide: const BorderSide(
                                                                    color: Colors.amber,
                                                                  ),
                                                                ),
                                                                focusedBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(30),
                                                                  borderSide: const BorderSide(
                                                                    color: Colors.amber,
                                                                  ),
                                                                ),
                                                                disabledBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(30),
                                                                  borderSide: const BorderSide(
                                                                    color: Colors.amber,
                                                                  ),
                                                                ),
                                                                contentPadding: const EdgeInsets.symmetric(
                                                                  horizontal: 14,
                                                                  vertical: 6,
                                                                ),
                                                                fillColor: Colors.white,
                                                                filled: true,
                                                              ),
                                                            ),
                                                            // Другие TextFormField или виджеты
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 16,
                                                      right: 16,
                                                      child: Container(
                                                        width: 56,
                                                        height: 56,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.red,
                                                        ),
                                                        child: IconButton(
                                                          icon: Icon(Icons.delete),
                                                          color: Colors.white,
                                                          onPressed: () {
                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  title: Text("Удаление"),
                                                                  content: Text("Вы действительно хотите удалить?"),
                                                                  actions: [
                                                                    TextButton(
                                                                      child: Text("Отмена"),
                                                                      onPressed: () {
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                    ),
                                                                    TextButton(
                                                                      child: Text("Удалить"),
                                                                      onPressed: () {
                                                                        // Обработчик удаления
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),


                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context, 'Cancel'),
                                                    child: const Text('Отмена'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context, 'OK'),
                                                    child: const Text('Сохранить'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.edit),
                                        ),
                                      ),
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
        ],
      ),

    );
  }
}
