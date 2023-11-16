import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';

class ResetPasswordSuccessfullyController extends BaseController {
  //TODO: Implement ResetPasswordSuccessfullyController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  goToLogin() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    GetStorage().remove('JWT');
    GetStorage().remove('Email');
    Get.offAllNamed(Routes.LOGIN);
  }

  void increment() => count.value++;
}
