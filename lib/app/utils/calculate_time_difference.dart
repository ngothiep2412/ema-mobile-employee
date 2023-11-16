import 'package:intl/intl.dart';

String calculateTimeDifference(String createdAt) {
  DateTime now = DateTime.now().toLocal().add(const Duration(hours: 7));
  print('now ${now}');
  DateTime createdAtDateTime = DateTime.parse(createdAt).toLocal().add(const Duration(hours: 7));
  print('createdAtDateTime ${createdAtDateTime}');

  Duration difference = now.difference(createdAtDateTime);

  if (difference.inMinutes < 1) {
    return "Bây giờ";
  } else if (difference.inHours < 1) {
    return "${difference.inMinutes} phút trước";
  } else if (difference.inDays < 1) {
    return "${difference.inHours} giờ trước";
  } else if (difference.inDays < 30) {
    return "${difference.inDays} ngày trước";
  } else {
    final formattedDate = DateFormat.yMMMd().format(createdAtDateTime);
    return "vào $formattedDate";
  }
}

String getCurrentTime(DateTime endDate) {
  final formattedTime = '${endDate.hour.toString().padLeft(2, '0')}:${endDate.minute.toString().padLeft(2, '0')}';
  return formattedTime;
}

String getTheAbbreviation(String name) {
  // Phân tách chuỗi thành danh sách các từ
  List<String> words = name.split(' ');

  // Lấy chữ cái đầu tiên của từ đầu tiên
  String firstCharacterFirstWord = words[0][0];

  // Lấy chữ cái đầu tiên của từ cuối cùng
  String firstCharacterLastWord = words[words.length - 1][0];

  return firstCharacterLastWord + firstCharacterFirstWord;
}
