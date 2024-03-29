import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_employee/app/modules/task_schedule/task_schedule_api/task_schedule_api.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TaskScheduleController extends BaseController {
  final count = 0.obs;

  RxBool checkView = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    checkToken();
    String dateString = DateFormat('yyyy-MM-dd', 'vi').format(dateTime).toString();
    await getListTask(dateString);
    // dateTimeString.value = dateFormat.format(dateTime).toString();
    // if (dateTimeString == dateFormat.format(DateTime.now().toUtc().add(const Duration(hours: 7))).toString()) {
    //   dateTimeString.value = 'Hôm nay';
    // } else {
    //   dateTimeString.value = dateFormat.format(dateTime).toString();
    // }
  }

  DateFormat dateFormat = DateFormat('dd/MM/yyyy', 'vi');
  DateTime dateTime = DateTime.now().toUtc().add(const Duration(hours: 7));

  RxList<TaskModel> listTask = <TaskModel>[].obs;

  // RxString dateTimeString = ''.obs;
  String jwt = '';
  String idUser = '';
  String dateString = '';

  RxBool isLoading = false.obs;
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  // void check(DateTime value) {
  //   dateTime = value;
  //   String newDate = dateFormat.format(DateTime.now().toUtc().add(const Duration(hours: 7)));
  //   if (newDate == dateFormat.format(value).toString()) {
  //     dateTimeString.value = 'Hôm nay';
  //   } else {
  //     dateTimeString.value = dateFormat.format(value).toString();
  //   }
  // }

  Future<void> refreshPage() async {
    checkView.value = true;
    listTask.clear();
    jwt = GetStorage().read('JWT');
    isLoading.value = true;
    await getListTask(dateString);
    isLoading.value = false;
  }

  Future<void> getListTask(String date) async {
    try {
      String jwt = GetStorage().read('JWT');
      dateString = date;
      date = date.replaceAll("Z", ""); // Loại bỏ "Z" ở cuối

      DateTime dateTime = DateTime.parse(date);
      dateString = dateTime.toLocal().toString();
      print(dateString);
      isLoading.value = true;
      // Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
      listTask.clear();
      List<TaskModel> list = [];
      list = await TaskScheduleApi.getTaskByDate(jwt, dateString, idUser);
      listTask.value = list;
      isLoading.value = false;
    } catch (e) {
      checkView.value = false;
    }
  }

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

}
