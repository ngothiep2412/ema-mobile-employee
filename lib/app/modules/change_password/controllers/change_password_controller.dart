import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/change_password/api/change_password_api.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ChangePasswordController extends BaseController {
  RxBool oldPasswordObscured = true.obs;
  RxBool newPasswordObscured = true.obs;
  RxBool confirmPasswordObscured = true.obs;

  ResponseApi? responseApi;

  RxString oldPasswordTxt = ''.obs;
  RxString newPasswordTxt = ''.obs;
  RxString confirmPasswordTxt = ''.obs;
  RxBool errorChangePassword = false.obs;
  RxString errorChangePasswordText = ''.obs;
  RxBool isLoading = false.obs;

  RxBool disableButton = true.obs;

  String jwt = '';

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

  void checkToken() {
    DateTime now = DateTime.now().toLocal();
    if (GetStorage().read('JWT') != null) {
      jwt = GetStorage().read('JWT');
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
      }
    } else {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }
  }

  resetPassword() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoading.value = true;
    if (newPasswordTxt.value.isEmpty && confirmPasswordTxt.value.isEmpty && oldPasswordTxt.value.isEmpty) {
      errorChangePassword.value = true;
      errorChangePasswordText.value = "Vui lòng không để trống";
      isLoading.value = false;
    } else if (newPasswordTxt.value.isEmpty) {
      errorChangePassword.value = true;
      errorChangePasswordText.value = "Vui lòng nhập mật khẩu mới";
      isLoading.value = false;
    } else if (oldPasswordTxt.value.isEmpty) {
      errorChangePassword.value = true;
      errorChangePasswordText.value = "Vui lòng nhập mật khẩu cũ";
      isLoading.value = false;
    } else if (confirmPasswordTxt.value.isEmpty) {
      errorChangePassword.value = true;
      errorChangePasswordText.value = "Vui lòng nhập xác nhận mật khẩu";
      isLoading.value = false;
    } else if (newPasswordTxt.value.length < 6) {
      errorChangePassword.value = true;
      errorChangePasswordText.value = "Vui lòng nhập mật khẩu mới có ít nhất 6 kí tự";
      isLoading.value = false;
    } else if (oldPasswordTxt.value.length < 6) {
      errorChangePassword.value = true;
      errorChangePasswordText.value = "Vui lòng nhập mật khẩu cũ có ít nhất 6 kí tự";
      isLoading.value = false;
    } else if (confirmPasswordTxt.value.length < 6) {
      errorChangePassword.value = true;
      errorChangePasswordText.value = "Vui lòng nhập xác nhận mật khẩu có ít nhất 6 kí tự";
      isLoading.value = false;
    } else if (confirmPasswordTxt.value != newPasswordTxt.value) {
      errorChangePassword.value = true;
      errorChangePasswordText.value = "Xác nhận mật khẩu và mật khẩu khác nhau";
      isLoading.value = false;
    } else {
      try {
        checkToken();
        responseApi = await ChangePasswordApi.changePassword(oldPasswordTxt.value, newPasswordTxt.value, confirmPasswordTxt.value, jwt);
        print('responseApi ${responseApi!.toJson().toString()}');
        if (responseApi!.statusCode == 200 || responseApi!.statusCode == 201) {
          errorChangePassword.value = false;
          // Get.offAllNamed(Routes.RESET_PASSWORD_SUCCESSFULLY);
        } else if (responseApi!.statusCode == 500) {
          errorChangePassword.value = true;
          isLoading.value = false;
          errorChangePasswordText.value = "Nhập mật khẩu cũ bị sai";
        }
        isLoading.value = false;
      } catch (e) {
        log(e.toString());
        errorChangePassword.value = true;
        isLoading.value = false;
        errorChangePasswordText.value = "Có lỗi xảy ra";
      }
    }
  }

  setOldPassword(String value) {
    oldPasswordTxt.value = value;
    if (newPasswordTxt.isEmpty || confirmPasswordTxt.isEmpty || oldPasswordTxt.isEmpty) {
      disableButton.value = true;
    } else {
      disableButton.value = false;
    }
  }

  setNewPassword(String value) {
    newPasswordTxt.value = value;
    if (oldPasswordTxt.isEmpty || confirmPasswordTxt.isEmpty || newPasswordTxt.isEmpty) {
      disableButton.value = true;
    } else {
      if (confirmPasswordTxt.value != newPasswordTxt.value) {
        disableButton.value = true;
      } else {
        disableButton.value = false;
      }
    }
  }

  setConfirmPassword(String value) {
    confirmPasswordTxt.value = value;
    if (oldPasswordTxt.isEmpty || newPasswordTxt.isEmpty || confirmPasswordTxt.isEmpty) {
      disableButton.value = true;
    } else {
      if (confirmPasswordTxt.value != newPasswordTxt.value) {
        disableButton.value = true;
      } else {
        disableButton.value = false;
      }
    }
  }

  void increment() => count.value++;
}
