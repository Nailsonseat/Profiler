import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import '../../../constants/constants.dart';

class AnimatedMessageTile extends StatefulWidget {
  const AnimatedMessageTile({super.key, required this.message, required this.role, required this.time});

  final String message;
  final String role;
  final String time;

  @override
  AnimatedMessageTileState createState() => AnimatedMessageTileState();
}

class AnimatedMessageTileState extends State<AnimatedMessageTile> {
  String displayedMessage = '';
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _startTypingAnimation();
  }

  void _startTypingAnimation() {
    int characterIndex = 0;
    _typingTimer = Timer.periodic(const Duration(microseconds: 1), (timer) {
      if (characterIndex < widget.message.length) {
        setState(() {
          displayedMessage += widget.message[characterIndex];
        });
        characterIndex++;
      } else {
        _typingTimer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: Align(
        alignment: widget.role == ChatBot.user ? Alignment.centerRight : Alignment.centerLeft,
        child: IntrinsicWidth(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: widget.role == ChatBot.user ? Colors.blue : Colors.green,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MarkdownBody(
                  data: displayedMessage,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      widget.role,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      DateFormat('h:mm a').format(DateTime.parse(widget.time)),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
