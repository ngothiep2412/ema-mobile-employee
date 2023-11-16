import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/budget/controllers/budget_controller.dart';
import 'package:hrea_mobile_employee/app/modules/budget/model/budget_model.dart';
import 'package:hrea_mobile_employee/app/modules/budget_detail/api/budget_detail_api.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class BudgetDetailController extends BaseController {
  BudgetDetailController({required this.eventID, required this.budget});
  String eventID = '';
  BudgetModel budget = BudgetModel();

  Rx<BudgetModel> budgetView = BudgetModel().obs;

  String jwt = '';
  String idUser = '';
  RxBool errorUpdateBudget = false.obs;
  RxString errorUpdateBudgetText = ''.obs;

  RxBool isLoading = false.obs;

  Future<void> getBudgetDetail(String budgetID) async {
    isLoading.value = true;
    try {
      checkToken();
      BudgetModel budgetModel = await BudgetDetailApi.getBudgetDetail(budgetID, jwt);
      budgetView.value = budgetModel;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print(e);
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await getBudgetDetail(budget.id!);
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
    if (GetStorage().read('JWT') != null) {
      jwt = GetStorage().read('JWT');
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
      idUser = decodedToken['id'];
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  Future<void> deleteBudget() async {
    isLoading.value = true;
    try {
      checkToken();
      ResponseApi responseApi = await BudgetDetailApi.deleteBudget(budgetView.value.id!, jwt);
      if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        errorUpdateBudget.value = false;
        await Get.find<BudgetController>().getAllRequestBudget(1);

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
    await getBudgetDetail(budgetView.value.id!);
  }
}
