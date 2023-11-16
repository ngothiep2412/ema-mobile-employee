import 'dart:convert';
import 'package:hrea_mobile_employee/app/modules/task-detail-view/model/uploadfile_model.dart';
import 'package:hrea_mobile_employee/app/resources/base_link.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

class EditBudgetApi {
  static Future<ResponseApi> updateBudget(String eventID, String budgetName, int estExpense, int realExpense, String description, String urlImage,
      String supplier, String budgetID, String jwtToken) async {
    Map<String, dynamic> body = {
      "eventID": eventID,
      "budgetName": budgetName,
      "estExpense": estExpense,
      "realExpense": realExpense,
      "description": description,
      "urlImage": urlImage,
      "supplier": supplier,
    };
    var response = await http.put(Uri.parse('${BaseLink.localBaseLink}${BaseLink.updateBudget}$budgetID'),
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

  static Future<UploadFileModel> uploadFile(String jwtToken, XFile image) async {
    final uri = Uri.parse(BaseLink.localBaseLink + BaseLink.uploadFile);

    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    http.MultipartFile multipartFile = await http.MultipartFile.fromPath('file', image.path,
        contentType: getContentTypeFromExtension(image.path.split('.').last), filename: image.path.split('/').last);

    request.files.add(multipartFile);
    request.headers.addAll(_header(jwtToken));
    request.fields['folderName'] = 'budget';
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    print(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<UploadFileModel>.value(UploadFileModel.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 500 || response.statusCode == 400) {
      return Future<UploadFileModel>.value(UploadFileModel.fromJson(jsonDecode(response.body)));
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

MediaType getContentTypeFromExtension(String fileExtension) {
  switch (fileExtension.toLowerCase()) {
    case 'jpg':
      return MediaType('image', 'jpg');
    case 'jpeg':
      return MediaType('image', 'jpeg');
    case 'png':
      return MediaType('image', 'png');
    // Add more cases for other image formats if needed
    default:
      return MediaType('application', 'octet-stream'); // Default to binary data
  }
}
