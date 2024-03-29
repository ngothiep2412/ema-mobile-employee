import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/api/tab_request_api/tab_request_api.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/request.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TabRequestController extends BaseController {
  RxBool isLoading = false.obs;

  DateTime createdAt = DateTime(2023, 10, 17, 14, 30);

  RxBool isModalVisible = false.obs;
  RxBool isFilter = false.obs;

  String eventID = '';

  String jwt = '';
  String idUser = '';
  DateFormat dateFormat = DateFormat('dd/MM/yyyy', 'vi');

  RxBool errorGetBudget = false.obs;
  RxString errorGetBudgetText = ''.obs;

  RxList<RequestModel> listRequest = <RequestModel>[].obs;

  final now = DateTime.now();
  final vietnameseDateFormat = DateFormat('EEEE, dd MMMM yyyy', 'vi_VN');

  ScrollController scrollController = ScrollController();
  var isMoreDataAvailable = false.obs;
  var page = 1;
  var isDataProcessing = false.obs;

  List<String> timeType = ["Tất cả"];
  RxString selectedTimeTypeVal = 'Tất cả'.obs;

  RxString status = 'Tất cả'.obs;
  RxString leaveStatus = 'Tất cả'.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    await getAllLeaveRequest(page);

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

  Future<void> setTimeType(String value) async {
    selectedTimeTypeVal.value = value;
    isLoading.value = true;
    isMoreDataAvailable.value = false;
    page = 1;
    if (value == 'Tất cả') {
      try {
        checkToken();
        listRequest.clear();
        List<RequestModel> list = [];
        if (leaveStatus.value == 'Tất cả' && status.value == 'Tất cả') {
          list = await TabRequestApi.getAllLeaveRequest(jwt, idUser, page);
        } else if (leaveStatus.value == 'Tất cả' && status.value != 'Tất cả') {
          String statusRequest = '';
          if (status.value == 'Đang xử lí') {
            statusRequest = 'PENDING';
          } else if (status.value == 'Đồng ý') {
            statusRequest = 'ACCEPT';
          } else if (status.value == 'Từ chối') {
            statusRequest = 'REJECT';
          }
          list = await TabRequestApi.getLeaveRequestByStatus(jwt, idUser, page, statusRequest);
        } else if (leaveStatus.value != 'Tất cả' && status.value == 'Tất cả') {
          String typeRequest = '';
          if (leaveStatus.value == 'Nghỉ có lương') {
            typeRequest = 'A';
          } else if (leaveStatus.value == 'Nghỉ không lương') {
            typeRequest = 'L';
          } else if (leaveStatus.value == 'Đi công tác') {
            typeRequest = 'M';
          }
          list = await TabRequestApi.getLeaveRequestByType(jwt, idUser, page, typeRequest);
        } else if (leaveStatus.value != 'Tất cả' && status.value != 'Tất cả') {
          String statusRequest = '';
          if (status.value == 'Đang xử lí') {
            statusRequest = 'PENDING';
          } else if (status.value == 'Đồng ý') {
            statusRequest = 'ACCEPT';
          } else if (status.value == 'Từ chối') {
            statusRequest = 'REJECT';
          }
          String typeRequest = '';
          if (leaveStatus.value == 'Nghỉ có lương') {
            typeRequest = 'A';
          } else if (leaveStatus.value == 'Nghỉ không lương') {
            typeRequest = 'L';
          } else if (leaveStatus.value == 'Đi công tác') {
            typeRequest = 'M';
          }

          list = await TabRequestApi.getLeaveRequestByStatusAndType(jwt, idUser, page, statusRequest, typeRequest);
        }

        list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

        listRequest.value = list;

        listRequest.value = listRequest.where((e) => e.status != "CANCEL").toList();

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
        listRequest.clear();
        List<RequestModel> list = [];
        if (leaveStatus.value == 'Tất cả' && status.value == 'Tất cả') {
          list = await TabRequestApi.getAllLeaveRequest(jwt, idUser, page);
        } else if (leaveStatus.value == 'Tất cả' && status.value != 'Tất cả') {
          String statusRequest = '';
          if (status.value == 'Đang xử lí') {
            statusRequest = 'PENDING';
          } else if (status.value == 'Đồng ý') {
            statusRequest = 'ACCEPT';
          } else if (status.value == 'Từ chối') {
            statusRequest = 'REJECT';
          }
          list = await TabRequestApi.getLeaveRequestByStatus(jwt, idUser, page, statusRequest);
        } else if (leaveStatus.value != 'Tất cả' && status.value == 'Tất cả') {
          String typeRequest = '';
          if (leaveStatus.value == 'Nghỉ có lương') {
            typeRequest = 'A';
          } else if (leaveStatus.value == 'Nghỉ không lương') {
            typeRequest = 'L';
          } else if (leaveStatus.value == 'Đi công tác') {
            typeRequest = 'M';
          }
          list = await TabRequestApi.getLeaveRequestByType(jwt, idUser, page, typeRequest);
        } else if (leaveStatus.value != 'Tất cả' && status.value != 'Tất cả') {
          String statusRequest = '';
          if (status.value == 'Đang xử lí') {
            statusRequest = 'PENDING';
          } else if (status.value == 'Đồng ý') {
            statusRequest = 'ACCEPT';
          } else if (status.value == 'Từ chối') {
            statusRequest = 'REJECT';
          }
          String typeRequest = '';
          if (leaveStatus.value == 'Nghỉ có lương') {
            typeRequest = 'A';
          } else if (leaveStatus.value == 'Nghỉ không lương') {
            typeRequest = 'L';
          } else if (leaveStatus.value == 'Đi công tác') {
            typeRequest = 'M';
          }

          list = await TabRequestApi.getLeaveRequestByStatusAndType(jwt, idUser, page, statusRequest, typeRequest);
        }

        list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

        listRequest.value = list;

        listRequest.value = listRequest.where((e) => e.status != "CANCEL" && e.createdAt!.year.toString() == value).toList();

        isLoading.value = false;
      } catch (e) {
        log(e.toString());
        errorGetBudget.value = true;
        isLoading.value = false;
        errorGetBudgetText.value = "Có lỗi xảy ra";
      }
    }
  }

  void createBudget() {
    Get.toNamed(Routes.CREATE_REQUEST);
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
    isMoreDataAvailable.value = false;
    page = 1;
    List<RequestModel> list = [];
    if (leaveStatus.value == 'Tất cả' && status.value == 'Tất cả') {
      list = await TabRequestApi.getAllLeaveRequest(jwt, idUser, page);
    } else if (leaveStatus.value == 'Tất cả' && status.value != 'Tất cả') {
      String statusRequest = '';
      if (status.value == 'Đang xử lí') {
        statusRequest = 'PENDING';
      } else if (status.value == 'Đồng ý') {
        statusRequest = 'ACCEPT';
      } else if (status.value == 'Từ chối') {
        statusRequest = 'REJECT';
      }
      list = await TabRequestApi.getLeaveRequestByStatus(jwt, idUser, page, statusRequest);
    } else if (leaveStatus.value != 'Tất cả' && status.value == 'Tất cả') {
      String typeRequest = '';
      if (leaveStatus.value == 'Nghỉ có lương') {
        typeRequest = 'A';
      } else if (leaveStatus.value == 'Nghỉ không lương') {
        typeRequest = 'L';
      } else if (leaveStatus.value == 'Đi công tác') {
        typeRequest = 'M';
      }
      list = await TabRequestApi.getLeaveRequestByType(jwt, idUser, page, typeRequest);
    } else if (leaveStatus.value != 'Tất cả' && status.value != 'Tất cả') {
      String statusRequest = '';
      if (status.value == 'Đang xử lí') {
        statusRequest = 'PENDING';
      } else if (status.value == 'Đồng ý') {
        statusRequest = 'ACCEPT';
      } else if (status.value == 'Từ chối') {
        statusRequest = 'REJECT';
      }
      String typeRequest = '';
      if (leaveStatus.value == 'Nghỉ có lương') {
        typeRequest = 'A';
      } else if (leaveStatus.value == 'Nghỉ không lương') {
        typeRequest = 'L';
      } else if (leaveStatus.value == 'Đi công tác') {
        typeRequest = 'M';
      }

      list = await TabRequestApi.getLeaveRequestByStatusAndType(jwt, idUser, page, statusRequest, typeRequest);
    }
    // if (list.isNotEmpty) {
    //   isMoreDataAvailable(true);
    // } else {
    //   isMoreDataAvailable(false);
    // }
    listRequest.clear();
    list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    listRequest.addAll(list);
    if (selectedTimeTypeVal.value == 'Tất cả') {
      listRequest.value = listRequest.where((e) => e.status != "CANCEL").toList();
    } else {
      listRequest.value = listRequest.where((e) => e.status != "CANCEL" && e.createdAt!.year.toString() == selectedTimeTypeVal.value).toList();
    }
  }

  Future<void> getAllLeaveRequest(var page) async {
    isLoading.value = true;
    isMoreDataAvailable.value = false;
    try {
      checkToken();
      listRequest.clear();
      List<RequestModel> list = await TabRequestApi.getAllLeaveRequest(jwt, idUser, page);

      list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

      listRequest.value = list;

      listRequest.value = listRequest.where((e) => e.status != "CANCEL").toList();

      List<DateTime?> createdAtList = listRequest.map((e) => e.createdAt).toList();

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
      List<RequestModel> list = [];
      if (leaveStatus.value == 'Tất cả' && status.value == 'Tất cả') {
        list = await TabRequestApi.getAllLeaveRequest(jwt, idUser, page);
      } else if (leaveStatus.value == 'Tất cả' && status.value != 'Tất cả') {
        String statusRequest = '';
        if (status.value == 'Đang xử lí') {
          statusRequest = 'PENDING';
        } else if (status.value == 'Đồng ý') {
          statusRequest = 'ACCEPT';
        } else if (status.value == 'Từ chối') {
          statusRequest = 'REJECT';
        }
        list = await TabRequestApi.getLeaveRequestByStatus(jwt, idUser, page, statusRequest);
      } else if (leaveStatus.value != 'Tất cả' && status.value == 'Tất cả') {
        String typeRequest = '';
        if (leaveStatus.value == 'Nghỉ có lương') {
          typeRequest = 'A';
        } else if (leaveStatus.value == 'Nghỉ không lương') {
          typeRequest = 'L';
        } else if (leaveStatus.value == 'Đi công tác') {
          typeRequest = 'M';
        }
        list = await TabRequestApi.getLeaveRequestByType(jwt, idUser, page, typeRequest);
      } else if (leaveStatus.value != 'Tất cả' && status.value != 'Tất cả') {
        String statusRequest = '';
        if (status.value == 'Đang xử lí') {
          statusRequest = 'PENDING';
        } else if (status.value == 'Đồng ý') {
          statusRequest = 'ACCEPT';
        } else if (status.value == 'Từ chối') {
          statusRequest = 'REJECT';
        }
        String typeRequest = '';
        if (leaveStatus.value == 'Nghỉ có lương') {
          typeRequest = 'A';
        } else if (leaveStatus.value == 'Nghỉ không lương') {
          typeRequest = 'L';
        } else if (leaveStatus.value == 'Đi công tác') {
          typeRequest = 'M';
        }

        list = await TabRequestApi.getLeaveRequestByStatusAndType(jwt, idUser, page, statusRequest, typeRequest);
      }

      if (list.isNotEmpty) {
        isMoreDataAvailable(true);
      } else {
        isMoreDataAvailable(false);
      }
      list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      listRequest.addAll(list);
      if (selectedTimeTypeVal.value == 'Tất cả') {
        listRequest.value = listRequest.where((e) => e.status != "CANCEL").toList();
      } else {
        listRequest.value = listRequest.where((e) => e.status != "CANCEL" && e.createdAt!.year.toString() == selectedTimeTypeVal.value).toList();
      }
      isLoading.value = false;
    } catch (e) {
      isMoreDataAvailable(false);
      print(e);
      ;
    }
  }

  Future<void> changeStatus(String value) async {
    status.value = value;
    isLoading.value = true;
    isMoreDataAvailable.value = false;
    page = 1;
    checkToken();
    listRequest.clear();
    List<RequestModel> list = [];
    try {
      if (leaveStatus.value == 'Tất cả') {
        if (value == 'Tất cả') {
          list = await TabRequestApi.getAllLeaveRequest(jwt, idUser, page);
        } else {
          String status = '';
          checkToken();
          listRequest.clear();
          if (value == 'Đang xử lí') {
            status = 'PENDING';
          } else if (value == 'Đồng ý') {
            status = 'ACCEPT';
          } else if (value == 'Từ chối') {
            status = 'REJECT';
          }
          list = await TabRequestApi.getLeaveRequestByStatus(jwt, idUser, page, status);
        }
      } else {
        String type = '';
        if (leaveStatus.value == 'Nghỉ có lương') {
          type = 'A';
        } else if (leaveStatus.value == 'Nghỉ không lương') {
          type = 'L';
        } else if (leaveStatus.value == 'Đi công tác') {
          type = 'M';
        }
        if (value == 'Tất cả') {
          list = await TabRequestApi.getLeaveRequestByType(jwt, idUser, page, type);
        } else {
          String status = '';
          checkToken();
          listRequest.clear();
          if (value == 'Đang xử lí') {
            status = 'PENDING';
          } else if (value == 'Đồng ý') {
            status = 'ACCEPT';
          } else if (value == 'Từ chối') {
            status = 'REJECT';
          }
          list = await TabRequestApi.getLeaveRequestByStatusAndType(jwt, idUser, page, status, type);
        }
      }
      list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      listRequest.value = list;
      if (selectedTimeTypeVal.value == 'Tất cả') {
        listRequest.value = listRequest.where((e) => e.status != "CANCEL").toList();
      } else {
        listRequest.value = listRequest.where((e) => e.status != "CANCEL" && e.createdAt!.year.toString() == selectedTimeTypeVal.value).toList();
      }

      isLoading.value = false;
    } catch (e) {
      log(e.toString());
      errorGetBudget.value = true;
      isLoading.value = false;
      errorGetBudgetText.value = "Có lỗi xảy ra";
    }
  }

  Future<void> changeLeaveStatus(String value) async {
    leaveStatus.value = value;
    isLoading.value = true;
    isMoreDataAvailable.value = false;
    page = 1;
    checkToken();
    listRequest.clear();
    List<RequestModel> list = [];
    try {
      if (status.value == 'Tất cả') {
        if (value == 'Tất cả') {
          list = await TabRequestApi.getAllLeaveRequest(jwt, idUser, page);
        } else {
          String type = '';
          checkToken();
          listRequest.clear();
          if (value == 'Nghỉ có lương') {
            type = 'A';
          } else if (value == 'Nghỉ không lương') {
            type = 'L';
          } else if (value == 'Đi công tác') {
            type = 'M';
          }
          list = await TabRequestApi.getLeaveRequestByType(jwt, idUser, page, type);
        }
      } else {
        String leaveStatus = '';
        if (status.value == 'Đang xử lí') {
          leaveStatus = 'PENDING';
        } else if (status.value == 'Đồng ý') {
          leaveStatus = 'ACCEPT';
        } else if (status.value == 'Từ chối') {
          leaveStatus = 'REJECT';
        }
        if (value == 'Tất cả') {
          list = await TabRequestApi.getLeaveRequestByStatus(jwt, idUser, page, leaveStatus);
        } else {
          String type = '';
          checkToken();
          listRequest.clear();
          if (value == 'Nghỉ có lương') {
            type = 'A';
          } else if (value == 'Nghỉ không lương') {
            type = 'L';
          } else if (value == 'Đi công tác') {
            type = 'M';
          }

          list = await TabRequestApi.getLeaveRequestByStatusAndType(jwt, idUser, page, leaveStatus, type);
        }
      }
      list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      listRequest.value = list;
      if (selectedTimeTypeVal.value == 'Tất cả') {
        listRequest.value = listRequest.where((e) => e.status != "CANCEL").toList();
      } else {
        listRequest.value = listRequest.where((e) => e.status != "CANCEL" && e.createdAt!.year.toString() == selectedTimeTypeVal.value).toList();
      }

      isLoading.value = false;
    } catch (e) {
      log(e.toString());
      errorGetBudget.value = true;
      isLoading.value = false;
      errorGetBudgetText.value = "Có lỗi xảy ra";
    }
  }

  Future<void> clearFilter() async {
    leaveStatus.value = 'Tất cả';
    status.value = 'Tất cả';
    selectedTimeTypeVal.value = 'Tất cả';
    List<RequestModel> list = [];
    isLoading.value = true;
    page = 1;
    try {
      list = await TabRequestApi.getAllLeaveRequest(jwt, idUser, page);
      list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      listRequest.value = list;
      listRequest.value = listRequest.where((e) => e.status != "CANCEL").toList();
      isLoading.value = false;
    } catch (e) {
      log(e.toString());
      errorGetBudget.value = true;
      isLoading.value = false;
      errorGetBudgetText.value = "Có lỗi xảy ra";
    }
  }
}
