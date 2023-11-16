import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/api/tab_setting_api/tab_setting_api.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/user_model.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';

class TabSettingController extends BaseController {
  Rx<ResponseApi> locationNotFreeList = ResponseApi().obs;
  Rx<UserModel> userModel = UserModel().obs;

  RxBool isLoading = false.obs;

  Future<void> getProfile() async {
    String jwt = GetStorage().read('JWT');
    print('JWT 123: $jwt');
    isLoading.value = true;
    userModel.value = await TabSettingApi.getProfile(jwt);
    isLoading.value = false;
  }

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
}
