import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';

import '../controllers/event_detail_controller.dart';

class EventDetailBinding extends BaseBindings {
  String eventID = '';
  @override
  void injectService() {
    eventID = Get.arguments["eventID"] as String;
    Get.lazyPut<EventDetailController>(
      () => EventDetailController(eventID: eventID),
    );
  }
}
