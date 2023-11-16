import 'dart:convert';

import 'package:hrea_mobile_employee/app/resources/base_link.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:http/http.dart' as http;

class ResetPasswordApi {
  static Future<ResponseApi> resetPassword(String email, String passowrd) async {
    Map<String, String> body = {
      "email": email,
      "password": passowrd,
    };
    var response = await http.put(Uri.parse(BaseLink.localBaseLink + BaseLink.resetPassword),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        },
        body: jsonEncode(body));
    print('abc' + response.statusCode.toString());

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 500 || response.statusCode == 400) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }
}
