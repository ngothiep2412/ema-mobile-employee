import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Map<String, Color> fileColorMap = {
  'pdf': Colors.redAccent,
  'doc': Colors.blueAccent,
  'docx': Colors.blueAccent,
  'xlsx': Colors.greenAccent,
};

Future<String> getFileType(String url) async {
  final response = await http.head(Uri.parse(url));
  final contentType = response.headers['content-type'];

  if (contentType != null) {
    if (contentType.contains('image/jpeg')) {
      return 'JPEG';
    } else if (contentType.contains('image/png')) {
      return 'PNG';
    } else if (contentType.contains('image/jpg')) {
      return 'JPG';
    } else {
      return 'Không xác định';
    }
  } else {
    return 'Không xác định';
  }
}
