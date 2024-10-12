import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profiler/bloc/profile/profile_bloc.dart';
import 'package:profiler/bloc/chatbot/chatbot_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../constants/constants.dart';
import 'components/animated_message_tile.dart';
import 'components/chatbot_dialog.dart';
import 'components/chatbot_input.dart';
import 'components/message_tile.dart';
import 'components/profile_add_dialog.dart';
import 'components/profile_search.dart';
import 'components/profile_list.dart';

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
      width: _getResponsiveWidth(context),
      child: Scaffold(
        floatingActionButton: _buildFloatingChatButton(context),
        body: SingleChildScrollView(
          child: Container(
            margin: _getResponsiveMargin(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 50),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileSection(),
                    _buildChatSection(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double? _getResponsiveWidth(BuildContext context) {
    return ResponsiveValue<double?>(context, conditionalValues: [
      const Condition.smallerThan(name: TABLET, value: AppConstants.mobileScaleWidth),
      const Condition.largerThan(name: MOBILE, value: AppConstants.tabletScaleWidth),
      const Condition.equals(name: DESKTOP, value: AppConstants.desktopScaleWidth),
      const Condition.largerThan(name: DESKTOP, value: AppConstants.desktopScaleWidth),
    ]).value;
  }

  EdgeInsets? _getResponsiveMargin(BuildContext context) {
    return ResponsiveValue<EdgeInsets?>(context, conditionalValues: [
      const Condition.largerThan(breakpoint: 0, value: EdgeInsets.symmetric(horizontal: 20, vertical: 20)),
      const Condition.largerThan(name: MOBILE, value: EdgeInsets.symmetric(horizontal: 100, vertical: 100)),
    ]).value;
  }

  Widget _buildHeader() {
    return Text(
      'Profiles',
      style: GoogleFonts.poppins(
        fontSize: ResponsiveValue<double?>(context, conditionalValues: [
          const Condition.largerThan(name: TABLET, value: 120.0),
          const Condition.equals(name: TABLET, value: 80.0),
          const Condition.smallerThan(name: TABLET, value: 88.0),
        ]).value,
      ),
    );
  }

  Widget _buildProfileSection() {
    return Expanded(
      flex: 3,
      child: Column(
        children: [
          ProfileSearch(controller: _searchController, onSearch: _fetchPage),
          const SizedBox(height: 30),
          ResponsiveVisibility(
            hiddenConditions: const [Condition.largerThan(name: TABLET)],
            child: _buildAddProfileButton(),
          ),
          const SizedBox(height: 30),
          const ProfileList(),
        ],
      ),
    );
  }

  Widget _buildAddProfileButton() {
    return BlocBuilder<ProfileBloc, ProfileState>(
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
                shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add, size: 30),
                  const SizedBox(width: 10),
                  Text('Add Profile', style: GoogleFonts.poppins(fontSize: 26)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChatSection(BuildContext context) {
    return ResponsiveVisibility(
      hiddenConditions: const [Condition.smallerThan(name: DESKTOP)],
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text('ChatBot', style: GoogleFonts.jost(fontSize: 42)),
              Expanded(
                child: BlocBuilder<ChatBotBloc, ChatBotState>(
                  buildWhen: (previous, current) => current is ChatbotLoaded,
                  builder: (context, state) {
                    if (state is ChatbotLoaded) {
                      return _buildChatMessages(state);
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              ChatInput(controller: _messageController, onSend: _sendMessage),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatMessages(ChatbotLoaded state) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
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

  Widget? _buildFloatingChatButton(BuildContext context) {
    return ResponsiveValue<Widget?>(
      context,
      defaultValue: null,
      conditionalValues: [
        Condition.largerThan(
          name: TABLET,
          value: Container(
            margin: const EdgeInsets.only(bottom: 20, right: 20),
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                return FloatingActionButton.extended(
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
                  label: Row(
                    children: [
                      const Icon(Icons.add, size: 20),
                      const SizedBox(width: 10),
                      Text('Add Profile', style: GoogleFonts.poppins(fontSize: 21)),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Condition.smallerThan(
          name: DESKTOP,
          value: Container(
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
      ],
    ).value;
  }
}
