import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';

import '../controllers/profile_chat_controller.dart';

class ProfileChatBinding extends BaseBindings {
  String idUserChat = '';

  @override
  void injectService() {
    idUserChat = Get.arguments["idUserChat"] as String;
    Get.lazyPut<ProfileChatController>(
      () => ProfileChatController(idUserChat: idUserChat),
    );
  }
}
