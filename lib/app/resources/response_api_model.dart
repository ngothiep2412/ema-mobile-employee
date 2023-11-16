// To parse this JSON data, do
//
//     final responseApi = responseApiFromJson(jsonString);

import 'dart:convert';

ResponseApi responseApiFromJson(String str) =>
    ResponseApi.fromJson(json.decode(str));

String responseApiToJson(ResponseApi data) => json.encode(data.toJson());

class ResponseApi {
  int? statusCode;
  String? message;
  String? result;

  ResponseApi({
    this.statusCode,
    this.message,
    this.result,
  });

  factory ResponseApi.fromJson(Map<String, dynamic> json) => ResponseApi(
        statusCode: json["statusCode"],
        message: json["message"],
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "result": result,
      };
}
