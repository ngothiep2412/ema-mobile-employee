import 'dart:convert';
import 'dart:io';
import 'package:hrea_mobile_employee/app/modules/subtask-detail-view/model/employee_model.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/user_model.dart';
import 'package:hrea_mobile_employee/app/modules/task-detail-view/model/comment_model.dart';
import 'package:hrea_mobile_employee/app/modules/task-detail-view/model/file_model.dart';
import 'package:hrea_mobile_employee/app/modules/task-detail-view/model/uploadfile_model.dart';
import 'package:hrea_mobile_employee/app/resources/base_link.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class SubTaskDetailApi {
  static Future<TaskModel> getTaskDetail(String jwtToken, String taskID) async {
    var response = await http.get(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.getTask}?fieldName=id&conValue=$taskID&sizePage=10&currentPage=1'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    print('abc task' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<TaskModel>.value(TaskModel.fromJson(jsonDecode(response.body)["result"][0]));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> updateDateTimeTask(String jwtToken, String taskID, DateTime startDate, DateTime endDate, String eventID) async {
    Map<String, dynamic> body = {
      "eventID": eventID,
      "startDate": startDate.toString(),
      "endDate": endDate.toString(),
    };
    print(taskID);

    var response = await http.put(Uri.parse('${BaseLink.localBaseLink}${BaseLink.updateTask}?taskID=$taskID'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body));

    print('abc updateStatusTask' + response.statusCode.toString());

    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> updateTaskFile(String jwtToken, String taskID, List<TaskFile> listTaskFile) async {
    print(taskID);

    var response = await http.put(Uri.parse('${BaseLink.localBaseLink}${BaseLink.updateTaskFile}$taskID'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(listTaskFile));

    print('abc updateStatusTask' + response.statusCode.toString());

    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> updateCommentFile(String jwtToken, String commentID, List<CommentFile> listCommentFile) async {
    print(commentID);

    var response = await http.put(Uri.parse('${BaseLink.localBaseLink}${BaseLink.updateCommentFile}$commentID'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(listCommentFile));

    print('abc updateStatusTask' + response.statusCode.toString());

    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> updateComment(String jwtToken, String commentID, String content, List<CommentFile> listCommentFile) async {
    Map<String, dynamic> body = {
      "content": content,
      "file": listCommentFile,
    };

    var response = await http.put(Uri.parse('${BaseLink.localBaseLink}${BaseLink.updateComment}$commentID'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body));

    print('abc updateComment' + response.statusCode.toString());

    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> updateAssigneeLeader(String jwtToken, String taskID, List<String> assignee, String leaderID) async {
    Map<String, dynamic> body = {
      "assignee": assignee,
      "taskID": taskID,
      "leader": leaderID,
    };
    print(taskID);

    var response = await http.post(Uri.parse('${BaseLink.localBaseLink}${BaseLink.assignTask}'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body));

    print('abc updateStatusTask' + response.statusCode.toString());

    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<List<EmployeeModel>> getAllEmployee(String jwtToken, String divisionId) async {
    var response = await http.get(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.getAllEmployee}?divisionId=$divisionId&role=EMPLOYEE&sizePage=100&currentPage=1'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );

    print('abc event' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)["result"]["data"];
      List<EmployeeModel> listEmployee = [];
      listEmployee.addAll(jsonData.map((events) => EmployeeModel.fromJson(events)).cast<EmployeeModel>());
      return listEmployee;
    } else {
      throw Exception('Exception');
    }
  }

  static Future<UserModel> getAssignerDetail(String jwtToken, String assignerID) async {
    var response = await http.get(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.getAssignerInformation}$assignerID'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    print('abc assginer' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<UserModel>.value(UserModel.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> updateStatusTask(String jwtToken, String taskID, String status) async {
    // Map<String, String> body = {
    //   "taskID": taskID,
    //   "status": status,
    // };
    print(taskID);

    var response = await http.put(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.updateStatusTask}?taskID=$taskID&status=$status'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
      // body: jsonEncode(body));
    );
    print('abc updateStatusTask' + response.statusCode.toString());

    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> updateFileTask(String jwtToken, String taskID, String fileUrl, String fileName) async {
    Map<String, String> body = {
      "taskID": taskID,
      "fileName": fileName,
      "fileUrl": fileUrl,
    };
    print(taskID);

    var response = await http.post(Uri.parse('${BaseLink.localBaseLink}${BaseLink.updateFileTask}'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body));

    print('abc updateFile' + response.statusCode.toString());

    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> updateDescriptionTask(String jwtToken, String taskID, String eventID, String description) async {
    Map<String, String> body = {
      "description": description,
      "eventID": eventID,
    };
    print(taskID);

    var response = await http.put(Uri.parse('${BaseLink.localBaseLink}${BaseLink.updateTask}?taskID=$taskID'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body));

    print('abc updateStatusTask' + response.statusCode.toString());

    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> updateEstimationTime(String jwtToken, String taskID, String eventID, double estimationTime) async {
    Map<String, String> body = {
      "estimationTime": estimationTime.toString(),
      "eventID": eventID,
    };
    print(taskID);

    var response = await http.put(Uri.parse('${BaseLink.localBaseLink}${BaseLink.updateTask}?taskID=$taskID'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body));

    print('abc updateStatusTask' + response.statusCode.toString());

    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> updateEffort(String jwtToken, String taskID, String eventID, double effort) async {
    Map<String, String> body = {
      "effort": effort.toString(),
      "eventID": eventID,
    };
    print(taskID);

    var response = await http.put(Uri.parse('${BaseLink.localBaseLink}${BaseLink.updateTask}?taskID=$taskID'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body));

    print('abc updateStatusTask' + response.statusCode.toString());

    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> updatePriority(String jwtToken, String taskID, String eventID, String priority) async {
    Map<String, String> body = {
      "priority": priority,
      "eventID": eventID,
    };
    print(taskID);

    var response = await http.put(Uri.parse('${BaseLink.localBaseLink}${BaseLink.updateTask}?taskID=$taskID'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body));

    print('abc updateStatusTask' + response.statusCode.toString());

    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> createSubTask(String jwtToken, String title, String eventID, String parentTask) async {
    Map<String, dynamic> body = {
      "title": title,
      "eventID": eventID,
      "parentTask": parentTask,
      "assignee": [],
    };

    var response = await http.post(Uri.parse('${BaseLink.localBaseLink}${BaseLink.createSubTask}'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body));

    print('abc updateStatusTask' + response.statusCode.toString());

    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> createComment(String jwtToken, String taskID, String content, List<FileModel> file) async {
    Map<String, dynamic> body = {"taskID": taskID, "content": content, "file": file};

    var response = await http.post(Uri.parse('${BaseLink.localBaseLink}${BaseLink.createComment}'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body));

    print('abc comment' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> updateTitleTask(String jwtToken, String taskID, String eventID, String title) async {
    Map<String, String> body = {
      "title": title,
      "eventID": eventID,
    };
    print(taskID);

    var response = await http.put(Uri.parse('${BaseLink.localBaseLink}${BaseLink.updateTask}?taskID=$taskID'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body));

    print('abc updateStatusTask' + response.statusCode.toString());

    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> deleteComment(String jwtToken, String commentID) async {
    var response = await http.delete(Uri.parse('${BaseLink.localBaseLink}${BaseLink.deleteComment}$commentID'), headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      'Authorization': 'Bearer $jwtToken',
    });

    print('abc updateStatusTask' + response.statusCode.toString());

    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<UploadFileModel> uploadFile(String jwtToken, File file, String extension, String type) async {
    final uri = Uri.parse(BaseLink.localBaseLink + BaseLink.uploadFile);
    MediaType contentType = MediaType('', '');
    if (extension == 'doc' || extension == 'docx') {
      contentType = MediaType('application', 'vnd.openxmlformats-officedocument.wordprocessingml.document');
    } else if (extension == "xlsx") {
      contentType = MediaType('application', 'vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    } else if (extension == "jpg") {
      contentType = MediaType('image', 'jpg');
    } else if (extension == "jpeg") {
      contentType = MediaType('image', 'jpeg');
    } else if (extension == "png") {
      contentType = MediaType('image', 'png');
    } else if (extension == "pdf") {
      contentType = MediaType('application', 'pdf');
    }
    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath('file', file.path, contentType: contentType, filename: file.path.split('/').last);
    request.files.add(multipartFile);
    request.headers.addAll(_header(jwtToken));
    request.fields['folderName'] = type;
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

  static Future<List<CommentModel>> getAllComment(String jwtToken, String taskID) async {
    var response = await http.get(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.getAllComment}/$taskID'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)["result"];
      List<CommentModel> listComment = [];
      listComment.addAll(jsonData.map((events) => CommentModel.fromJson(events)).cast<CommentModel>());
      return listComment;
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
