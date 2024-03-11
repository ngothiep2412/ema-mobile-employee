import 'dart:convert';
import 'package:hrea_mobile_employee/app/modules/chat_detail/models/chat.dart';
import 'package:hrea_mobile_employee/app/modules/chat_detail/models/message.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/chat_user.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:http/http.dart' as http;
import 'package:hrea_mobile_employee/app/resources/base_link.dart';

class ChatDetailApi {
  static Future<List<ChatModel>> getChatUser(String jwtToken, String id, int page, String startKey) async {
    var response;
    if (startKey == '') {
      response = await http.get(
        Uri.parse('${BaseLink.localBaseLink}${BaseLink.getMessages}$id/messages?sizePage=$page'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
      );
    } else {
      response = await http.get(
        Uri.parse('${BaseLink.localBaseLink}${BaseLink.getMessages}$id/messages?sizePage=$page&startKey=$startKey'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
      );
    }
    print('abc chat' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)["result"]["messages"]["data"];
      List<ChatModel> listChatUser = [];
      listChatUser.addAll(jsonData.map((item) => ChatModel.fromJson(item)).cast<ChatModel>());
      return listChatUser;
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> createMessage(String jwtToken, String email, String content, String id) async {
    Map<String, dynamic> body = {
      "content": content,
    };

    var response = await http.post(Uri.parse('${BaseLink.localBaseLink}${BaseLink.getConversation}/$id/messages'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body));

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<MessageModel> getChatUserV2(String jwtToken, String id, int page, String startKey) async {
    var response;
    if (startKey == '') {
      response = await http.get(
        Uri.parse('${BaseLink.localBaseLink}${BaseLink.getMessages}$id/messages?sizePage=$page'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
      );
    } else {
      response = await http.get(
        Uri.parse('${BaseLink.localBaseLink}${BaseLink.getMessages}$id/messages?sizePage=$page&startKey=$startKey'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
      );
    }

    print('abc chat' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<MessageModel>.value(MessageModel.fromJson(jsonDecode(response.body)["result"]["messages"]));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ChatUserModel> createConversation(String email, String message, String jwtToken) async {
    Map<String, dynamic> body = {"email": email, "message": message};
    var response = await http.post(Uri.parse(BaseLink.localBaseLink + BaseLink.getConversation),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body));
    print('abc' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<ChatUserModel>.value(ChatUserModel.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }
}
