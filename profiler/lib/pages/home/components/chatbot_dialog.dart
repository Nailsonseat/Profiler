import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../bloc/chatbot/chatbot_bloc.dart';
import '../../../constants/constants.dart';
import 'animated_message_tile.dart';
import 'message_tile.dart';



class ChatbotDialog extends StatefulWidget {
  ChatbotDialog({super.key});

  @override
  State<ChatbotDialog> createState() => _ChatbotDialogState();
}

class _ChatbotDialogState extends State<ChatbotDialog> {
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      context.read<ChatBotBloc>().add(SendMessage(
        message: _messageController.text,
        sender: ChatBot.user,
        receiver: ChatBot.bot,
      ));
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaledBox(
      width: ResponsiveValue<double?>(context, conditionalValues: [
        const Condition.smallerThan(name: TABLET, value: AppConstants.mobileScaleWidth),
        const Condition.largerThan(name: MOBILE, value: AppConstants.tabletScaleWidth),
        const Condition.equals(name: DESKTOP, value: AppConstants.desktopScaleWidth),
        const Condition.largerThan(name: DESKTOP, value: AppConstants.desktopScaleWidth),
      ]).value,
      child: Dialog(
        child:  Container(
          height: 900,
          width: 600,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text('ChatBot', style: GoogleFonts.jost(fontSize: 42)),
              SizedBox(
                height: 600,
                width: 850,
                child: BlocBuilder<ChatBotBloc, ChatBotState>(
                  buildWhen: (previous, current) => current is ChatbotLoaded,
                  builder: (context, state) {
                    if (state is ChatbotLoaded) {
                      return Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListView.builder(
                          itemCount: state.messages.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            final chatMessage = state.messages[index];
                            if (index == 0 && chatMessage.role == ChatBot.bot) {
                              return AnimatedMessageTile(
                                message: chatMessage.message,
                                role: chatMessage.role,
                                time: chatMessage.time,
                              );
                            }
                            return MessageTile(
                              message: chatMessage.message,
                              role: chatMessage.role,
                              time: chatMessage.time,
                            );
                          },
                        ),
                      );
                    }
                    return const Center(child: Text('No messages yet.'));
                  },
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 380,
                    child: TextFormField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Type your message...',
                        contentPadding: const EdgeInsets.all(24),
                        hintStyle: GoogleFonts.poppins(fontSize: 21),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<ChatBotBloc, ChatBotState>(
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 150,
                            height: 50,
                            child: FilledButton.tonal(
                              onPressed: () {
                                context.pop();
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(Colors.red[100]),
                                shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                              ),
                              child: Text('Close', style: GoogleFonts.poppins(fontSize: 21)),
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            height: 50,
                            child: FilledButton.tonal(
                              onPressed: _sendMessage,
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(Colors.purpleAccent[50]),
                                shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Send', style: GoogleFonts.poppins(fontSize: 21)),
                                  if (state is ChatbotLoading) const SizedBox(width: 10),
                                  if (state is ChatbotLoading)
                                    const SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.5,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}