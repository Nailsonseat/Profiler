part of 'chatbot_bloc.dart';

@immutable
abstract class ChatbotEvent {}

class SendMessage extends ChatbotEvent {
  final String message;
  final String sender;
  final String receiver;

  SendMessage({required this.message, required this.sender, required this.receiver});
}
