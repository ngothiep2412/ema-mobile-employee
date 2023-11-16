import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:intl/intl.dart';

class DevUtils {
  static void printLog(String nameClass, String funcOrLine, String content) {
    dev.log(nameClass + "-" + funcOrLine + "-" + content);
  }

  static void showSnackbarMessage(String title, String content, Color color) {
    Get.snackbar(title, content, backgroundColor: color, colorText: Colors.white);
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return TextEditingValue();
    }

    double value = double.parse(newValue.text);
    String formattedValue = NumberFormat("#,##0", "vi_VN").format(value);

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}
