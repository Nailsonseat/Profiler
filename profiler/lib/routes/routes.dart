import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/home/home.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => const MaterialPage<void>(
        child: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    ),
  ],
);
