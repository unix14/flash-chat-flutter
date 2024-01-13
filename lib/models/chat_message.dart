
class ChatMessage {
  String senderId = "";
  String text = "";
  DateTime date = DateTime.now();
  ChatMessage({ required this.senderId, required this.text});
}