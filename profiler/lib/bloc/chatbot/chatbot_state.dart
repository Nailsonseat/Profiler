part of 'chatbot_bloc.dart';

@immutable
abstract class ChatBotState {}

class ChatbotInitial extends ChatBotState {}

class ChatbotLoading extends ChatBotState {}

class ChatbotLoaded extends ChatBotState {
  final List<ChatMessage> messages;

  ChatbotLoaded(this.messages);
}

class ChatbotError extends ChatBotState {
  final String message;

  ChatbotError(this.message);
}
