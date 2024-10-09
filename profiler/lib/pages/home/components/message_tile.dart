import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import '../../../constants/constants.dart';



class MessageTile extends StatelessWidget {
  const MessageTile({super.key, required this.message, required this.role, required this.time});

  final String message;
  final String role;
  final String time;


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: Align(
        alignment: role == ChatBot.user ? Alignment.centerRight : Alignment.centerLeft,
        child: IntrinsicWidth(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: role == ChatBot.user ? Colors.blue : Colors.green,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MarkdownBody(
                  data: message,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(
                      color: Colors.white, // Change text color
                      fontSize: 18, // Change font size
                      fontWeight: FontWeight.w500, // Change font weight
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      role,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      DateFormat('h:mm a').format(DateTime.parse(time)),
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
