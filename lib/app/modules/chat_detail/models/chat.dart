// To parse this JSON data, do
//
//     final chatModel = chatModelFromJson(jsonString);

import 'dart:convert';

List<ChatModel> chatModelFromJson(String str) => List<ChatModel>.from(json.decode(str).map((x) => ChatModel.fromJson(x)));

String chatModelToJson(List<ChatModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatModel {
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? content;
  Author? author;
  List<dynamic>? attachments;

  ChatModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.content,
    this.author,
    this.attachments,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
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
