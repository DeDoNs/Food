import 'package:get/get.dart';

class Dimensions {
//835 height
//411 width
  //top size (заведения)

  static double screenHeight = Get.context!.height;
  static double screenWedth = Get.context!.width;

  static double pageViewContainer = screenHeight / 3.74;
  static double pageViewTextContainer = screenHeight / 12;

  static double height10 = screenHeight / 83.5;
  static double height15 = screenHeight / 55.7;
  static double height20 = screenHeight / 41.75;
  static double height30 = screenHeight / 27.7;
  static double height35 = screenHeight / 23.99;
  static double height45 = screenHeight / 18.56;

  static double width10 = screenWedth / 83.5;
  static double width15 = screenWedth / 55.9;
  static double width20 = screenWedth / 41.75;
  static double width30 = screenWedth / 27.83;
  static double width40 = screenWedth / 8;
  static double width50 = screenWedth / 7;

  static double font8 = screenHeight / 75;
  static double font12 = screenHeight / 56;
  static double font18 = screenHeight / 45;
  static double font20 = screenHeight / 36;
  static double font24 = screenHeight / 33;

  static double radius15 = screenHeight / 55.7;
  static double radius20 = screenHeight / 41.75;
  static double radius30 = screenHeight / 27.83;

  static double iconSize8 = screenHeight / 70;
  static double iconSize12 = screenHeight / 52;
  static double iconSize24 = screenHeight / 33;

  //list view size (популярные блюда)
  static double listViewImgSize = screenWedth / 3.25;
  static double listViewTextContSize = screenWedth / 3.9;

  //list cart
  static double listViewImgSizeCart = screenWedth / 4;
  static double listViewTextContSizeCart = screenWedth / 4.65;

  static double listViewTextContWedthCart = screenWedth / 1.53;

  static double itemScreenDesc = screenHeight / 1.565;
  static double itemScreenHeight = screenHeight / 4;

  static double buttonfullwidgt = screenWedth / 1.17;
}
