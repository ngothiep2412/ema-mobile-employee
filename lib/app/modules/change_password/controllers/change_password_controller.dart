import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/change_password/api/change_password_api.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';

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
    if (GetStorage().read('JWT') != null) {
      jwt = GetStorage().read('JWT');
    } else {
      Get.offAllNamed(Routes.LOGIN);
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
  }

  setNewPassword(String value) {
    newPasswordTxt.value = value;
  }

  setConfirmPassword(String value) {
    confirmPasswordTxt.value = value;
  }

  void increment() => count.value++;
}
