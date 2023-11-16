import 'dart:convert';
import 'package:hrea_mobile_employee/app/resources/base_link.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:http/http.dart' as http;

class EditRequestApi {
  static Future<ResponseApi> updateRequest(String requestID, String title, String content, DateTime startDate, DateTime endDate, bool isFull,
      bool isPM, String type, String jwtToken) async {
    Map<String, dynamic> body = {
      "title": title,
      "content": content,
      "startDate": startDate.toString(),
      "endDate": endDate.toString(),
      "isFull": isFull,
      "isPM": isPM,
      "type": type,
    };

    var response = await http.put(Uri.parse('${BaseLink.localBaseLink}${BaseLink.updateLeaveRequest}$requestID'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
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
