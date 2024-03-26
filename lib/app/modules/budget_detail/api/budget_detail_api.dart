import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:hrea_mobile_employee/app/modules/budget/model/budget_model.dart';
import 'package:hrea_mobile_employee/app/modules/budget_detail/model/upload_evidence_model.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:http/http.dart' as http;
import 'package:hrea_mobile_employee/app/resources/base_link.dart';
import 'package:http_parser/http_parser.dart';

class BudgetDetailApi {
  static Future<ResponseApi> deleteBudget(String transactionID, String jwtToken) async {
    var response = await http.delete(Uri.parse('${BaseLink.localBaseLink}${BaseLink.deleteBudget}$transactionID'), headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      'Authorization': 'Bearer $jwtToken',
    });

    print('abc' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<Transaction> getBudgetDetail(String transactionID, String jwtToken) async {
    var response = await http.get(Uri.parse('${BaseLink.localBaseLink}${BaseLink.getBudgetDetail}$transactionID'), headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      'Authorization': 'Bearer $jwtToken',
    });

    print('budget detail' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)["result"];
      return Future<Transaction>.value(Transaction.fromJson(jsonData));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<UploadEvidenceModel> uploadFile(String jwtToken, List<PlatformFile> filePicker, String transactionID) async {
    final uri = Uri.parse("${BaseLink.localBaseLink}${BaseLink.updateEvidence}$transactionID/evidence");
    MediaType contentType = MediaType('', '');

    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    for (var item in filePicker) {
      if (item.extension == 'doc' || item.extension == 'docx') {
        contentType = MediaType('application', 'vnd.openxmlformats-officedocument.wordprocessingml.document');
      } else if (item.extension == "xlsx") {
        contentType = MediaType('application', 'vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      } else if (item.extension == "jpg") {
        contentType = MediaType('image', 'jpg');
      } else if (item.extension == "jpeg") {
        contentType = MediaType('image', 'jpeg');
      } else if (item.extension == "png") {
        contentType = MediaType('image', 'png');
      } else if (item.extension == "pdf") {
        contentType = MediaType('application', 'pdf');
      }
      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath('files', item.path!, contentType: contentType, filename: item.path!.split('/').last);
      request.files.add(multipartFile);
    }

    request.headers.addAll(_header(jwtToken));
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    print(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<UploadEvidenceModel>.value(UploadEvidenceModel.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 500 || response.statusCode == 400) {
      return Future<UploadEvidenceModel>.value(UploadEvidenceModel.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> replaceEvidence(String jwtToken, List<PlatformFile> filePicker, String transactionID) async {
    final uri = Uri.parse("${BaseLink.localBaseLink}${BaseLink.updateEvidence}$transactionID/evidence");
    MediaType contentType = MediaType('', '');

    http.MultipartRequest request = http.MultipartRequest('PUT', uri);
    for (var item in filePicker) {
      if (item.extension == 'doc' || item.extension == 'docx') {
        contentType = MediaType('application', 'vnd.openxmlformats-officedocument.wordprocessingml.document');
      } else if (item.extension == "xlsx") {
        contentType = MediaType('application', 'vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      } else if (item.extension == "jpg") {
        contentType = MediaType('image', 'jpg');
      } else if (item.extension == "jpeg") {
        contentType = MediaType('image', 'jpeg');
      } else if (item.extension == "png") {
        contentType = MediaType('image', 'png');
      } else if (item.extension == "pdf") {
        contentType = MediaType('application', 'pdf');
      }
      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath('files', item.path!, contentType: contentType, filename: item.path!.split('/').last);
      request.files.add(multipartFile);
    }

    request.headers.addAll(_header(jwtToken));
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    print(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 500 || response.statusCode == 400) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }
}

_header(String token) {
  return {
    "Content-Type": "multipart/form-data",
    "Authorization": "Bearer $token",
  };
}
