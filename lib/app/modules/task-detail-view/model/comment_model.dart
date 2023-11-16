// To parse this JSON data, do
//
//     final commentModel = commentModelFromJson(jsonString);

import 'dart:convert';

CommentModel commentModelFromJson(String str) =>
    CommentModel.fromJson(json.decode(str));

String commentModelToJson(CommentModel data) => json.encode(data.toJson());

class CommentModel {
  String? id;
  DateTime? createdAt;
  String? text;
  bool? status;
  User? user;
  List<CommentFile>? commentFiles;

  CommentModel({
    this.id,
    this.createdAt,
    this.text,
    this.status,
    this.user,
    this.commentFiles,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json["id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        text: json["text"],
        status: json["status"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        commentFiles: json["commentFiles"] == null
            ? []
            : List<CommentFile>.from(
                json["commentFiles"]!.map((x) => CommentFile.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "text": text,
        "status": status,
        "user": user?.toJson(),
        "commentFiles": commentFiles == null
            ? []
            : List<dynamic>.from(commentFiles!.map((x) => x.toJson())),
      };
}

class CommentFile {
  String? id;
  String? fileName;
  String? fileUrl;

  CommentFile({
    this.id,
    this.fileName,
    this.fileUrl,
  });

  factory CommentFile.fromJson(Map<String, dynamic> json) => CommentFile(
        id: json["id"],
        fileName: json["fileName"],
        fileUrl: json["fileUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fileName": fileName,
        "fileUrl": fileUrl,
      };
}

class User {
  String? id;
  String? email;
  Profile? profile;

  User({
    this.id,
    this.email,
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        profile:
            json["profile"] == null ? null : Profile.fromJson(json["profile"]),
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
