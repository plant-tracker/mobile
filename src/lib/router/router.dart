import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:plant_tracker/pages/pages.dart';
import 'package:plant_tracker/providers/auth.dart';
import 'package:plant_tracker/widgets/navigation_bar.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final _authState = ref.watch(authStateProvider);

  final routeTitleMap = {
    r'^/$': 'Home',
    r'^/settings$': 'Settings',
    r'^/plants/[^/]+/edit$': 'Edit Plant',
    r'^/plants/add$': 'Add Plant',
    r'^/plants/[^/]+$': 'Plant Info',
    r'^/plants$': 'Plants',
    r'^/login$': 'Login'
  };
  
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
      ShellRoute(
         builder: (context, state, child) => Scaffold(
          appBar: AppBar(
            title: Consumer(
              builder: (context, ref, child) {
                final title = routeTitleMap.entries.firstWhere(
                  (entry) => RegExp(entry.key).hasMatch(state.location),
                  orElse: () => MapEntry('', 'Unknown')
                ).value;
                return Text(title);
              },
            ),
          ),
          body: child,
          bottomNavigationBar: NavigationBarMenu(),
        ),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) {
              return HomePage();
            },
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) {
              return SettingsPage();
            },
          ),
          GoRoute(
            path: '/plants',
            builder: (context, state) {
              return PlantsPage();
            },
          ),
          GoRoute(
            path: '/plants/add',
            builder: (context, state) {
              return PlantAddPage();
            },
          ),
          GoRoute(
            path: '/plants/:plantId',
            builder: (context, state) {
              final plantId = state.params['plantId'];
              return PlantDetailsPage(plantId: plantId!);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginPage(),
      ),
    ],
  );
});
