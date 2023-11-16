import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/forgot_password/api/forgot_password_api.dart';
import 'package:hrea_mobile_employee/app/modules/otp/api/otp_api.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';

class OtpController extends BaseController {
  RxString otpTxt = ''.obs;
  ResponseApi? responseApi;
  RxBool errorVerifyCode = false.obs;
  RxString errorVerifyCodeText = ''.obs;
  RxBool isLoading = false.obs;

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

  verifyCode() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoading.value = true;

    if (otpTxt.value.isEmpty) {
      errorVerifyCode.value = true;
      isLoading.value = false;
      errorVerifyCodeText.value = "Vui lòng nhập Code";
    } else if (otpTxt.value.length != 4) {
      errorVerifyCode.value = true;
      isLoading.value = false;
      errorVerifyCodeText.value = "Vui lòng nhập đủ 4 số";
    } else {
      try {
        String emailTxt = GetStorage().read('Email');
        // String emailTxt = "ngothiep2412@gmail.com";
        responseApi = await VerifyCodeApi.verifyCode(emailTxt, otpTxt.value);
        if (responseApi!.statusCode == 400 || responseApi!.statusCode == 500) {
          errorVerifyCode.value = true;
          errorVerifyCodeText.value = "Mã code không hợp lệ";
        } else if (responseApi!.statusCode == 200 || responseApi!.statusCode == 201) {
          errorVerifyCode.value = false;
          Get.toNamed(Routes.RESET_PASSWORD);
        }
        isLoading.value = false;
      } catch (e) {
        log(e.toString());
        errorVerifyCode.value = true;
        isLoading.value = false;
        errorVerifyCodeText.value = "Có lỗi xảy ra";
      }
    }
  }

  sendOtp() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      // String emailTxt = prefs.getString('Email')!;
      String emailTxt = GetStorage().read('Email');
      // String emailTxt = "ngothiep2412@gmail.com";
      responseApi = await ForgotPasswordApi.sendOtp(emailTxt);
      print('responseApi ${responseApi!.toJson().toString()}');
      if (responseApi!.statusCode == 200 || responseApi!.statusCode == 201) {
        errorVerifyCode.value = false;
      }
    } catch (e) {
      log(e.toString());
      errorVerifyCode.value = true;
      errorVerifyCodeText.value = "Có lỗi xảy ra";
    }
  }

  setOtp(String value) {
    otpTxt.value = value;
  }

  void increment() => count.value++;
}
