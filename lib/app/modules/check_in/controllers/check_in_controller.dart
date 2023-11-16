import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/modules/check_in/api/check_in_api.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CheckInController extends GetxController {
  String jwt = '';
  String idUser = '';

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

  void increment() => count.value++;

  void checkToken() {
    if (GetStorage().read('JWT') != null) {
      jwt = GetStorage().read('JWT');
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
      idUser = decodedToken['id'];
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  Future<void> checkIn(Barcode barcode) async {
    checkToken();
    try {
      List<String> parts = barcode.code!.split('/');
      String eventID = parts.last;
      ResponseApi response = await CheckInApi.checkIn(eventID, jwt);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: 'Check in thành công',
          fontSize: 14,
          gravity: ToastGravity.TOP,
          backgroundColor: ColorsManager.primary,
        );
        Get.back();
      } else {
        Fluttertoast.showToast(
          msg: 'Check in thất bại',
          fontSize: 14,
          gravity: ToastGravity.TOP,
          backgroundColor: ColorsManager.red,
        );
      }
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(
        msg: 'Check in thất bại',
        fontSize: 14,
        gravity: ToastGravity.TOP,
        backgroundColor: ColorsManager.red,
      );
    }
  }
}
