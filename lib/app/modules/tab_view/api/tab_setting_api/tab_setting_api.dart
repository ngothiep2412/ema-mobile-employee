import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hrea_mobile_employee/app/modules/tab_view/model/user_model.dart';
import 'package:hrea_mobile_employee/app/resources/base_link.dart';

class TabSettingApi {
  static Future<UserModel> getProfile(String jwtToken) async {
    var response = await http.get(
      Uri.parse(BaseLink.localBaseLink + BaseLink.getProfile),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    print('abc profile' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<UserModel>.value(UserModel.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }
}
