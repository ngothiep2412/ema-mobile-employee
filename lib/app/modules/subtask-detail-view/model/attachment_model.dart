// To parse this JSON data, do
//
//     final attachmentModel = attachmentModelFromJson(jsonString);

import 'dart:convert';

AttachmentModel attachmentModelFromJson(String str) =>
    AttachmentModel.fromJson(json.decode(str));

String attachmentModelToJson(AttachmentModel data) =>
    json.encode(data.toJson());

class AttachmentModel {
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? fileName;
  String? fileUrl;
  String? taskId;
  int? mode; // 1 là taskFile 2 là fileComment

  AttachmentModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.fileName,
    this.fileUrl,
    this.taskId,
    this.mode,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) =>
      AttachmentModel(
        id: json["id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        fileName: json["fileName"],
        fileUrl: json["fileUrl"],
        taskId: json["taskID"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "fileName": fileName,
        "fileUrl": fileUrl,
        "taskID": taskId,
      };
}
