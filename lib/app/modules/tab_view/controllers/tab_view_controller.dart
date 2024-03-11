import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/api/tab_chat_api/tab_chat_api.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/controllers/tab_chat_controller/tab_chat_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/controllers/tab_home_controller/tab_home_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/controllers/tab_notification_controller/tab_notification_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/controllers/tab_setting_controller/tab_setting_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/chat_user.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/user_division_model.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/views/tab_chat_view/tab_chat_view.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/views/tab_home_view/tab_home_view.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/views/tab_notification_view/tab_notification_view.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/views/tab_setting_view/tab_setting_view.dart';

import 'package:hrea_mobile_employee/app/resources/base_link.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TabViewController extends BaseController {
  RxList<Widget> body = RxList([
    const TabHomeView(),
    // const TabTimeKeepingView(),
    // const TabRequestView(),
    const TabChatView(),
    const TabNotificationView(),
    const TabSettingView()
  ]);
  IO.Socket? socket;
  RxInt selectedIndex = 0.obs;
  String jwt = '';
  String idUser = '';
  RxBool checkAllNotiSeen = true.obs;

  List<UserDivisionModel> tempOnlineUsers = [];
  List<UserDivisionModel> tempOfflineUsers = [];

  @override
  Future<void> onInit() async {
    super.onInit();
    connect();
    // startFetchingData();
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
    socket!.emit("getOnlineUser", {});

    List<ChatUserModel> list = await TabChatApi.getAllChatUser(jwt, 1);
    if (list.isNotEmpty) {
      for (var chatUser in list) {
        socket!.emit("onConversationJoin", (chatUser.id));
      }
    }
    socket!.emit("getOnlineGroupUsers", {});
    socket!.on(
        "onlineGroupUsersReceived",
        (data) async => {
              tempOnlineUsers = [],
              tempOfflineUsers = [],

              Get.find<TabChatController>().listUserOffline.clear(),
              Get.find<TabChatController>().listUserOnline.clear(),
              print('${data['onlineUsers']}'),
              for (var item in data['onlineUsers'])
                {
                  if (item['id'] != Get.find<TabChatController>().idUser)
                    {
                      tempOnlineUsers.add(UserDivisionModel(
                        id: item['id'],
                        fullName: item['fullName'],
                        email: item['email'],
                        avatar: item['avatar'],
                        online: true,
                      ))
                    }
                },
              Get.find<TabChatController>().listUserOnline.addAll(tempOnlineUsers),
              for (var item in data['offlineUsers'])
                {
                  if (item['id'] != Get.find<TabChatController>().idUser)
                    {
                      tempOfflineUsers.add(UserDivisionModel(
                        id: item['id'],
                        fullName: item['fullName'],
                        email: item['email'],
                        avatar: item['avatar'],
                        online: false,
                      ))
                    }
                },
              Get.find<TabChatController>().listUserOffline.addAll(tempOfflineUsers),
              Get.find<TabChatController>().listAllUser.value = tempOnlineUsers + tempOfflineUsers,
//               // await Get.find<TabChatController>().getListChatUser(1),
            });
    // Get.put(ChatDetailController());
    socket!.on('userJoin', (data) => {print('userJoin')});
    socket!.on('onMessage', (data) async {
      // print('${data}');

      Get.find<TabChatController>().uploadChatUser();
      // Get.find<ChatDetailController>.
    });

    socket!.on('notification', (data) async {
      Get.find<TabNotificationController>().uploadNoti();
      Get.find<TabViewController>().checkAllNotiSeen.value = false;
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

  // Hàm để lấy dữ liệu online và offline
  Future<void> fetchData() async {
    socket!.emit("getOnlineGroupUsers", {});
    socket!.on(
      "onlineGroupUsersReceived",
      (data) async {
        tempOnlineUsers = [];
        tempOfflineUsers = [];

        Get.find<TabChatController>().listUserOffline.clear();
        Get.find<TabChatController>().listUserOnline.clear();
        print('${data['onlineUsers']}');
        for (var item in data['onlineUsers']) {
          if (item['id'] != Get.find<TabChatController>().idUser) {
            tempOnlineUsers.add(UserDivisionModel(
              id: item['id'],
              fullName: item['fullName'],
              email: item['email'],
              avatar: item['avatar'],
              online: true,
            ));
          }
        }
        Get.find<TabChatController>().listUserOnline.addAll(tempOnlineUsers);
        for (var item in data['offlineUsers']) {
          if (item['id'] != Get.find<TabChatController>().idUser) {
            tempOfflineUsers.add(UserDivisionModel(
              id: item['id'],
              fullName: item['fullName'],
              email: item['email'],
              avatar: item['avatar'],
              online: false,
            ));
          }
        }
        Get.find<TabChatController>().listUserOffline.addAll(tempOfflineUsers);
        Get.find<TabChatController>().listAllUser.value = tempOnlineUsers + tempOfflineUsers;

        // int page = Get.find<TabChatController>().page;
        // Get.find<TabChatController>().getListChatUserV2();
      },
    );
  }

  // void startFetchingData() {
  //   // Tạo một vòng lặp vô hạn sử dụng hàm Timer.periodic
  //   Timer.periodic(Duration(seconds: 5), (timer) async {
  //     // Gọi hàm để lấy dữ liệu online và offline
  //     await fetchData();
  //   });
  // }

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
      // case 1:
      //   Get.find<TabTimeKeepingController>();
      //   selectedIndex(index);
      //   break;
      // case 1:
      //   Get.find<TabRequestController>();
      //   selectedIndex(index);
      //   break;
      case 1:
        Get.find<TabChatController>();
        selectedIndex(index);
        break;
      case 2:
        Get.find<TabNotificationController>();
        selectedIndex(index);
        break;
      case 3:
        Get.find<TabSettingController>();
        await Get.find<TabSettingController>().getProfile();
        selectedIndex(index);
        break;
      default:
    }
  }
}
