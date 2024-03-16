import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hrea_mobile_employee/app/modules/event_detail/model/event_detail_model.dart';
import 'package:hrea_mobile_employee/app/resources/base_link.dart';

class EventDetailApi {
  static Future<EventDetailModel> getEventDetail(String jwtToken, String eventID) async {
    var response = await http.get(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.getEventDetail}$eventID'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<EventDetailModel>.value(EventDetailModel.fromJson(jsonDecode(response.body)["result"]));
    } else {
      throw Exception('Exception');
    }
  }
}
