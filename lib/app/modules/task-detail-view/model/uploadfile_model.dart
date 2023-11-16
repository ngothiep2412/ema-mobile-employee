// To parse this JSON data, do
//
//     final uploadFileModel = uploadFileModelFromJson(jsonString);

import 'dart:convert';

UploadFileModel uploadFileModelFromJson(String str) =>
    UploadFileModel.fromJson(json.decode(str));

String uploadFileModelToJson(UploadFileModel data) =>
    json.encode(data.toJson());

class UploadFileModel {
  int? statusCode;
  Result? result;

  UploadFileModel({
    this.statusCode,
    this.result,
  });

  factory UploadFileModel.fromJson(Map<String, dynamic> json) =>
      UploadFileModel(
        statusCode: json["statusCode"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "result": result?.toJson(),
      };
}

class Result {
  String? fileName;
  String? fileType;
  int? fileSize;
  String? downloadUrl;

  Result({
    this.fileName,
    this.fileType,
    this.fileSize,
    this.downloadUrl,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        fileName: json["fileName"],
        fileType: json["fileType"],
        fileSize: json["fileSize"],
        downloadUrl: json["downloadUrl"],
      );

  Map<String, dynamic> toJson() => {
        "fileName": fileName,
        "fileType": fileType,
        "fileSize": fileSize,
        "downloadUrl": downloadUrl,
      };
}
