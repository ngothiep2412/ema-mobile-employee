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
      DateTime now = DateTime.now().toLocal();
      String jwt = getStorage.read('JWT');
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
      print('decodedToken ${decodedToken}');
      print('now ${now}');

      DateTime expTime = DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
      print(expTime.toLocal());
      // idUser = decodedToken['id'];
      // if (JwtDecoder.isExpired(jwt)) {
      //   Get.offAllNamed(Routes.LOGIN);
      //   return;
      // }
      if (expTime.toLocal().isBefore(now)) {
        Get.offAllNamed(Routes.LOGIN);
        return;
      } else {
        Get.offAllNamed(Routes.TAB_VIEW);
      }

      // String jwt = getStorage.read('JWT');
      // print('JwtDecoder.isExpired(jwt) ${JwtDecoder.isExpired(jwt)}');
      // DateTime expirationDate = JwtDecoder.getExpirationDate(jwt);
      // if (JwtDecoder.isExpired(jwt)) {
      //   getStorage.remove('JWT');
      //   Get.offAllNamed(Routes.LOGIN);
      // } else {
      //   Get.offAllNamed(Routes.TAB_VIEW);
      // }
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
