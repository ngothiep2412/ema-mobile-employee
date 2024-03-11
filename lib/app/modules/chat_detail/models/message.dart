// To parse this JSON data, do
//
//     final messageModel = messageModelFromJson(jsonString);

import 'dart:convert';

MessageModel messageModelFromJson(String str) => MessageModel.fromJson(json.decode(str));

String messageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
  int? totalItems;
  List<Datum>? data;
  String? lastKey;

  MessageModel({
    this.totalItems,
    this.data,
    this.lastKey,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        totalItems: json["totalItems"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        lastKey: json["lastKey"],
      );

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "lastKey": lastKey,
      };
}

class Datum {
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? content;
  Author? author;
  List<dynamic>? attachments;

  Datum({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.content,
    this.author,
    this.attachments,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        content: json["content"],
        author: json["author"] == null ? null : Author.fromJson(json["author"]),
        attachments: json["attachments"] == null ? [] : List<dynamic>.from(json["attachments"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "content": content,
        "author": author?.toJson(),
        "attachments": attachments == null ? [] : List<dynamic>.from(attachments!.map((x) => x)),
      };
}

class Author {
  String? id;
  String? email;
  Profile? profile;

  Author({
    this.id,
    this.email,
    this.profile,
  });

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: json["id"],
        email: json["email"],
        profile: json["profile"] == null ? null : Profile.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "profile": profile?.toJson(),
      };
}

class Profile {
  String? fullName;
  String? avatar;

  Profile({
    this.fullName,
    this.avatar,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        fullName: json["fullName"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "avatar": avatar,
      };
}
