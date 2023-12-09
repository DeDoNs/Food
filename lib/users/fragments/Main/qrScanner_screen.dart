import 'dart:convert';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/dropdown_alert.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';
import 'package:regester/api_connection/api_connection.dart';
import 'package:regester/height_screen/dimensions.dart';
import 'package:regester/users/fragments/Main/board.dart';
import 'package:shared_preferences/shared_preferences.dart';

class qrScanner extends StatefulWidget {
  const qrScanner({super.key});

  @override
  State<qrScanner> createState() => _qrScannerState();
}

class _qrScannerState extends State<qrScanner> {

  void _success() {
    Map<String, dynamic> payload = new Map<String, dynamic>();
    payload["data"] = "content";
    AlertController.show(
        "Успешно", "Товар добавлен в корзину!", TypeAlert.success, payload);
  }

  MobileScannerController cameraController = MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);
  String idItem_load = "";

  String dataLogin="";

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

  loadItem() async{
    try{
      var res = await http.post(
        Uri.parse(API.loadItem),
        body: {
          'id_item': idItem_load,
        },
      );
      if(res.statusCode == 200){  //200 - API OK
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
        saveCart();
      }
    }
    catch(e){
      print(e.toString());
    }
  }

  loadLogin() async{
    SharedPreferences pre = await SharedPreferences.getInstance();
    dataLogin = pre.getString("user_login") ?? "";
  }

  saveCart() async{
    int price = int.parse(_priceItem[0]['price_item']);
    int price_all = price*1;
    try{
      var res = await http.post(
        Uri.parse(API.saveCart),
        body: {
          'id_ItemCart': _idItem[0]['id'],
          'name_ItemCart' : _nameItem[0]['name_item'],
          'imgMain_ItemCart' : _imgMain[0]['img_main'],
          'calories_itemCart' : _caloriesItem[0]['calories_item'],
          'belki_itemCart' : _belkiItem[0]['belki_item'],
          'fats_itemCart' : _fatsItem[0]['fats_item'],
          'carbons_itemCart' : _carbonsItem[0]['carbons_item'],
          'user_login' : dataLogin,
          'number_ItemCart': "1",
          'price_one': _priceItem[0]['price_item'],
          'price_full': price_all.toString(),
        },
      );
      if(res.statusCode == 200){ //200 - API OK
        _success();
      }
    }
    catch(e){
      print(e.toString());
    }
  }

  @override
  void initState() {
    loadLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            overlay: QRScannerOverlay(overlayColor: Colors.black.withOpacity(0.5), borderStrokeWidth: 3, borderRadius: 20, borderColor: Colors.amber,),
            startDelay: true,
            onDetect: (capture) {
              final Barcode barcodes = capture.barcodes.first;
              if(barcodes.rawValue!=null){
                setState(() {
                  idItem_load = barcodes.rawValue.toString();
                });
                loadItem();
              }
            },
            controller: cameraController,
          ),
          Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: Dimensions.width10),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MainBoardScreen(page: 1)));
                  },
                  icon: Icon(Icons.close, size: Dimensions.iconSize24, color: Colors.white,)
              )
          ),
        ],
      ),
    );
  }
}
