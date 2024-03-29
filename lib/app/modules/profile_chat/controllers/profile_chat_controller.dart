import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/profile_chat/api/profile_chat_api.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/user_model.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ProfileChatController extends BaseController {
  ProfileChatController({required this.idUserChat});

  String idUser = '';
  String idUserChat = '';
  String jwt = '';

  RxBool isLoading = false.obs;
  Rx<UserModel> userChatView = UserModel().obs;
  RxBool checkInView = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    await getUserChatDetail(idUserChat);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
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

  Future<void> getUserChatDetail(String idUserChat) async {
    isLoading.value = true;
    try {
      checkToken();
      UserModel userChat = await ProfileChatApi.getUserDetail(idUserChat, jwt);
      userChatView.value = userChat;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print(e);
      checkInView.value = false;
    }
  }
}
