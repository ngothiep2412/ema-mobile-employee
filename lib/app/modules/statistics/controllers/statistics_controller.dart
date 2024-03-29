import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/statistics/api/statistics_api.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class StatisticsController extends BaseController {
  String jwt = '';
  String idUser = '';
  RxBool isLoading = false.obs;
  RxList<TaskModel> listTask = <TaskModel>[].obs;

  RxBool checkView = true.obs;

  var dataMapView = <String, double>{
    "Thấp": 0,
    "Trung bình": 0,
    "Cao": 0,
  }.obs;

  List<Color> colorsList = [
    Colors.green,
    Colors.orange,
    Colors.red,
  ];

  var dataStatusTask = <String, int>{
    "PENDING": 0,
    "PROCESSING": 0,
    "DONE": 0,
    "CONFIRM": 0,
  }.obs;

  RxString startDate = ''.obs;
  RxString endDate = ''.obs;

  final count = 0.obs;
  @override
  Future<void> onInit() async {
    super.onInit();
    await getAllTask();
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

  void checkToken() {
    DateTime now = DateTime.now().toLocal();
    if (GetStorage().read('JWT') != null) {
      jwt = GetStorage().read('JWT');
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
      print('decodedToken ${decodedToken}');
      print('now ${now}');

      DateTime expTime = DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
      print(expTime.toLocal());
      idUser = decodedToken['id'];
      // if (JwtDecoder.isExpired(jwt)) {
      //   Get.offAllNamed(Routes.LOGIN);
      //   return;
      // }
      if (expTime.toLocal().isBefore(now)) {
        Get.offAllNamed(Routes.LOGIN);
        return;
      }
    } else {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }
  }

  Future<void> getAllTask() async {
    checkToken();
    try {
      isLoading.value = true;
      // Lấy ngày hiện tại
      DateTime now = DateTime.now().toLocal();

      // Lấy ngày đầu tuần
      DateTime firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));

      // Lấy ngày cuối tuần
      DateTime lastDayOfWeek = now.add(Duration(days: DateTime.daysPerWeek - now.weekday));

      // Định dạng ngày đầu tuần và ngày cuối tuần thành chuỗi
      String formattedFirstDayOfWeek = DateFormat('yyyy-MM-dd').format(firstDayOfWeek);
      String formattedLastDayOfWeek = DateFormat('yyyy-MM-dd').format(lastDayOfWeek);

      startDate.value = DateFormat('EEEE, dd MMMM yyyy', 'vi').format(firstDayOfWeek);
      endDate.value = DateFormat('EEEE, dd MMMM yyyy', 'vi').format(lastDayOfWeek);

      // In kết quả
      print('Ngày đầu tuần: $formattedFirstDayOfWeek');
      print('Ngày cuối tuần: $formattedLastDayOfWeek');
      listTask.clear();
      List<TaskModel> list = [];
      var dataMap = <String, double>{
        "Thấp": 0,
        "Trung bình": 0,
        "Cao": 0,
      }.obs;
      list = await StatisticsApi.getTaskByDate(jwt, formattedFirstDayOfWeek, formattedLastDayOfWeek, idUser);
      listTask.value = list;

      if (list.isNotEmpty) {
        for (var item in list) {
          if (item.priority == Priority.LOW) {
            dataMap['Thấp'] = dataMap['Thấp']! + 1;
          } else if (item.priority == Priority.MEDIUM) {
            dataMap['Trung bình'] = dataMap['Thấp']! + 1;
          } else if (item.priority == Priority.HIGH) {
            dataMap['Cao'] = dataMap['Cao']! + 1;
          }

          if (item.status == Status.PENDING) {
            dataStatusTask['PENDING'] = dataStatusTask['PENDING']! + 1;
          } else if (item.status == Status.PROCESSING) {
            dataStatusTask['PROCESSING'] = dataStatusTask['PROCESSING']! + 1;
          } else if (item.status == Status.DONE) {
            dataStatusTask['DONE'] = dataStatusTask['DONE']! + 1;
          } else if (item.status == Status.CONFIRM) {
            dataStatusTask['CONFIRM'] = dataStatusTask['CONFIRM']! + 1;
          }
        }
      }
      dataMapView = dataMap;
      print('Thấp ${dataMap['Thấp']}');
      print('Trung bình ${dataMap['Trung bình']}');
      print('Cao ${dataMap['Cao']}');

      isLoading.value = false;
    } catch (e) {
      checkView.value = false;
    }
  }

  Future<void> refreshPage() async {
    checkView.value = true;
    listTask.clear();
    jwt = GetStorage().read('JWT');
    isLoading.value = true;
    await getAllTask();
    isLoading.value = false;
  }
}
