// To parse this JSON data, do
//
//     final loginReponseApi = loginReponseApiFromJson(jsonString);

import 'dart:convert';

LoginReponseApi loginReponseApiFromJson(String str) =>
    LoginReponseApi.fromJson(json.decode(str));

String loginReponseApiToJson(LoginReponseApi data) =>
    json.encode(data.toJson());

class LoginReponseApi {
  int? statusCode;
  String? message;
  String? accessToken;
  String? refreshToken;

  LoginReponseApi({
    this.statusCode,
    this.message,
    this.accessToken,
    this.refreshToken,
  });

  factory LoginReponseApi.fromJson(Map<String, dynamic> json) =>
      LoginReponseApi(
        statusCode: json["statusCode"],
        message: json["message"],
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "access_token": accessToken,
        "refresh_token": refreshToken,
      };
}
