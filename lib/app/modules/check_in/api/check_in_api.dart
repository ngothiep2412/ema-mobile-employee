import 'dart:convert';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:http/http.dart' as http;
import 'package:hrea_mobile_employee/app/resources/base_link.dart';

class CheckInApi {
  static Future<ResponseApi> checkIn(String eventID, String jwtToken) async {
    Map<String, dynamic> body = {
      "eventID": eventID,
    };
    var response = await http.post(Uri.parse(BaseLink.localBaseLink + BaseLink.checkIn),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body));
    print('abc' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }
}
