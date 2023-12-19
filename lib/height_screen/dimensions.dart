import 'package:get/get.dart';

class Dimensions {
//835 height
//411 width
  //top size (заведения)

  static double screenHeight = Get.context!.height;
  static double screenWedth = Get.context!.width;

  static double pageViewContainer = screenHeight / 3.74;
  static double pageViewTextContainer = screenHeight / 12;

  static double height5 = screenHeight / 167;
  static double height10 = screenHeight / 83.5;
  static double height15 = screenHeight / 55.7;
  static double height20 = screenHeight / 41.75;
  static double height30 = screenHeight / 27.7;
  static double height35 = screenHeight / 23.99;
  static double height40 = screenHeight / 20;
  static double height45 = screenHeight / 18.56;

  static double width10 = screenWedth / 83.5;
  static double width15 = screenWedth / 55.9;
  static double width20 = screenWedth / 41.75;
  static double width30 = screenWedth / 27.83;
  static double width40 = screenWedth / 8;
  static double width50 = screenWedth / 7;

  static double font8 = screenHeight / 75;
  static double font12 = screenHeight / 56;
  static double font16 = screenHeight / 50;
  static double font18 = screenHeight / 45;
  static double font20 = screenHeight / 36;
  static double font24 = screenHeight / 33;
  static double font32 = screenHeight / 26;

  static double radius15 = screenHeight / 55.7;
  static double radius20 = screenHeight / 41.75;
  static double radius30 = screenHeight / 27.83;

  static double iconSize8 = screenHeight / 70;
  static double iconSize12 = screenHeight / 52;
  static double iconSize18 = screenHeight / 47;
  static double iconSize24 = screenHeight / 33;

  //list view size (популярные блюда)
  static double listViewImgSize = screenHeight / 6.85;
  static double listViewTextContSize = screenHeight / 8.3;

  //list cart
  static double listViewImgSizeCart = screenWedth / 3.7;
  static double listViewTextContSizeCart = screenHeight / 10.5;
  static double listViewTextContWedthCart = screenWedth / 1.58;

  static double itemScreenDesc = screenHeight / 1.565;
  static double itemScreenHeight = screenHeight / 4;

  static double buttonfullwidgt = screenWedth / 1.17;

  static double MaindividerInd = listViewImgSize / 5.4;
  static double MaindividerEndInd = listViewImgSize * 2.26;
  static double CatdividerInd = screenWedth / 14;
  static double CatdividerEndInd = screenWedth / 1.4;
  static double CartdividerInd = screenWedth / 11.75;
  static double CartdividerEndInd = screenWedth / 1.35;
  static double PlusMinusShopCard = screenWedth / 3.3;

  static double pricePadding = screenHeight / 180;
  static double AlertCalories = screenHeight / 7.3;

  static double CategoriesCartSize = screenWedth / 2.25;
  static double CategoriesImgSize = screenWedth / 4.1;
  static double CategoriesImgLeft = screenWedth / 11.75;

  static double ImgNoSearch = screenHeight / 4.4;

  static double ImgItemAddCart = screenWedth / 1.45;
  static double BottomButtonAddCart = screenHeight / 11.5;
  static double PickButtonAddCart = screenWedth / 3.45;
  static double AddButtonAddCart = screenWedth / 1.75;
}
