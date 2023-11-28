import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(
  home: Home(),
  debugShowCheckedModeBanner: false,
));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  XFile? image;

  var num_rows;

  List _images = [];

  Future getImageServer() async {
    try{

      final response = await http.get(Uri.parse('http://192.168.0.118/api_food/user/info_rest.php'));

      if(response.statusCode == 200){
        final data = jsonDecode(response.body);

        setState(() {
          _images = data['data'];

        });
        num_rows = data['num'];
        print(num_rows);
      }

    }catch(e){
      print(e.toString());

    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getImageServer();
  }

  //show popup dialog
  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImageServer();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImageServer();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Upload Image'),
          actions: [
            IconButton(
              onPressed: () => getImageServer(),
              icon: Icon(Icons.upload),
            )
          ],
        ),
        body: _images.length != 0 ?
        GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: num_rows
            ),
            itemCount: num_rows,
            itemBuilder: (_, index){
              return Padding(
                padding: EdgeInsets.all(10),
                child: Image(
                  image: NetworkImage('http://192.168.0.118/api_food/images/'+_images[index]['image']),
                  fit: BoxFit.cover,
                ),
              );
            }
        ) : Center(child: Text("No Image"),)
    );
  }
}