import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/controllers/tab_home_controller/tab_home_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/controllers/tab_notification_controller/tab_notification_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/controllers/tab_request_controller/tab_request_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/controllers/tab_setting_controller/tab_setting_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/controllers/tab_timekeeping_controller/tab_timekeeping_controller.dart';

import '../controllers/tab_view_controller.dart';

class TabViewBinding extends BaseBindings {
  @override
  void injectService() {
    Get.lazyPut<TabViewController>(
      () => TabViewController(),
    );

    Get.lazyPut<TabHomeController>(
      () => TabHomeController(),
    );
    Get.lazyPut<TabTimeKeepingController>(
      () => TabTimeKeepingController(),
    );
    Get.lazyPut<TabRequestController>(
      () => TabRequestController(),
    );
    Get.lazyPut<TabNotificationController>(
      () => TabNotificationController(),
    );
    Get.lazyPut<TabSettingController>(
      () => TabSettingController(),
    );
  }
}
