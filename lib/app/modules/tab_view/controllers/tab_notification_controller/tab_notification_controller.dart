import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/api/tab_notification_api/tab_notification_api.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/controllers/tab_view_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/notification.dart';
import 'package:hrea_mobile_employee/app/resources/base_link.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TabNotificationController extends BaseController {
  RxBool isLoading = false.obs;
  DateTime createdAt = DateTime(2023, 10, 17, 14, 30);

  var page = 1;
  RxBool mark = false.obs;
  var scrollController = ScrollController().obs;
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

  IO.Socket? socket;

  RxBool checkInView = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    // connect();
    await getAllNotification(page);

    await paginateNotification();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> connect() async {
    checkToken();
    socket = IO.io(BaseLink.socketIO, {
      "auth": {"access_token": jwt},
      "transports": ['websocket'],
      "autoConnect": false
    });
    socket!.connect();

    socket!.on('notification', (data) async {
      Get.find<TabViewController>().checkAllNotiSeen.value = false;
      await uploadNoti();
      // listNotifications.value = list;

      // listNotifications.add(NotificationModel(
      //     commonId: data['commonId'],
      //     content: data['content'],
      //     type: data['type'],
      //     readFlag: data['readFlag'] == false ? 0 : 1,
      //     eventId: data['eventId'],
      //     createdAt:
      //         DateTime.now().toUtc().toLocal().add(Duration(hours: 7)),
      //     avatarSender: data['avatar'])),
      // print('noti ${data}'),
      // listNotifications
      //     .sort((a, b) => b.createdAt!.compareTo(a.createdAt!))
    });
    // socket!.onConnect((data) => print('Connection established'));
    // socket!.onConnectError((data) => print('Connect Error: $data'));
    // socket!.onDisconnect((data) => print('Socket.IO server disconnected'));
  }

  void increment() => count.value++;

  Future<void> markAllRead() async {
    isLoading.value = true;
    try {
      checkToken();

      ResponseApi responseApi = await TabNotificationApi.seenAllNotification(jwt);
      if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        int pageView = 1;
        List<NotificationModel> list = await TabNotificationApi.getAllNotification(jwt, pageView);

        list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
        if (list.length < listNotifications.length) {
          List<NotificationModel> listV2 = await TabNotificationApi.getAllNotification(jwt, pageView + 1);
          list = list + listV2;
        }

        listNotifications.value = list;
        Get.find<TabViewController>().checkAllNotiSeen.value = true;
      } else {
        checkInView.value = false;
      }
      isLoading.value = false;
    } catch (e) {
      log(e.toString());
      errorGetNotification.value = true;
      isLoading.value = false;
      errorGetNotificationText.value = "Có lỗi xảy ra";
      checkInView.value = false;
    }
  }

  Future<void> deleteNotification(String notificationID) async {
    try {
      checkToken();
      ResponseApi responseApi = await TabNotificationApi.deleteNotification(jwt, notificationID);
      if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        int pageView = 1;
        List<NotificationModel> list = await TabNotificationApi.getAllNotification(jwt, pageView);

        list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
        if (list.length < listNotifications.length) {
          List<NotificationModel> listV2 = await TabNotificationApi.getAllNotification(jwt, pageView + 1);
          list = list + listV2;
        }

        listNotifications.value = list;
        print('aaa123');
      } else {
        errorGetNotification.value = true;
        checkInView.value = false;
        errorGetNotificationText.value = "Có lỗi xảy ra";
        checkInView.value = false;
      }
    } catch (e) {
      log(e.toString());
      errorGetNotification.value = true;
      checkInView.value = false;
      errorGetNotificationText.value = "Có lỗi xảy ra";
    }
  }

  Future<void> deleteAllNotification() async {
    try {
      checkToken();

      await TabNotificationApi.deleteAllNotification(jwt);

      listNotifications.value = [];
      Get.find<TabViewController>().checkAllNotiSeen.value = true;
    } catch (e) {
      log(e.toString());
      errorGetNotification.value = true;

      errorGetNotificationText.value = "Có lỗi xảy ra";
      checkInView.value = false;
    }
  }

  Future<void> markSeen(String notificationID, int index) async {
    try {
      checkToken();

      ResponseApi responseApi = await TabNotificationApi.seenANotification(jwt, notificationID);

      if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        int pageView = 1;
        List<NotificationModel> list = await TabNotificationApi.getAllNotification(jwt, pageView);

        list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
        if (list.length < listNotifications.length) {
          List<NotificationModel> listV2 = await TabNotificationApi.getAllNotification(jwt, pageView + 1);
          list = list + listV2;
        }

        listNotifications.value = list;
        // listNotifications[index].isRead == 1;

        // listNotifications.elementAt(index).isRead == 1;

        bool allRead = true;
        for (var item in listNotifications) {
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
        checkInView.value = false;
        errorGetNotificationText.value = "Có lỗi xảy ra";
        checkInView.value = false;
      }
    } catch (e) {
      log(e.toString());

      errorGetNotification.value = true;
      checkInView.value = false;
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
      checkInView.value = false;
    }
  }

  Future<void> paginateNotification() async {
    scrollController.value.addListener(() async {
      if (scrollController.value.position.pixels == scrollController.value.position.maxScrollExtent) {
        print('reached end');
        page++;
        await getMoreNotification(page);
      }
    });
  }

  Future<void> getMoreNotification(var page) async {
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
      checkInView.value = false;
      ;
    }
  }

  Future<void> refreshPage() async {
    // listBudget.clear();
    checkInView.value = true;
    page = 1;
    await getAllNotification(page);
  }

  Future<void> uploadNoti() async {
    listNotifications.clear();
    page = 1;
    await getAllNotification(page);
  }
}
