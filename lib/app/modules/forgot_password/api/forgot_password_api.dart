import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:hrea_mobile_employee/app/resources/base_link.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';

class ForgotPasswordApi {
  static Future<ResponseApi> sendOtp(String email) async {
    Map<String, String> body = {
      "email": email,
    };
    var response = await http.post(Uri.parse(BaseLink.localBaseLink + BaseLink.sendOtp),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        },
        body: jsonEncode(body));
    print('abc send otp again' + response.statusCode.toString());

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 500 || response.statusCode == 400) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }
}
