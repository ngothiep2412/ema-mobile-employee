// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

List<NotificationModel> notificationModelFromJson(String str) =>
    List<NotificationModel>.from(json.decode(str).map((x) => NotificationModel.fromJson(x)));

String notificationModelToJson(List<NotificationModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationModel {
  String? id;
  String? title;
  String? content;
  String? type;
  String? sender;
  int? isRead;
  DateTime? createdAt;
  dynamic commonId;
  dynamic eventId;
  String? avatarSender;

  NotificationModel({
    this.id,
    this.title,
    this.content,
    this.type,
    this.sender,
    this.isRead,
    this.createdAt,
    this.commonId,
    this.eventId,
    this.avatarSender,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        type: json["type"],
        sender: json["sender"],
        isRead: json["isRead"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        commonId: json["commonId"],
        eventId: json["eventId"],
        avatarSender: json["avatarSender"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "type": type,
        "sender": sender,
        "isRead": isRead,
        "createdAt": createdAt?.toIso8601String(),
        "commonId": commonId,
        "eventId": eventId,
        "avatarSender": avatarSender,
      };
}
