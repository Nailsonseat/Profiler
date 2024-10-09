class ChatMessage {
  String message;
  String role;
  String time;

  ChatMessage({required this.message, required this.role, required this.time});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      message: json['message'],
      role: json['role'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'role': role,
      'time': time,
    };
  }
}
