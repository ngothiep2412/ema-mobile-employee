import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/user_model.dart';

import '../controllers/profile_controller.dart';

class ProfileBinding extends BaseBindings {
  UserModel? userModel;
  @override
  void injectService() {
    userModel = Get.arguments["userModel"] as UserModel;
    Get.put(
      ProfileController(userModel: userModel),
    );
  }
}
