import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:profiler/api/chatbot.dart';
import 'package:profiler/models/chat_message.dart';
import '../../constants/constants.dart';

part 'chatbot_event.dart';
part 'chatbot_state.dart';

class ChatBotBloc extends Bloc<ChatbotEvent, ChatBotState> {
  final ChatBotApi chatBotApi;

  ChatBotBloc({required this.chatBotApi})
      : super(ChatbotLoaded([
          ChatMessage(
            message: 'Hi there!',
            role: ChatBot.bot,
            time: DateTime.now().toIso8601String(),
          )
        ])) {
    on<SendMessage>(_sendMessage);
  }

  Future<void> _sendMessage(SendMessage event, Emitter<ChatBotState> emit) async {
    List<ChatMessage> messages = (state as ChatbotLoaded).messages;
    messages = [
      ChatMessage(
        message: event.message,
        role: ChatBot.user,
        time: DateTime.now().toIso8601String(),
      ),
      ...messages,
    ];
    emit(ChatbotLoaded(List.from(messages)));

    emit(ChatbotLoading());

    try {
      final ChatMessage response = await chatBotApi.sendMessage(messages.first, messages);
      messages = [
        response,
        ...messages,
      ];
      emit(ChatbotLoaded(List.from(messages)));
    } catch (error) {
      emit(ChatbotError(error.toString()));
    }

    emit(ChatbotLoaded(List.from(messages)));
  }
}
