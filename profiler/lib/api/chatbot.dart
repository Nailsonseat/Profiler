import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:profiler/models/chat_message.dart';
import '../constants/constants.dart';

class ChatBotApi {
  final _client = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
    ),
  );

  final _logger = Logger();

  Future<ChatMessage> sendMessage(ChatMessage message, List<ChatMessage> history) async {
    try {
      final response = await _client.post('/api/chatbot/', data: {
        'input': message.message,
        'history': history.reversed.map((e) => e.toJson()).toList(),
      });

      return ChatMessage(
        message: response.data['output'],
        role: ChatBot.bot,
        time: response.data['timestamp'],
      );
    } catch (e) {
      _logger.e('Error sending message: $e');
      rethrow;
    }
  }
}
