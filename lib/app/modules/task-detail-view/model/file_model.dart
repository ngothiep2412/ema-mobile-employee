// To parse this JSON data, do
//
//     final fileModel = fileModelFromJson(jsonString);

import 'dart:convert';

FileModel fileModelFromJson(String str) => FileModel.fromJson(json.decode(str));

String fileModelToJson(FileModel data) => json.encode(data.toJson());

class FileModel {
  String? fileName;
  String? fileUrl;

  FileModel({
    this.fileName,
    this.fileUrl,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) => FileModel(
        fileName: json["fileName"],
        fileUrl: json["fileUrl"],
      );

  Map<String, dynamic> toJson() => {
        "fileName": fileName,
        "fileUrl": fileUrl,
      };
}
