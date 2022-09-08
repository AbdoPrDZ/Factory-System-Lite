import 'package:flutter/material.dart';

class SizeConfig {
  late MediaQueryData _mediaQueryData;
  late Size screenSize;
  late double screenWidth, screenHeight, realScreenWidth, realScreenHeight;
  late Orientation orientation;

  SizeConfig(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenSize = _mediaQueryData.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    orientation = _mediaQueryData.orientation;
    realScreenWidth =
        orientation == Orientation.landscape ? screenHeight : screenWidth;
    realScreenHeight =
        orientation == Orientation.landscape ? screenWidth : screenHeight;
  }

  double proportionateScreenHeight(double inputHeight) {
    return (inputHeight / 812.0) * screenHeight;
  }

  double proportionateScreenWidth(double inputWidth) {
    return (inputWidth / 375.0) * screenWidth;
  }
}
