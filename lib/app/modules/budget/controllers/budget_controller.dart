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
  BudgetController({required this.taskID, required this.statusTask});

  RxBool isLoading = false.obs;

  DateFormat dateFormat = DateFormat('dd-MM-yyyy HH:mm', 'vi');

  RxBool isModalVisible = false.obs;

  String taskID = '';
  bool statusTask;

  String jwt = '';
  String idUser = '';

  RxBool errorGetBudget = false.obs;
  RxString errorGetBudgetText = ''.obs;

  RxList<BudgetModel> listBudget = <BudgetModel>[].obs;
  RxList<Transaction> listTransaction = <Transaction>[].obs;

  ScrollController scrollController = ScrollController();

  var isMoreDataAvailable = false.obs;
  var page = 1;
  RxBool checkView = false.obs;
  RxBool isFilter = false.obs;

  List<String> timeType = ["Tất cả"];
  RxString selectedTimeTypeVal = 'Tất cả'.obs;

  RxString status = 'Tất cả'.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    await getAllRequestBudget(page);

    await paginateBudget();
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
    Get.toNamed(Routes.CREATE_BUDGET, arguments: {"taskID": taskID});
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
      idUser = decodedToken['id'];
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

  Future<void> refreshPage() async {
    try {
      isMoreDataAvailable.value = false;
      page = 1;
      List<Transaction> list = [];
      if (status.value == 'Tất cả') {
        List<BudgetModel> listBudget = await BudgetApi.getAllBudget(jwt, page, 'DESC', 'ALL', taskID);
        if (listBudget.isNotEmpty) {
          for (var item in listBudget) {
            if (item.taskId == taskID) {
              listTransaction.value = item.transactions!;
              break;
            }
          }
        }
      } else if (status.value != 'Tất cả') {
        String statusRequest = '';
        if (status.value == 'Chờ duyệt') {
          statusRequest = 'PENDING';
        } else if (status.value == 'Chấp nhận') {
          statusRequest = 'ACCEPTED';
        } else if (status.value == 'Từ chối') {
          statusRequest = 'REJECTED';
        } else if (status.value == 'Thành công') {
          statusRequest = 'SUCCESS';
        }
        List<BudgetModel> listBudget = await BudgetApi.getAllBudget(jwt, page, 'DESC', statusRequest, taskID);
        if (listBudget.isNotEmpty) {
          for (var item in listBudget) {
            if (item.taskId == taskID) {
              list = item.transactions!;
              break;
            }
          }
        }
      }

      listTransaction.addAll(list);
      if (selectedTimeTypeVal.value != 'Tất cả') {
        listTransaction.value = listTransaction.where((e) => e.createdAt!.year.toString() == selectedTimeTypeVal.value).toList();
      }
    } catch (e) {
      log(e.toString());
      errorGetBudget.value = true;
      isLoading.value = false;
      errorGetBudgetText.value = "Có lỗi xảy ra";
    }
  }

  Future<void> getAllRequestBudget(var page) async {
    isLoading.value = true;
    isMoreDataAvailable.value = false;
    listBudget.clear();
    listTransaction.clear();
    try {
      checkToken();
      List<BudgetModel> listBudget = await BudgetApi.getAllBudget(jwt, page, 'DESC', 'ALL', taskID);
      if (listBudget.isNotEmpty) {
        for (var item in listBudget) {
          if (item.taskId == taskID) {
            listTransaction.value = item.transactions!;
            break;
          }
        }
      }
      List<DateTime?> createdAtList = listTransaction.map((e) => e.createdAt).toList();

      int smallestYear = createdAtList.fold(DateTime.now().year, (year, date) => date!.year < year ? date.year : year);
      int largestYear = createdAtList.fold(0, (year, date) => date!.year > year ? date.year : year);

      List<String> listYear = ['Tất cả'];

      for (int year = smallestYear; year <= largestYear; year++) {
        listYear.add(year.toString());
      }

      timeType = listYear;

      isLoading.value = false;
    } catch (e) {
      log(e.toString());
      errorGetBudget.value = true;
      isLoading.value = false;
      errorGetBudgetText.value = "Có lỗi xảy ra";
    }
  }

  Future<void> paginateBudget() async {
    scrollController.addListener(() async {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        page++;
        await getMoreBudget(page);
      }
    });
  }

  Future<void> getMoreBudget(var page) async {
    try {
      List<Transaction> list = [];
      if (status.value == 'Tất cả') {
        List<BudgetModel> listBudget = await BudgetApi.getAllBudget(jwt, page, 'DESC', 'ALL', taskID);
        if (listBudget.isNotEmpty) {
          for (var item in listBudget) {
            if (item.taskId == taskID) {
              list = item.transactions!;
              break;
            }
          }
        }
      } else if (status.value != 'Tất cả') {
        String statusRequest = '';
        if (status.value == 'Chờ duyệt') {
          statusRequest = 'PENDING';
        } else if (status.value == 'Chấp nhận') {
          statusRequest = 'ACCEPTED';
        } else if (status.value == 'Từ chối') {
          statusRequest = 'REJECTED';
        } else if (status.value == 'Thành công') {
          statusRequest = 'SUCCESS';
        }
        List<BudgetModel> listBudget = await BudgetApi.getAllBudget(jwt, page, 'DESC', statusRequest, taskID);
        if (listBudget.isNotEmpty) {
          for (var item in listBudget) {
            if (item.taskId == taskID) {
              list = item.transactions!;
              break;
            }
          }
        }
      }

      if (list.isNotEmpty) {
        isMoreDataAvailable(true);
      } else {
        isMoreDataAvailable(false);
      }

      listTransaction.addAll(list);
      if (selectedTimeTypeVal.value != 'Tất cả') {
        listTransaction.value = listTransaction.where((e) => e.createdAt!.year.toString() == selectedTimeTypeVal.value).toList();
      }
      isLoading.value = false;
    } catch (e) {
      isMoreDataAvailable(false);
      print(e);
      ;
    }
  }

  Future<void> clearFilter() async {
    status.value = 'Tất cả';
    selectedTimeTypeVal.value = 'Tất cả';
    List<Transaction> list = [];
    isLoading.value = true;
    page = 1;
    try {
      List<BudgetModel> listBudget = await BudgetApi.getAllBudget(jwt, page, 'DESC', 'ALL', taskID);
      if (listBudget.isNotEmpty) {
        for (var item in listBudget) {
          if (item.taskId == taskID) {
            list = item.transactions!;
            break;
          }
        }
      }
      listTransaction.addAll(list);
      isLoading.value = false;
    } catch (e) {
      log(e.toString());
      errorGetBudget.value = true;
      isLoading.value = false;
      errorGetBudgetText.value = "Có lỗi xảy ra";
    }
  }

  Future<void> setTimeType(String value) async {
    selectedTimeTypeVal.value = value;
    isLoading.value = true;
    isMoreDataAvailable.value = false;
    page = 1;
    listTransaction.clear();
    if (value == 'Tất cả') {
      try {
        checkToken();
        List<Transaction> list = [];
        if (status.value == 'Tất cả') {
          List<BudgetModel> listBudget = await BudgetApi.getAllBudget(jwt, page, 'DESC', 'ALL', taskID);
          if (listBudget.isNotEmpty) {
            for (var item in listBudget) {
              if (item.taskId == taskID) {
                list = item.transactions!;
                break;
              }
            }
          }
        } else if (status.value != 'Tất cả') {
          String statusRequest = '';
          if (value == 'Chờ duyệt') {
            statusRequest = 'PENDING';
          } else if (value == 'Chấp nhận') {
            statusRequest = 'ACCEPTED';
          } else if (value == 'Từ chối') {
            statusRequest = 'REJECTED';
          } else if (value == 'Thành công') {
            statusRequest = 'SUCCESS';
          }
          List<BudgetModel> listBudget = await BudgetApi.getAllBudget(jwt, page, 'DESC', statusRequest, taskID);
          if (listBudget.isNotEmpty) {
            for (var item in listBudget) {
              if (item.taskId == taskID) {
                list = item.transactions!;
                break;
              }
            }
          }
        }

        listTransaction.value = list;

        isLoading.value = false;
      } catch (e) {
        log(e.toString());
        errorGetBudget.value = true;
        isLoading.value = false;
        errorGetBudgetText.value = "Có lỗi xảy ra";
      }
    } else {
      try {
        checkToken();
        List<Transaction> list = [];
        if (status.value == 'Tất cả') {
          List<BudgetModel> listBudget = await BudgetApi.getAllBudget(jwt, page, 'DESC', 'ALL', taskID);
          if (listBudget.isNotEmpty) {
            for (var item in listBudget) {
              if (item.taskId == taskID) {
                list = item.transactions!;
                break;
              }
            }
          }
        } else if (status.value != 'Tất cả') {
          String statusRequest = '';
          if (status.value == 'Chờ duyệt') {
            statusRequest = 'PENDING';
          } else if (status.value == 'Chấp nhận') {
            statusRequest = 'ACCEPTED';
          } else if (status.value == 'Từ chối') {
            statusRequest = 'REJECTED';
          } else if (status.value == 'Thành công') {
            statusRequest = 'SUCCESS';
          }
          List<BudgetModel> listBudget = await BudgetApi.getAllBudget(jwt, page, 'DESC', statusRequest, taskID);
          if (listBudget.isNotEmpty) {
            for (var item in listBudget) {
              if (item.taskId == taskID) {
                list = item.transactions!;
                break;
              }
            }
          }
        }

        listTransaction.value = list;

        listTransaction.value = listTransaction.where((e) => e.createdAt!.year.toString() == value).toList();

        isLoading.value = false;
      } catch (e) {
        log(e.toString());
        errorGetBudget.value = true;
        isLoading.value = false;
        errorGetBudgetText.value = "Có lỗi xảy ra";
      }
    }
  }

  Future<void> changeStatus(String value) async {
    status.value = value;
    isLoading.value = true;
    isMoreDataAvailable.value = false;
    page = 1;
    checkToken();
    listTransaction.clear();
    List<Transaction> list = [];
    try {
      if (value == 'Tất cả') {
        List<BudgetModel> listBudget = await BudgetApi.getAllBudget(jwt, page, 'DESC', 'ALL', taskID);
        if (listBudget.isNotEmpty) {
          for (var item in listBudget) {
            if (item.taskId == taskID) {
              list = item.transactions!;
              break;
            }
          }
        }
      } else {
        String statusTask = '';
        checkToken();
        listTransaction.clear();
        if (value == 'Chờ duyệt') {
          statusTask = 'PENDING';
        } else if (value == 'Chấp nhận') {
          statusTask = 'ACCEPTED';
        } else if (value == 'Từ chối') {
          statusTask = 'REJECTED';
        } else if (value == 'Thành công') {
          statusTask = 'SUCCESS';
        }
        List<BudgetModel> listBudget = await BudgetApi.getAllBudget(jwt, page, 'DESC', statusTask, taskID);
        if (listBudget.isNotEmpty) {
          for (var item in listBudget) {
            if (item.taskId == taskID) {
              list = item.transactions!;
              break;
            }
          }
        }
      }

      listTransaction.value = list;
      if (selectedTimeTypeVal.value != 'Tất cả') {
        listTransaction.value = listTransaction.where((e) => e.createdAt!.year.toString() == selectedTimeTypeVal.value).toList();
      }

      isLoading.value = false;
    } catch (e) {
      log(e.toString());
      errorGetBudget.value = true;
      isLoading.value = false;
      errorGetBudgetText.value = "Có lỗi xảy ra";
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

    return formattedAmount;
  }
}
