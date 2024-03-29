import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/reset_password/api/reset_password.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';

class ResetPasswordController extends BaseController {
  RxBool passwordObscured = true.obs;
  RxBool confirmPasswordObscured = true.obs;

  ResponseApi? responseApi;

  RxString passwordTxt = ''.obs;
  RxString confirmPasswordTxt = ''.obs;
  RxBool errorResetPassword = false.obs;
  RxString errorResetPasswordText = ''.obs;
  RxBool isLoading = false.obs;

  RxBool disableButton = true.obs;

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

  resetPassword() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoading.value = true;
    if (passwordTxt.value.isEmpty && confirmPasswordTxt.value.isEmpty) {
      errorResetPassword.value = true;
      errorResetPasswordText.value = "Vui lòng nhập mật khẩu và xác nhận mật khẩu";
      isLoading.value = false;
    } else if (passwordTxt.value.isEmpty) {
      errorResetPassword.value = true;
      errorResetPasswordText.value = "Vui lòng nhập mật khẩu";
      isLoading.value = false;
    } else if (confirmPasswordTxt.value.isEmpty) {
      errorResetPassword.value = true;
      errorResetPasswordText.value = "Vui lòng nhập xác nhận mật khẩu";
      isLoading.value = false;
    } else if (passwordTxt.value.length < 6) {
      errorResetPassword.value = true;
      errorResetPasswordText.value = "Vui lòng nhập mật khẩu có ít nhất 6 kí tự";
      isLoading.value = false;
    } else if (confirmPasswordTxt.value.length < 6) {
      errorResetPassword.value = true;
      errorResetPasswordText.value = "Vui lòng nhập xác nhận mật khẩu có ít nhất 6 kí tự";
      isLoading.value = false;
    } else if (confirmPasswordTxt.value != passwordTxt.value) {
      errorResetPassword.value = true;
      errorResetPasswordText.value = "Xác nhận mật khẩu và mật khẩu khác nhau";
      isLoading.value = false;
    } else {
      try {
        // String emailTxt = prefs.getString('Email')!;
        String emailTxt = GetStorage().read('Email');
        // String emailTxt = "ngothiep2412@gmail.com";
        responseApi = await ResetPasswordApi.resetPassword(emailTxt, passwordTxt.value);
        print('responseApi ${responseApi!.toJson().toString()}');
        if (responseApi!.statusCode == 200 || responseApi!.statusCode == 201) {
          errorResetPassword.value = false;
          Get.offAllNamed(Routes.RESET_PASSWORD_SUCCESSFULLY);
        }
        isLoading.value = false;
      } catch (e) {
        log(e.toString());
        errorResetPassword.value = true;
        isLoading.value = false;
        errorResetPasswordText.value = "Có lỗi xảy ra";
      }
    }
  }

  setPassword(String value) {
    passwordTxt.value = value;

    if (passwordTxt.isEmpty || confirmPasswordTxt.isEmpty) {
      disableButton.value = true;
    } else {
      if (confirmPasswordTxt.value != passwordTxt.value) {
        disableButton.value = true;
      } else {
        disableButton.value = false;
      }
    }
  }

  setConfirmPassword(String value) {
    confirmPasswordTxt.value = value;
    if (passwordTxt.isEmpty || confirmPasswordTxt.isEmpty) {
      disableButton.value = true;
    } else {
      if (confirmPasswordTxt.value != passwordTxt.value) {
        disableButton.value = true;
      } else {
        disableButton.value = false;
      }
    }
  }

  void increment() => count.value++;
}
