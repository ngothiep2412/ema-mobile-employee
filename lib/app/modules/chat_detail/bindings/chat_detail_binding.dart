import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/user_division_model.dart';

import '../controllers/chat_detail_controller.dart';

class ChatDetailBinding extends BaseBindings {
  String email = '';
  String userIDChat = '';
  String name = '';
  String avatar = '';
  RxList<UserDivisionModel> listUserOnline = <UserDivisionModel>[].obs;

  @override
  void injectService() {
    email = Get.arguments["email"] as String;
    name = Get.arguments["name"] as String;
    avatar = Get.arguments["avatar"] as String;
    listUserOnline = Get.arguments["listUserOnline"] as RxList<UserDivisionModel>;

    userIDChat = Get.arguments["userIDChat"] as String;
    Get.lazyPut<ChatDetailController>(
      () => ChatDetailController(email: email, userIDChat: userIDChat, name: name, avatar: avatar, listUserOnline: listUserOnline),
    );
  }
}
