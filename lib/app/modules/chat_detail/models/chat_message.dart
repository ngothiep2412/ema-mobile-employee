import 'package:hrea_mobile_employee/app/modules/chat_detail/controllers/chat_detail_controller.dart';

class ChatMessage {
  String message;
  MessageType type;
  String time;
  ChatMessage({required this.message, required this.type, required this.time});
}
