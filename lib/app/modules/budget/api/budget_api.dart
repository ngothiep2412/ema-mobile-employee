import 'dart:convert';
import 'package:hrea_mobile_employee/app/modules/budget/model/budget_model.dart';
import 'package:http/http.dart' as http;
import 'package:hrea_mobile_employee/app/resources/base_link.dart';

class BudgetApi {
  static Future<List<BudgetModel>> getAllBudget(String jwtToken, String eventID, int page, String userID, int mode) async {
    var response = await http.get(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.getAllBudget}/$eventID?sizePage=5&currentPage=$page&mode=$mode&userID=$userID'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)["result"]['data'];
      List<BudgetModel> listBudget = [];
      listBudget.addAll(jsonData.map((listBudget) => BudgetModel.fromJson(listBudget)).cast<BudgetModel>());
      return listBudget;
    } else {
      throw Exception('Exception');
    }
  }
}
