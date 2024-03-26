import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class StatisticsController extends BaseController {
  Map<String, double> dataMap = {
    "Flutter": 4,
    "Firebase": 3,
    "Dart": 4,
    "Figma": 2,
    "YouTube": 1.5,
  };
  List<Color> colorsList = [
    Colors.blue,
    Colors.orange,
    Colors.deepPurpleAccent,
    Colors.greenAccent,
    Colors.redAccent,
  ];

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    // Lấy ngày hiện tại
    DateTime now = DateTime.now();

    // Lấy ngày đầu tuần
    DateTime firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));

    // Lấy ngày cuối tuần
    DateTime lastDayOfWeek = now.add(Duration(days: DateTime.daysPerWeek - now.weekday));

    // Định dạng ngày đầu tuần và ngày cuối tuần thành chuỗi
    String formattedFirstDayOfWeek = DateFormat('dd/MM/yyyy').format(firstDayOfWeek);
    String formattedLastDayOfWeek = DateFormat('dd/MM/yyyy').format(lastDayOfWeek);

    // In kết quả
    print('Ngày đầu tuần: $formattedFirstDayOfWeek');
    print('Ngày cuối tuần: $formattedLastDayOfWeek');
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
