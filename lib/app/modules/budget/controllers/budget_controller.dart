import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/budget/api/budget_api.dart';
import 'package:hrea_mobile_employee/app/modules/budget/model/budget_model.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class BudgetController extends BaseController {
  BudgetController({required this.eventID});

  RxBool isLoading = false.obs;

  DateTime createdAt = DateTime(2023, 10, 17, 14, 30);

  DateFormat dateFormat = DateFormat('dd/MM/yyyy', 'vi');

  RxBool isModalVisible = false.obs;

  String eventID = '';

  String jwt = '';
  String idUser = '';

  RxBool errorGetBudget = false.obs;
  RxString errorGetBudgetText = ''.obs;

  RxList<BudgetModel> listBudget = <BudgetModel>[].obs;

  ScrollController scrollController = ScrollController();
  var isMoreDataAvailable = false.obs;
  var page = 1;
  var isDataProcessing = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    await getAllRequestBudget(page);

    paginateBudget();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
  }

  void createBudget() {
    Get.toNamed(Routes.CREATE_BUDGET, arguments: {"eventID": eventID});
  }

  void checkToken() {
    if (GetStorage().read('JWT') != null) {
      jwt = GetStorage().read('JWT');
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
      idUser = decodedToken['id'];
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  Future<void> refreshPage() async {
    // listBudget.clear();
    page = 1;
    await getAllRequestBudget(page);
  }

  Future<void> getAllRequestBudget(var page) async {
    isLoading.value = true;
    isMoreDataAvailable.value = false;
    try {
      checkToken();
      listBudget.clear();
      List<BudgetModel> listProcessing = await BudgetApi.getAllBudget(jwt, eventID, page, idUser, 1);
      List<BudgetModel> listNotProcessing = await BudgetApi.getAllBudget(jwt, eventID, page, idUser, 2);
      List<BudgetModel> listTotal = [];
      if (listProcessing.isNotEmpty) {
        listTotal = listProcessing;
      }
      if (listNotProcessing.isNotEmpty) {
        for (var item in listNotProcessing) {
          listTotal.add(item);
        }
      }
      listTotal.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

      listBudget.value = listTotal;

      listBudget.value = listBudget.where((e) => e.status != "CANCEL").toList();

      // if (list.isNotEmpty) {
      //   for (var item in list) {
      //     if (item.status != "CANCEL" && item.createBy == idUser) {
      //       listBudget.add(item);
      //     }
      //   }
      // }

      isLoading.value = false;
    } catch (e) {
      log(e.toString());
      errorGetBudget.value = true;
      isLoading.value = false;
      errorGetBudgetText.value = "Có lỗi xảy ra";
    }
  }

  void paginateBudget() {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        print('reached end');
        page++;
        getMoreBudget(page);
      }
    });
  }

  void getMoreBudget(var page) async {
    try {
      List<BudgetModel> listProcessing = await BudgetApi.getAllBudget(jwt, eventID, page, idUser, 1);
      List<BudgetModel> listNotProcessing = await BudgetApi.getAllBudget(jwt, eventID, page, idUser, 2);
      List<BudgetModel> listTotal = [];
      if (listProcessing.isNotEmpty) {
        listTotal = listProcessing;
      }
      if (listNotProcessing.isNotEmpty) {
        for (var item in listNotProcessing) {
          listTotal.add(item);
        }
      }
      if (listTotal.isNotEmpty) {
        isMoreDataAvailable(true);
      } else {
        isMoreDataAvailable(false);
      }
      listTotal.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

      listBudget.addAll(listTotal);
      listBudget.value = listBudget.where((e) => e.status != "CANCEL").toList();
    } catch (e) {
      isMoreDataAvailable(false);
      print(e);
      ;
    }
  }
}
