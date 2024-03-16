import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/event_detail/api/event_detail_api.dart';
import 'package:hrea_mobile_employee/app/modules/event_detail/model/event_detail_model.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:intl/intl.dart';

class EventDetailController extends BaseController {
  EventDetailController({required this.eventID});
  String eventID = '';
  RxBool isLoading = false.obs;

  Rx<EventDetailModel> eventDetail = EventDetailModel().obs;
  Rx<QuillController> quillController = QuillController.basic().obs;
  DateFormat dateFormat = DateFormat('dd/MM/yyyy', 'vi');
  String jwt = '';

  RxBool checkInView = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getEventDetail();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    quillController.value.dispose();
  }

  void checkToken() {
    if (GetStorage().read('JWT') != null) {
      jwt = GetStorage().read('JWT');
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  Future<void> getEventDetail() async {
    isLoading.value = true;
    try {
      checkToken();

      eventDetail.value = await EventDetailApi.getEventDetail(jwt, eventID);
      if (eventDetail.value.description!.isNotEmpty || eventDetail.value.description != null) {
        quillController.value = QuillController(
          document: Document.fromJson(jsonDecode(eventDetail.value.description!)),
          selection: const TextSelection.collapsed(offset: 0),
        );
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      checkInView.value = false;
      print(e);
    }
  }

  String formatCurrency(int amount) {
    String formattedAmount = amount.toString();
    final length = formattedAmount.length;

    if (length > 3) {
      for (var i = length - 3; i > 0; i -= 3) {
        formattedAmount = formattedAmount.replaceRange(i, i, ',');
      }
    }

    return '$formattedAmount VNĐ';
  }
}
