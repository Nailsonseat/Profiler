import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:profiler/bloc/profile/profile_bloc.dart';
import 'package:profiler/bloc/chatbot/chatbot_bloc.dart';
import 'package:profiler/models/profile.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../constants/constants.dart';
import 'components/animated_message_tile.dart';
import 'components/home_header.dart';
import 'components/message_tile.dart';
import 'components/profile_tile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    context.read<ProfileBloc>().pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    context.read<ProfileBloc>().add(ProfileFetch(pageKey: pageKey, query: _searchController.text));
  }

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
      width: AppConstants.desktopScaleWidth,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 150, vertical: 100),
            child: Column(
              children: [
                const HomeHeader(),
                const SizedBox(height: 50),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 65,
                            child: SearchBar(
                              controller: _searchController,
                              leading: const Icon(Icons.search, size: 30),
                              onChanged: (query) => _fetchPage(0),
                              textStyle: WidgetStateProperty.all(GoogleFonts.poppins(fontSize: 21)),
                              padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 30)),
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            height: 800,
                            child: PagedListView<int, Profile>(
                              pagingController: context.read<ProfileBloc>().pagingController,
                              builderDelegate: PagedChildBuilderDelegate<Profile>(
                                itemBuilder: (context, item, index) => ProfileTile(profile: item),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 50),
                        height: 880,
                        width: 600,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 50),
                            Text('ChatBot', style: GoogleFonts.jost(fontSize: 42)),
                            Expanded(
                              child: BlocBuilder<ChatBotBloc, ChatBotState>(
                                buildWhen: (previous, current) => current is ChatbotLoaded,
                                builder: (context, state) {
                                  if (state is ChatbotLoaded) {
                                    return Container(
                                      padding: const EdgeInsets.all(20),
                                      margin: const EdgeInsets.all(50),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 480,
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
                                const SizedBox(width: 20),
                                BlocBuilder<ChatBotBloc, ChatBotState>(
                                  builder: (context, state) {
                                    return SizedBox(
                                      width: 200,
                                      height: 70,
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
                                            Text('Send', style: GoogleFonts.poppins(fontSize: 26)),
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
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    )
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
