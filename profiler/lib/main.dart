import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profiler/api/funny_description.dart';
import 'package:profiler/bloc/funny_description/funny_description_bloc.dart';
import 'package:profiler/routes/routes.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'api/chatbot.dart';
import 'api/profile.dart';
import 'bloc/chatbot/chatbot_bloc.dart';
import 'bloc/profile/profile_bloc.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Profiler());
}

class Profiler extends StatelessWidget {
  const Profiler({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProfileApi>(create: (context) => ProfileApi()),
        RepositoryProvider<ChatBotApi>(create: (context) => ChatBotApi()),
        RepositoryProvider<FunnyDescriptionApi>(create: (context) => FunnyDescriptionApi()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc(
              profileApi: RepositoryProvider.of<ProfileApi>(context),
            ),
          ),
          BlocProvider<ChatBotBloc>(
            create: (context) => ChatBotBloc(
              chatBotApi: RepositoryProvider.of<ChatBotApi>(context),
            ),
          ),
          BlocProvider<FunnyDescriptionBloc>(
            create: (context) => FunnyDescriptionBloc(
              funnyDescriptionApi: RepositoryProvider.of<FunnyDescriptionApi>(context),
            ),
          ),
        ],
        child: MaterialApp.router(
          title: 'Profiler',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.purpleAccent),
            useMaterial3: true,
          ),
          routerConfig: router,
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: ClampingScrollWrapper(child: child!),
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 1024, name: TABLET),
              const Breakpoint(start: 1025, end: double.infinity, name: DESKTOP),
            ],
          ),
        ),
      ),
    );
  }
}
