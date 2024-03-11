import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/subtask-detail-view/api/subtask_detail_api.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/api/tab_notification_api/tab_notification_api.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/controllers/tab_view_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/notification.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TabNotificationController extends BaseController {
  RxBool isLoading = false.obs;
  DateTime createdAt = DateTime(2023, 10, 17, 14, 30);

  var page = 1;
  RxBool mark = false.obs;
  ScrollController scrollController = ScrollController();
  var isMoreDataAvailable = false.obs;

  String jwt = '';
  String idUser = '';

  DateFormat dateFormat = DateFormat('dd/MM/yyyy', 'vi');

  RxBool errorGetNotification = false.obs;
  RxString errorGetNotificationText = ''.obs;

  RxList<NotificationModel> listNotifications = <NotificationModel>[].obs;
  final count = 0.obs;

  DateTime startDateParentTask = DateTime.now();
  DateTime endDateParentTask = DateTime.now();

  @override
  Future<void> onInit() async {
    super.onInit();

    await getAllNotification(page);

    paginateNotification();
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

  Future<void> markAllRead() async {
    isLoading.value = true;
    try {
      checkToken();

      ResponseApi responseApi = await TabNotificationApi.seenAllNotification(jwt);
      if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        List<NotificationModel> list = await TabNotificationApi.getAllNotification(jwt, page);

        list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

        listNotifications.value = list;
      } else {}
      isLoading.value = false;
      Get.find<TabViewController>().checkAllNotiSeen.value = true;
    } catch (e) {
      log(e.toString());
      errorGetNotification.value = true;
      isLoading.value = false;
      errorGetNotificationText.value = "Có lỗi xảy ra";
    }
  }

  Future<void> deleteNotification(String notificationID) async {
    try {
      checkToken();
      ResponseApi responseApi = await TabNotificationApi.deleteNotification(jwt, notificationID);
      if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        List<NotificationModel> list = await TabNotificationApi.getAllNotification(jwt, page);

        list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

        listNotifications.value = list;
        print('aaa123');
      } else {
        errorGetNotification.value = true;

        errorGetNotificationText.value = "Có lỗi xảy ra";
      }
    } catch (e) {
      log(e.toString());
      errorGetNotification.value = true;

      errorGetNotificationText.value = "Có lỗi xảy ra";
    }
  }

  Future<void> deleteAllNotification() async {
    try {
      checkToken();

      ResponseApi responseApi = await TabNotificationApi.deleteAllNotification(jwt);
      if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        List<NotificationModel> list = await TabNotificationApi.getAllNotification(jwt, page);

        list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

        listNotifications.value = list;
        Get.find<TabViewController>().checkAllNotiSeen.value = true;
      } else {}
    } catch (e) {
      log(e.toString());
      errorGetNotification.value = true;

      errorGetNotificationText.value = "Có lỗi xảy ra";
    }
  }

  Future<void> markSeen(String notificationID) async {
    try {
      checkToken();

      ResponseApi responseApi = await TabNotificationApi.seenANotification(jwt, notificationID);
      print('aa ${responseApi.statusCode}');
      if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        List<NotificationModel> list = await TabNotificationApi.getAllNotification(jwt, page);

        list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

        listNotifications.value = list;
        bool allRead = true;
        for (var item in list) {
          if (item.isRead == 0) {
            allRead = false;
            break;
          }
        }
        if (allRead) {
          Get.find<TabViewController>().checkAllNotiSeen.value = true;
        } else {
          Get.find<TabViewController>().checkAllNotiSeen.value = false;
        }
      } else {
        errorGetNotification.value = true;

        errorGetNotificationText.value = "Có lỗi xảy ra";
      }
    } catch (e) {
      log(e.toString());

      errorGetNotification.value = true;

      errorGetNotificationText.value = "Có lỗi xảy ra";
    }
  }

  void checkToken() {
    if (GetStorage().read('JWT') != null) {
      jwt = GetStorage().read('JWT');
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
      idUser = decodedToken['id'];
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  Future<void> getAllNotification(var page) async {
    isLoading.value = true;
    isMoreDataAvailable.value = false;
    try {
      checkToken();
      List<NotificationModel> list = await TabNotificationApi.getAllNotification(jwt, page);

      listNotifications.clear();
      list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

      listNotifications.value = list;

      // listNotifications.value =
      //     listNotifications.where((e) => e.status != "CANCEL").toList();
      if (listNotifications.isNotEmpty) {
        // Assume all notifications are seen until proven otherwise
        Get.find<TabViewController>().checkAllNotiSeen.value = true;

        for (var item in listNotifications) {
          if (item.isRead == 0) {
            // At least one notification is not seen
            Get.find<TabViewController>().checkAllNotiSeen.value = false;
            break; // No need to continue checking, we found one not seen
          }
        }
      } else {
        // If the list is empty, you might want to consider how to handle this case
        Get.find<TabViewController>().checkAllNotiSeen.value = true;
      }

      isLoading.value = false;
    } catch (e) {
      log(e.toString());
      errorGetNotification.value = true;
      isLoading.value = false;
      errorGetNotificationText.value = "Có lỗi xảy ra";
    }
  }

  void paginateNotification() {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        print('reached end');
        page++;
        getMoreNotification(page);
      }
    });
  }

  void getMoreNotification(var page) async {
    try {
      List<NotificationModel> list = [];

      list = await TabNotificationApi.getAllNotification(jwt, page);

      if (list.isNotEmpty) {
        isMoreDataAvailable(true);
      } else {
        isMoreDataAvailable(false);
      }
      list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      listNotifications.addAll(list);

      // listNotifications.value =
      //     listNotifications.where((e) => e.status != "CANCEL").toList();

      isLoading.value = false;
    } catch (e) {
      isMoreDataAvailable(false);
      print(e);
      ;
    }
  }

  Future<void> refreshPage() async {
    // listBudget.clear();
    page = 1;
    await getAllNotification(page);
  }

  Future<void> uploadNoti() async {
    listNotifications.clear();
    page = 1;
    await getAllNotification(page);
  }

  void getTaskDetail(String taskID, int index) {
    try {
      Get.toNamed(Routes.SUBTASK_DETAIL_VIEW, arguments: {
        "taskID": listNotifications[index].commonId,
        "isNavigateDetail": false,
      });
    } catch (e) {
      print(e);
    }
  }
}
