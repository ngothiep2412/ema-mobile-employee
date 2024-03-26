import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';

import '../controllers/statistics_controller.dart';

class StatisticsBinding extends BaseBindings {
  @override
  void injectService() {
    Get.lazyPut<StatisticsController>(
      () => StatisticsController(),
    );
  }
}
