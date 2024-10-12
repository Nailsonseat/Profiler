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
import 'components/chatbot_dialog.dart';
import 'components/message_tile.dart';
import 'components/profile_add_dialog.dart';
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
    bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return ResponsiveScaledBox(
      width: ResponsiveValue<double?>(context, conditionalValues: [
        const Condition.smallerThan(name: TABLET, value: AppConstants.mobileScaleWidth),
        const Condition.largerThan(name: MOBILE, value: AppConstants.tabletScaleWidth),
        const Condition.equals(name: DESKTOP, value: AppConstants.desktopScaleWidth),
        const Condition.largerThan(name: DESKTOP, value: AppConstants.desktopScaleWidth),
      ]).value,
      child: Scaffold(
        floatingActionButton: ResponsiveVisibility(
          hiddenConditions: const [
            Condition.equals(name: DESKTOP),
            Condition.largerThan(name: TABLET),
          ],
          child: Container(
            margin: const EdgeInsets.only(bottom: 20, right: 20),
            child: SizedBox(
              height: 70,
              width: 180,
              child: FloatingActionButton.extended(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => ChatbotDialog(),
                ),
                label: Row(
                  children: [
                    Text('ChatBot', style: GoogleFonts.poppins(fontSize: 21)),
                    const SizedBox(width: 10),
                    const Icon(Icons.chat, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: ResponsiveValue<EdgeInsets?>(context, conditionalValues: [
              const Condition.largerThan(breakpoint: 0, value: EdgeInsets.symmetric(horizontal: 20, vertical: 20)),
              const Condition.largerThan(name: MOBILE, value: EdgeInsets.symmetric(horizontal: 100, vertical: 100)),
            ]).value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profiles',
                  style: GoogleFonts.poppins(
                    fontSize: ResponsiveValue<double?>(context, conditionalValues: [
                      const Condition.largerThan(name: TABLET, value: 120.0),
                      const Condition.equals(name: TABLET, value: 80.0),
                      const Condition.smallerThan(name: TABLET, value: 88.0),
                    ]).value,
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 70,
                            child: SearchBar(
                              controller: _searchController,
                              leading: const Icon(Icons.search, size: 30),
                              onChanged: (query) => _fetchPage(0),
                              textStyle: WidgetStateProperty.all(GoogleFonts.poppins(fontSize: 21)),
                              padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 30)),
                            ),
                          ),
                          const SizedBox(height: 30),
                          BlocBuilder<ProfileBloc, ProfileState>(
                            builder: (context, state) {
                              return SizedBox(
                                height: 70,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: FilledButton.tonal(
                                    onPressed: (state is ProfileLoading)
                                        ? () {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Profiles are being loaded. Please wait...'),
                                              ),
                                            );
                                          }
                                        : () => showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) => ProfileAddDialog(),
                                            ),
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all(Colors.purpleAccent[50]),
                                      shape: WidgetStateProperty.all(
                                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.add, size: 30),
                                        Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            Text('Add Profile', style: GoogleFonts.poppins(fontSize: 26)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            height: MediaQuery.of(context).size.height,
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
                    ResponsiveVisibility(
                      hiddenConditions: const [
                        Condition.smallerThan(name: DESKTOP),
                      ],
                      child: Expanded(
                        flex: 2,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 50),
                          height: 900,
                          width: 600,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ResponsiveRowColumn(
                            layout: ResponsiveRowColumnType.COLUMN,
                            columnMainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ResponsiveRowColumnItem(child: Text('ChatBot', style: GoogleFonts.jost(fontSize: 42))),
                              ResponsiveRowColumnItem(
                                child: SizedBox(
                                  height: 650,
                                  width: 850,
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
                              ),
                              ResponsiveRowColumnItem(
                                child: ResponsiveRowColumn(
                                  layout: ResponsiveRowColumnType.ROW,
                                  rowMainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ResponsiveRowColumnItem(
                                      child: SizedBox(
                                        width: 530,
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
                                    ),
                                    ResponsiveRowColumnItem(child: const SizedBox(width: 20)),
                                    ResponsiveRowColumnItem(
                                      child: BlocBuilder<ChatBotBloc, ChatBotState>(
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
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
