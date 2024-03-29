import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/request_detail/api/request_detail_api.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/controllers/tab_request_controller/tab_request_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/request.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class RequestDetailController extends BaseController {
  RequestDetailController({required this.requestID});
  Rx<RequestModel> requestModelView = RequestModel().obs;
  DateFormat dateFormat = DateFormat('dd/MM/yyyy', 'vi');
  String requestID = '';
  String jwt = '';
  String idUser = '';
  RxBool errorUpdateBudget = false.obs;
  RxString errorUpdateBudgetText = ''.obs;

  RxBool isLoading = false.obs;

  Future<void> getLeaveRequestDetail(String requestID) async {
    isLoading.value = true;
    try {
      checkToken();
      RequestModel requestModel = await LeaveRequestDetailApi.getLeaveRequestDetail(requestID, jwt);
      requestModelView.value = requestModel;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print(e);
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await getLeaveRequestDetail(requestID);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
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

  Future<void> deleteLeaveRequest() async {
    isLoading.value = true;
    try {
      checkToken();
      ResponseApi responseApi = await LeaveRequestDetailApi.deleteRequest(requestModelView.value.id!, jwt);
      if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        errorUpdateBudget.value = false;
        await Get.find<TabRequestController>().refreshPage();
        Get.back();
      } else {
        errorUpdateBudget.value = true;
        errorUpdateBudgetText.value = 'Có lỗi xảy ra';
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorUpdateBudget.value = true;
      errorUpdateBudgetText.value = 'Có lỗi xảy ra';
      print(e);
    }
  }

  Future<void> refreshPage() async {
    await getLeaveRequestDetail(requestModelView.value.id!);
  }
}
