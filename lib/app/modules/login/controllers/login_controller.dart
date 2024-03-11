import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/login/api/login_api.dart';

import 'package:hrea_mobile_employee/app/modules/tab_view/model/user_model.dart';
import 'package:hrea_mobile_employee/app/resources/login_model.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends BaseController {
  LoginReponseApi? loginReponseApi;
  UserModel? userModel;
  RxBool passwordObscured = true.obs;
  RxString emailTxt = ''.obs;
  RxString passwordTxt = ''.obs;
  RxString errorInputEmail = ''.obs;
  RxBool isLoading = false.obs;
  RxString errorInputPassword = ''.obs;
  RxBool errorLogin = false.obs;
  RxString errorLoginText = ''.obs;

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

  Future<void> login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoading.value = true;

    if (emailTxt.value.isEmpty && passwordTxt.value.isEmpty) {
      errorLogin.value = true;
      isLoading.value = false;
      errorLoginText.value = "Vui lòng nhập email và mật khẩu";
    } else if (passwordTxt.value.isEmpty) {
      errorLogin.value = true;
      isLoading.value = false;
      errorLoginText.value = "Vui lòng nhập mật khẩu";
    } else if (emailTxt.value.isEmpty) {
      errorLogin.value = true;
      isLoading.value = false;
      errorLoginText.value = "Vui lòng nhập email";
    } else if (!emailTxt.value.contains('@')) {
      errorLogin.value = true;
      isLoading.value = false;
      errorLoginText.value = "Vui lòng nhập đúng định dạng email";
    } else {
      try {
        loginReponseApi = await LoginApi.login(emailTxt.value, passwordTxt.value);
        if (loginReponseApi!.statusCode == 400 || loginReponseApi!.statusCode == 500) {
          errorLogin.value = true;
          errorLoginText.value = "Sai email hoặc mật khẩu";
        }
        if (loginReponseApi!.accessToken != null) {
          Map<String, dynamic> decodedToken = JwtDecoder.decode(loginReponseApi!.accessToken!);
          if (decodedToken["role"] == "Nhân Viên" && loginReponseApi != null) {
            prefs.setString('JWT', loginReponseApi!.accessToken!);
            GetStorage().write('JWT', loginReponseApi!.accessToken!);
            print('JWT: ${loginReponseApi!.accessToken!}');
            // await FirebaseMessaging.instance.requestPermission();
            final token = await FirebaseMessaging.instance.getToken();
            print('token Firebase: $token');
            if (token != null || token != '') {
              ResponseApi storeDeviceReponseApi = await LoginApi.storeDeviceToken(token!, loginReponseApi!.accessToken!);
              if (storeDeviceReponseApi.statusCode == 200 || storeDeviceReponseApi.statusCode == 201) {
                errorLogin.value = false;
                // await Get.find<TabNotificationController>().uploadNoti();
                Get.offAllNamed(Routes.TAB_VIEW);
              }
            }
            // if (userModel != null) {
            // String userJson = jsonEncode(userModel);
            // GetStorage().write('user', userJson);
            // var user = GetStorage().read('user');
            // print('user ${user}');

            // }
          } else {
            errorLogin.value = true;
            errorLoginText.value = "Tài khoản này không có quyền truy cập";
          }
        }
        isLoading.value = false;
      } catch (e) {
        log(e.toString());
        errorLogin.value = true;
        isLoading.value = false;
        errorLoginText.value = "Có lỗi xảy ra";
      }
    }
  }

  forgotPassword() {
    Get.toNamed(Routes.FORGOT_PASSWORD);
  }

  setEmail(String value) {
    emailTxt.value = value;
    validatorEmail();
  }

  setPassword(String value) {
    passwordTxt.value = value;
    validatorPassword();
  }

  validatorEmail() {
    if (emailTxt.value.isEmpty) {
      errorInputEmail("Email không được để trống".tr);
    } else if (!emailTxt.value.contains('@')) {
      errorInputEmail("Email không hợp lệ".tr);
    } else {
      errorInputEmail("");
    }
    log(errorInputEmail.value);
  }

  validatorPassword() {
    if (passwordTxt.value.isEmpty) {
      errorInputPassword("Mật khẩu không được để trống".tr);
    } else if (passwordTxt.value.length < 6) {
      errorInputPassword("Mật khẩu phải có ít nhất 6 kí tự".tr);
    } else {
      errorInputPassword("");
    }
    log(errorInputPassword.value);
  }

  void increment() => count.value++;
}
