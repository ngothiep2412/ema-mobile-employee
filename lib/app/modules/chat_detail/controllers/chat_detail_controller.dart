import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:hrea_mobile_employee/app/modules/chat_detail/api/chat_detail_api.dart';
import 'package:hrea_mobile_employee/app/modules/chat_detail/models/chat.dart';
import 'package:hrea_mobile_employee/app/modules/chat_detail/models/chat_message.dart';
import 'package:hrea_mobile_employee/app/modules/chat_detail/models/message.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/api/tab_chat_api/tab_chat_api.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/controllers/tab_chat_controller/tab_chat_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/chat_user.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/user_division_model.dart';
import 'package:hrea_mobile_employee/app/resources/base_link.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum MessageType {
  Sender,
  Receiver,
}

class ChatDetailController extends BaseController {
  ChatDetailController({required this.email, required this.userIDChat, required this.name, required this.avatar, required this.listUserOnline});

  Rx<TextEditingController> textEditingController = TextEditingController().obs;

  RxBool checkTyping = false.obs;

  RxList<ChatMessage> chatMessages = <ChatMessage>[].obs;

  RxList<UserDivisionModel> listUserOnline;

  String email;
  String userIDChat;
  String name;
  String avatar;

  IO.Socket? socket;
  String jwt = '';
  String idUser = '';

  int page = 10;

  RxBool isLoading = false.obs;
  RxBool errorGetChatUser = false.obs;
  RxString errorGetChatUserText = ''.obs;

  String lastKey = '';

  final count = 0.obs;

  String conversationID = '';
  bool checkConversation = false;

  RxBool isMoreDataAvailable = false.obs;
  RxBool isScrollDown = false.obs;

  RxBool checkOnline = false.obs;

  List<UserDivisionModel> tempOnlineUsers = [];
  List<UserDivisionModel> tempOfflineUsers = [];

  ScrollController scrollController = ScrollController();

  RxBool checkInView = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await checkIsConverstation();
    await getListChatUser();

    for (var item in listUserOnline) {
      if (item.id == userIDChat) {
        checkOnline.value = true;
        break;
      }
    }
    socket = IO.io(BaseLink.socketIO, {
      "auth": {"access_token": jwt},
      "transports": ['websocket'],
      "autoConnect": false
    });
    // socket!.connect();

    socket!.on("onTypingStart", (data) => {print('typing ${data}')});
    socket!.on('onMessage', (data) async {
      print('data message: ${data['message']}');
      if (data['message']['author']['id'] != idUser) {
        ChatMessage newChatMessage = ChatMessage(
          message: data['message']['content'],
          type: MessageType.Receiver,
          time: data['message']['createdAt'].toString(),
        );
        // Thêm ChatMessage mới vào đầu danh sách
        chatMessages.insert(0, newChatMessage);
      }
    });

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
                      )),
                      if (item['id'] == userIDChat)
                        {
                          checkOnline.value = true,
                        }
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
              // await Get.find<TabChatController>().getListChatUser(1),
            });

    paginateHistoryChat();
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

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  RxBool showTime = false.obs;
  RxInt indexChat = 0.obs;

  Future<void> checkIsConverstation() async {
    try {
      checkToken();

      List<ChatUserModel> listConversation = await TabChatApi.getAllChatUserV2(jwt, 1);
      String creatorId;
      String recipientId;

      // Lặp qua từng tin nhắn trong danh sách
      for (var conversation in listConversation) {
        // Kiểm tra nếu ID của người tạo hoặc người nhận trùng với userId
        if (conversation.creator!.id == userIDChat) {
          creatorId = conversation.creator!.id!;
          checkConversation = true;
          conversationID = conversation.id!;
          break;
        }
        if (conversation.recipient!.id == userIDChat) {
          recipientId = conversation.recipient!.id!;
          checkConversation = true;
          conversationID = conversation.id!;
          break;
        }
      }
    } catch (e) {
      log(e.toString());
      errorGetChatUser.value = true;
      isLoading.value = false;
      errorGetChatUserText.value = "Có lỗi xảy ra";
      checkInView.value = false;
    }
  }

  Future<void> getListChatUser() async {
    isLoading.value = true;
    try {
      List<ChatModel> list;
      MessageModel message;
      if (checkConversation) {
        message = await ChatDetailApi.getChatUserV2(jwt, conversationID, page, '');
        if (message.lastKey != null) {
          lastKey = message.lastKey!;
        }
        list = await ChatDetailApi.getChatUser(jwt, conversationID, page, '');
        for (var chat in list) {
          String content = chat.content!;
          String authorId = chat.author!.id!;
          String time = chat.createdAt!.toLocal().toString();

          MessageType messageType = authorId == idUser ? MessageType.Sender : MessageType.Receiver;
          chatMessages.add(ChatMessage(
            message: content,
            type: messageType,
            time: time,
          ));
        }
      } else {
        chatMessages.value = [];
      }

      // print('aaa');

      isLoading.value = false;
    } catch (e) {
      log(e.toString());
      errorGetChatUser.value = true;
      isLoading.value = false;
      errorGetChatUserText.value = "Có lỗi xảy ra";
      checkInView.value = false;
    }
  }

  Future<void> createAMessage(String message) async {
    try {
      checkToken();
      if (checkConversation) {
        // chatMessages.clear();
        ResponseApi responseApi = await ChatDetailApi.createMessage(jwt, email, message, conversationID);

        if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
          // Tạo một đối tượng ChatMessage mới
          ChatMessage newChatMessage = ChatMessage(
            message: message,
            type: MessageType.Sender,
            time: DateTime.now().toLocal().toString(),
          );

// Thêm ChatMessage mới vào đầu danh sách
          chatMessages.insert(0, newChatMessage);

          // socket!.emit("onConversationJoin", (conversationID));
          Get.find<TabChatController>().refreshpage();
          textEditingController.value.clear();
        } else {
          checkInView.value = false;
        }
      } else {
        await ChatDetailApi.createConversation(email, message, jwt);

        // ResponseApi responseApi = await ChatDetailApi.createMessage(jwt, email, message, conversationID);

        // if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        ChatMessage newChatMessage = ChatMessage(
          message: message,
          type: MessageType.Sender,
          time: DateTime.now().toLocal().toString(),
        );

        // Thêm ChatMessage mới vào đầu danh sách
        chatMessages.insert(0, newChatMessage);

        // socket!.emit("onConversationJoin", (conversationID));
        checkConversation = true;
        textEditingController.value.clear();
        Get.find<TabChatController>().refreshpage();
        // } else {
        //   checkInView.value = false;
        // }
      }
      // Get.find<TabChatController>().uploadChatUser();
    } catch (e) {
      log(e.toString());
      errorGetChatUser.value = true;
      checkInView.value = false;
      errorGetChatUserText.value = "Có lỗi xảy ra";
    }
  }

  void paginateHistoryChat() {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        print('reached end');

        getMoreChatHistory(page);
      }
      if ((scrollController.position.pixels - scrollController.position.minScrollExtent) > 400) {
        isScrollDown.value = true;
      }
      if ((scrollController.position.pixels - scrollController.position.minScrollExtent) < 100) {
        isScrollDown.value = false;
      }
    });
  }

  void scrollDown() {
    scrollController.animateTo(scrollController.position.minScrollExtent, duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
    isScrollDown.value = false;
  }

  void getMoreChatHistory(var page) async {
    try {
      List<ChatModel> list = [];
      print('$lastKey');
      list = await ChatDetailApi.getChatUser(jwt, conversationID, page, lastKey);
      MessageModel message;
      message = await ChatDetailApi.getChatUserV2(jwt, conversationID, page, lastKey);
      lastKey = message.lastKey!;

      if (list.isNotEmpty) {
        isMoreDataAvailable(true);
        for (var chat in list) {
          String content = chat.content!;
          String authorId = chat.author!.id!;
          String time = chat.createdAt!.toLocal().toString();

          MessageType messageType = authorId == idUser ? MessageType.Sender : MessageType.Receiver;
          chatMessages.add(ChatMessage(
            message: content,
            type: messageType,
            time: time,
          ));
        }
      } else {
        isMoreDataAvailable(false);
      }

      isLoading.value = false;
    } catch (e) {
      isMoreDataAvailable(false);
      checkInView.value = false;
      print(e);
      ;
    }
  }
}
