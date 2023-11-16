import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SplashScreenController extends BaseController {
  final getStorage = GetStorage();
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    if (getStorage.read('JWT') != null) {
      String jwt = getStorage.read('JWT');
      print('JwtDecoder.isExpired(jwt) ${JwtDecoder.isExpired(jwt)}');
      DateTime expirationDate = JwtDecoder.getExpirationDate(jwt);
      if (JwtDecoder.isExpired(jwt)) {
        getStorage.remove('JWT');
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.offAllNamed(Routes.TAB_VIEW);
      }
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
