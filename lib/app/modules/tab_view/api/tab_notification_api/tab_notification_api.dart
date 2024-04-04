import 'dart:convert';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/notification.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';

import 'package:http/http.dart' as http;
import 'package:hrea_mobile_employee/app/resources/base_link.dart';

class TabNotificationApi {
  static Future<List<NotificationModel>> getAllNotification(String jwtToken, int page) async {
    var response = await http.get(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.getAllNotification}?sizePage=20&currentPage=$page'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    print('abc task' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)["result"]["data"]["notifications"];
      List<NotificationModel> listNotifications = [];
      listNotifications.addAll(jsonData.map((listNotifications) => NotificationModel.fromJson(listNotifications)).cast<NotificationModel>());
      return listNotifications;
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> seenANotification(String jwtToken, String notificationID) async {
    var response = await http.put(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.seenANotification}?notificationId=$notificationID'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> seenAllNotification(String jwtToken) async {
    var response = await http.put(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.seenAllNotification}'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> deleteNotification(String jwtToken, String notificationID) async {
    var response = await http.delete(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.deleteNotification}?notificationId=$notificationID'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> deleteAllNotification(String jwtToken) async {
    var response = await http.delete(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.deleteAllNotification}'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }
}
