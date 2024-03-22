// To parse this JSON data, do
//
//     final uploadEvidenceModel = uploadEvidenceModelFromJson(jsonString);

import 'dart:convert';

UploadEvidenceModel uploadEvidenceModelFromJson(String str) => UploadEvidenceModel.fromJson(json.decode(str));

String uploadEvidenceModelToJson(UploadEvidenceModel data) => json.encode(data.toJson());

class UploadEvidenceModel {
  int? statusCode;
  List<Result>? result;

  UploadEvidenceModel({
    this.statusCode,
    this.result,
  });

  factory UploadEvidenceModel.fromJson(Map<String, dynamic> json) => UploadEvidenceModel(
        statusCode: json["statusCode"],
        result: json["result"] == null ? [] : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
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
