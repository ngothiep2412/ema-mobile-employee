import 'package:hrea_mobile_employee/app/resources/font_manager.dart';
import 'package:flutter/material.dart';

class GetTextStyle {
  static TextStyle getTextStyle(double fontSize, String fontFamily, FontWeight fontWeight, Color color) {
    return TextStyle(fontSize: fontSize, fontFamily: fontFamily, fontWeight: fontWeight, color: color);
  }

  static TextStyle getRegularStyle({double fontSize = FontSize.s12, required Color color}) {
    return getTextStyle(fontSize, FontsConstant.fontFamily, FontWeightManager.regular, color);
  }

  static TextStyle getLightStyle({double fontSize = FontSize.s12, required Color color}) {
    return getTextStyle(fontSize, FontsConstant.fontFamily, FontWeightManager.light, color);
  }

  static TextStyle getBoldStyle({double fontSize = FontSize.s12, required Color color}) {
    return getTextStyle(fontSize, FontsConstant.fontFamily, FontWeightManager.bold, color);
  }

  static TextStyle getBlackStyle({double fontSize = FontSize.s12, required Color color}) {
    return getTextStyle(fontSize, FontsConstant.fontFamily, FontWeightManager.black, color);
  }

  static TextStyle getMediumStyle({double fontSize = FontSize.s12, required Color color}) {
    return getTextStyle(fontSize, FontsConstant.fontFamily, FontWeightManager.medium, color);
  }

  static TextStyle getLargeStyle({double fontSize = FontSize.s18, required Color color}) {
    return getTextStyle(fontSize, FontsConstant.fontFamily, FontWeightManager.bold, color);
  }
}
