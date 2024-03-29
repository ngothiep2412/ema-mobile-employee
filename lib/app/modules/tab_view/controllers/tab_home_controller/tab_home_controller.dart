import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/api/tab_home_api/tab_home_api.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/event.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TabHomeController extends BaseController {
  ScrollController scrollController = ScrollController();
  var isMoreDataAvailable = true.obs;

  final count = 0.obs;
  RxList<EventModel> listEvent = <EventModel>[].obs;
  RxList<EventModel> listEventUpComing = <EventModel>[].obs;
  RxList<EventModel> listEventToday = <EventModel>[].obs;

  RxBool isLoading = false.obs;
  String jwt = '';
  String idUser = '';

  RxBool checkInView = true.obs;

  Future<void> refreshpage() async {
    checkInView.value = true;
    try {
      listEvent.clear();
      listEventToday.clear();

      print('1: ${isLoading.value}');
      isLoading.value = true;
      listEventUpComing.value = await TabHomeApi.getEventUpComing(jwt, idUser);
      listEvent.value = await TabHomeApi.getEvent(jwt);

      listEventToday.value = await TabHomeApi.getEventToday(jwt, idUser);

      for (var todayEvent in listEventToday) {
        // Tìm sự kiện trong ngày trong danh sách sự kiện sắp diễn ra
        var index = listEventUpComing.indexWhere((upcomingEvent) => upcomingEvent.id == todayEvent.id);
        print('$index');
        if (index != -1) {
          listEventUpComing.removeAt(index);
        }
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      checkInView.value = false;
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

  Future<void> getEvent() async {
    try {
      checkToken();
      isLoading.value = true;

      listEvent.value = await TabHomeApi.getEvent(jwt);
      listEventUpComing.value = await TabHomeApi.getEventUpComing(jwt, idUser);
      listEventToday.value = await TabHomeApi.getEventToday(jwt, idUser);

      for (var todayEvent in listEventToday) {
        // Tìm sự kiện trong ngày trong danh sách sự kiện sắp diễn ra
        var index = listEventUpComing.indexWhere((upcomingEvent) => upcomingEvent.id == todayEvent.id);
        print('$index');
        if (index != -1) {
          listEventUpComing.removeAt(index);
        }
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      checkInView.value = false;
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await getEvent();

    // listEvent.value = [
    //   EventModel(id:'1',image: 'https://www.shutterstock.com/image-vector/events-colorful-typography-banner-260nw-1356206768.jpg',title: 'Công việc cá nhân'),
    //   EventModel(id:'2',image: 'https://www.adobe.com/content/dam/www/us/en/events/overview-page/eventshub_evergreen_opengraph_1200x630_2x.jpg',title: 'Lễ kỉ niệm 10 năm')
    // ];
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onTapEvent({required String eventID, required String eventName}) {
    Get.toNamed(Routes.TASK_OVERALL_VIEW, arguments: {"eventID": eventID, "eventName": eventName});
  }
}
