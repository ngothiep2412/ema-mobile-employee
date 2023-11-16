import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/controllers/tab_home_controller/tab_home_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/controllers/tab_notification_controller/tab_notification_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/controllers/tab_request_controller/tab_request_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/controllers/tab_setting_controller/tab_setting_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/controllers/tab_timekeeping_controller/tab_timekeeping_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/views/tab_home_view/tab_home_view.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/views/tab_notification_view/tab_notification_view.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/views/tab_request_view/tab_request_view.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/views/tab_setting_view/tab_setting_view.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/views/tab_timesheet_view/tab_timesheet_view.dart';
import 'package:hrea_mobile_employee/app/resources/base_link.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TabViewController extends BaseController {
  RxList<Widget> body =
      RxList([const TabHomeView(), const TabTimeKeepingView(), const TabRequestView(), const TabNotificationView(), const TabSettingView()]);
  IO.Socket? socket;
  RxInt selectedIndex = 0.obs;
  String jwt = '';
  String idUser = '';
  RxBool checkAllNotiSeen = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    connect();
    await Get.find<TabNotificationController>().uploadNoti();
    // checkNoti.value = Get.find<TabNotificationController>().checkAllNotiSeen.value;
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

  Future<void> connect() async {
    checkToken();
    socket = IO.io(BaseLink.socketIO, {
      "auth": {"access_token": jwt},
      "transports": ['websocket'],
      "autoConnect": false
    });
    socket!.connect();
    socket!.onConnect((data) => print('Connection established'));
    socket!.onConnectError((data) => print('Connect Error: $data'));
    socket!.onDisconnect((data) => print('Socket.IO server disconnected'));
    socket!.on('notification', (data) async {
      // listNotifications.add(noti),

      // listNotifications.add(NotificationModel(
      //     commonId: data['commonId'],
      //     content: data['content'],
      //     type: data['type'],
      //     readFlag: data['readFlag'] == false ? 0 : 1,
      //     eventId: data['eventId'],
      //     createdAt: DateTime.now().toUtc().toLocal().add(Duration(hours: 7)),
      //     avatarSender: data['avatar']));

      // listNotifications.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      Get.find<TabNotificationController>().uploadNoti();
      // checkNoti.value = Get.find<TabNotificationController>().checkAllNotiSeen.value;
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
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    socket!.disconnect();
    super.onClose();
  }

  @override
  void dispose() {
    socket!.disconnect();
    super.dispose();
  }

  onTapped(int index) async {
    switch (index) {
      case 0:
        Get.find<TabHomeController>();
        // Get.find<TabHomeController>().isLoading.value = true;
        // Get.find<TabHomeController>().isLoading.value = false;
        // userModel.value =
        //     (await Get.find<TabSettingController>().getProfile()).value;
        // print(userModel.value.result!.fullName);

        selectedIndex(index);
        await Get.find<TabHomeController>().getEvent();
        break;
      case 1:
        Get.find<TabTimeKeepingController>();
        selectedIndex(index);
        break;
      case 2:
        Get.find<TabRequestController>();
        selectedIndex(index);
        break;
      case 3:
        Get.find<TabNotificationController>();
        selectedIndex(index);
        break;
      case 4:
        Get.find<TabSettingController>();
        await Get.find<TabSettingController>().getProfile();
        selectedIndex(index);
        break;
      default:
    }
  }
}
