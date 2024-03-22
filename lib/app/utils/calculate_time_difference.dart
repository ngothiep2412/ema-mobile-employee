import 'package:intl/intl.dart';

String calculateTimeDifference(String createdAt) {
  DateTime now = DateTime.now().toLocal();
  print('now ${now}');
  print('createdAt ${createdAt}');

  DateTime createdAtDateTime = DateTime.parse(createdAt).toLocal();
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

String calculateTimeDifferenceMessenger(String createdAt) {
  DateTime now = DateTime.now().toLocal();
  DateTime createdAtDateTime = DateTime.parse(createdAt).toLocal();

  if (isSameDate(now, createdAtDateTime)) {
    return DateFormat('HH:mm').format(createdAtDateTime);
  } else if (createdAtDateTime.difference(now).inDays > 30) {
    return DateFormat('EEEE, dd MMM yy', 'vi_VN').format(createdAtDateTime);
  } else {
    Intl.defaultLocale = 'vi_VN'; // Thiết lập locale sang tiếng Việt
    return DateFormat('EEEE, dd MMM', 'vi_VN').format(createdAtDateTime);
  }
}

bool isSameDate(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}

void main() {
  print(calculateTimeDifference("2024-12-12T12:20:00")); // Example usage
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
