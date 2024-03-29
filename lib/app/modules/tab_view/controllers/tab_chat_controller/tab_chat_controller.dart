import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/api/tab_chat_api/tab_chat_api.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/chat_user.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/event.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/user_division_model.dart';
import 'package:hrea_mobile_employee/app/resources/base_link.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:jwt_decoder/jwt_decoder.dart';

class TabChatController extends BaseController {
  ScrollController scrollController = ScrollController();
  var isMoreDataAvailable = true.obs;

  final count = 0.obs;
  RxList<EventModel> listEvent = <EventModel>[].obs;
  RxList<EventModel> listEventToday = <EventModel>[].obs;

  RxList<UserDivisionModel> listUserOnline = <UserDivisionModel>[].obs;
  RxList<UserDivisionModel> listUserOffline = <UserDivisionModel>[].obs;
  RxList<UserDivisionModel> listAllUser = <UserDivisionModel>[].obs;

  RxBool isLoading = false.obs;
  String jwt = '';

  RxList<ChatUserModel> listChatUser = <ChatUserModel>[].obs;

  RxBool errorGetChatUser = false.obs;
  RxString errorGetChatUserText = ''.obs;
  IO.Socket? socket;
  var page = 1;

  String idUser = '';
  String idDivision = '';

  List<UserDivisionModel> tempOnlineUsers = [];
  List<UserDivisionModel> tempOfflineUsers = [];

  RxBool checkInView = true.obs;

  Future<void> refreshpage() async {
    page = 1;
    listChatUser.clear();
    checkInView.value = true;

    connect();

    socket!.emit("getOnlineUser", {});
    socket!.emit('userJoin', {});

    // List<ChatUserModel> list = await TabChatApi.getAllChatUser(jwt, 1);
    // if (list.isNotEmpty) {
    //   for (var chatUser in list) {
    //     socket!.emit("onConversationJoin", (chatUser.id));
    //   }
    // }
    socket!.emit("getOnlineGroupUsers", {});

    socket!.on(
        "onlineGroupUsersReceived",
        (data) async => {
              tempOnlineUsers = [],
              tempOfflineUsers = [],
              listUserOffline.clear(),
              listUserOnline.clear(),
              print('${data['onlineUsers']}'),
              for (var item in data['onlineUsers'])
                {
                  if (item['id'] != idUser)
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
              listUserOnline.addAll(tempOnlineUsers),
              for (var item in data['offlineUsers'])
                {
                  if (item['id'] != idUser)
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
              listUserOffline.addAll(tempOfflineUsers),
              listAllUser.value = tempOnlineUsers + tempOfflineUsers,
            });

    socket!.on('userJoin', (data) => {print('data ${data}')});

    await getListChatUser(page);
    // await getUser();
    // connect();
    // socket!.emit("getOnlineUser", {});

    // List<ChatUserModel> list = await TabChatApi.getAllChatUser(jwt, 1);
    // if (list.isNotEmpty) {
    //   for (var chatUser in list) {
    //     socket!.emit("onConversationJoin", (chatUser.id));
    //   }
    // }

    // socket!.on('userJoin', (data) => {print('data ${data}')});
  }

  Future<void> connect() async {
    checkToken();
    socket = IO.io(BaseLink.socketIO, {
      "auth": {"access_token": jwt},
      "transports": ['websocket'],
      "autoConnect": false
    });
    socket!.connect();
    // socket!.onConnect((data) => print('Connection established'));
    // socket!.onConnectError((data) => print('Connect Error: $data'));
    // socket!.onDisconnect((data) => print('Socket.IO server disconnected'));
  }

  void checkToken() {
    if (GetStorage().read('JWT') != null) {
      jwt = GetStorage().read('JWT');
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
      idUser = decodedToken['id'];
      idDivision = decodedToken['divisionID'];
      //   if (JwtDecoder.isExpired(jwt)) {
      //     Get.offAllNamed(Routes.LOGIN);
      //     return;
      //   }
      // } else {
      //   Get.offAllNamed(Routes.LOGIN);
      //   return;
      // }

      // fetchData();
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    connect();
    await getListChatUser(page);
    // startFetchingData();
    // await getUser();

    paginateChatUser();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // socket!.disconnect();
    super.onClose();
  }

  @override
  void dispose() {
    // socket!.disconnect();
    super.dispose();
  }

  // Future<void> getUser() async {
  //   isLoading.value = true;
  //   isMoreDataAvailable.value = false;
  //   try {
  //     checkToken();
  //     listUser.clear();

  //     List<UserDivisionModel> list = await TabChatApi.getAllUserDivision(jwt, page, idDivision);

  //     listUser.value = list;
  //     // print('aaa');
  //     isLoading.value = false;
  //   } catch (e) {
  //     log(e.toString());
  //     errorGetChatUser.value = true;
  //     isLoading.value = false;
  //     errorGetChatUserText.value = "Có lỗi xảy ra";
  //   }
  // }

  // Hàm để lấy dữ liệu online và offline
  Future<void> fetchData() async {
    socket!.emit("getOnlineGroupUsers", {});
    socket!.on(
      "onlineGroupUsersReceived",
      (data) async {
        tempOnlineUsers = [];
        tempOfflineUsers = [];

        listUserOffline.clear();
        listUserOnline.clear();
        print('${data['onlineUsers']}');
        for (var item in data['onlineUsers']) {
          if (item['id'] != idUser) {
            tempOnlineUsers.add(UserDivisionModel(
              id: item['id'],
              fullName: item['fullName'],
              email: item['email'],
              avatar: item['avatar'],
              online: true,
            ));
          }
        }

        listUserOnline.addAll(tempOnlineUsers);

        for (var item in data['offlineUsers']) {
          if (item['id'] != idUser) {
            tempOfflineUsers.add(UserDivisionModel(
              id: item['id'],
              fullName: item['fullName'],
              email: item['email'],
              avatar: item['avatar'],
              online: false,
            ));
          }
        }
        listUserOffline.addAll(tempOfflineUsers);
        listAllUser.value = tempOnlineUsers + tempOfflineUsers;
      },
    );
  }

  void startFetchingData() {
    // Tạo một vòng lặp vô hạn sử dụng hàm Timer.periodic
    Timer.periodic(Duration(seconds: 5), (timer) async {
      // Gọi hàm để lấy dữ liệu online và offline
      await fetchData();
    });
  }

  void paginateChatUser() {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        print('reached end');
        page++;
        getMoreChatUser(page);
      }
    });
  }

  Future<void> getListChatUser(var page) async {
    isLoading.value = true;
    isMoreDataAvailable.value = false;
    try {
      checkToken();
      // listChatUser.clear();
      List<ChatUserModel> list = await TabChatApi.getAllChatUser(jwt, page);
      // List<ChatUserModel> listAll = await TabChatApi.getAllChatUser(jwt, page);
      list = list.where((item) => item.lastMessageSent != null).toList();
      for (var i = 0; i < list.length; i++) {
        var item = list[i];
        for (var userOnline in listUserOnline) {
          if (item.creator!.id == userOnline.id) {
            list[i].online = true;
          } else if (item.recipient!.id == userOnline.id) {
            list[i].online = true;
          }
        }
      }

      listChatUser.value = list;
      // print('aaa');
      isLoading.value = false;
    } catch (e) {
      log(e.toString());
      errorGetChatUser.value = true;
      isLoading.value = false;
      errorGetChatUserText.value = "Có lỗi xảy ra";
      checkInView.value = true;
    }
  }

  void getMoreChatUser(var page) async {
    try {
      List<ChatUserModel> list = [];

      list = await TabChatApi.getAllChatUser(jwt, page);

      if (list.isNotEmpty) {
        isMoreDataAvailable(true);
      } else {
        isMoreDataAvailable(false);
      }
      // list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      listChatUser.addAll(list);

      // listNotifications.value =
      //     listNotifications.where((e) => e.status != "CANCEL").toList();

      isLoading.value = false;
    } catch (e) {
      isMoreDataAvailable(false);
      print(e);
      checkInView.value = true;
      ;
    }
  }

  Future<void> uploadChatUser() async {
    listChatUser.clear();
    page = 1;
    await getListChatUser(page);
  }
}
