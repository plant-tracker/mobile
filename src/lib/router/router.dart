import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:plant_tracker/pages/home.dart';
import 'package:plant_tracker/pages/login.dart';
import 'package:plant_tracker/services/auth.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final _authState = ref.watch(authStateProvider);

  return GoRouter(
      initialLocation: '/',
      redirect: (context, state) {
        if (!_authState && state.location != '/login') {
          return '/login';
        } else if (_authState && state.location == '/login') {
          return '/';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => HomePage(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => LoginPage(),
        ),
      ]);
});
