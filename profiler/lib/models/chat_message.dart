class ChatMessage {
  String message;
  String sender;
  String receiver;
  String time;

  ChatMessage({required this.message, required this.sender, required this.receiver, required this.time});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      message: json['message'],
      sender: json['sender'],
      receiver: json['receiver'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'sender': sender,
      'receiver': receiver,
      'time': time,
    };
  }
}
