import 'dart:convert';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/chat_user.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/user_division_model.dart';
import 'package:http/http.dart' as http;
import 'package:hrea_mobile_employee/app/resources/base_link.dart';

class TabChatApi {
  static Future<List<ChatUserModel>> getAllChatUser(String jwtToken, int page) async {
    var response = await http.get(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.getConversation}?sizePage=8&currentPage=$page'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    print('abc chat' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)["result"]["data"];
      List<ChatUserModel> listChatUser = [];
      listChatUser.addAll(jsonData.map((item) => ChatUserModel.fromJson(item)).cast<ChatUserModel>());
      return listChatUser;
    } else {
      throw Exception('Exception');
    }
  }

  static Future<List<ChatUserModel>> getAllChatUserV2(String jwtToken, int page) async {
    var response = await http.get(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.getConversation}?sizePage=100&currentPage=$page'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    print('abc chat' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)["result"]["data"];
      List<ChatUserModel> listChatUser = [];
      listChatUser.addAll(jsonData.map((item) => ChatUserModel.fromJson(item)).cast<ChatUserModel>());
      return listChatUser;
    } else {
      throw Exception('Exception');
    }
  }

  static Future<List<UserDivisionModel>> getAllUserDivision(String jwtToken, int page, String divisionId) async {
    var response = await http.get(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.getAllEmployee}?divisionId=$divisionId&sizePage=100&currentPage=$page'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    print('abc get employee' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)["result"]["data"];
      List<UserDivisionModel> listUserDivision = [];
      listUserDivision.addAll(jsonData.map((item) => UserDivisionModel.fromJson(item)).cast<UserDivisionModel>());
      return listUserDivision;
    } else {
      throw Exception('Exception');
    }
  }
}
