import 'dart:convert';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/event.dart';
import 'package:hrea_mobile_employee/app/resources/base_link.dart';
import 'package:http/http.dart' as http;

class TabHomeApi {
  static Future<List<EventModel>> getEvent(String jwtToken) async {
    var response = await http.get(
      Uri.parse(BaseLink.localBaseLink + BaseLink.getEvent),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    print('abc event' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)["result"];
      List<EventModel> listEvent = [];
      listEvent.addAll(jsonData.map((events) => EventModel.fromJson(events)).cast<EventModel>());
      return listEvent;
    } else {
      throw Exception('Exception');
    }
  }

  static Future<List<EventModel>> getEventToday(String jwtToken, String userID) async {
    var response = await http.get(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.getEventFilter}?userId=$userID&status=TODAY'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    print('abc event' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)["result"];
      List<EventModel> listEvent = [];
      listEvent.addAll(jsonData.map((events) => EventModel.fromJson(events)).cast<EventModel>());
      return listEvent;
    } else {
      throw Exception('Exception');
    }
  }

  static Future<List<EventModel>> getEventUpComing(String jwtToken, String userID) async {
    var response = await http.get(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.getEventFilter}?userId=$userID&status=UPCOMMING'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    print('abc event' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)["result"];
      List<EventModel> listEvent = [];
      listEvent.addAll(jsonData.map((events) => EventModel.fromJson(events)).cast<EventModel>());
      return listEvent;
    } else {
      throw Exception('Exception');
    }
  }
}
