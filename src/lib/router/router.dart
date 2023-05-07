import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:plant_tracker/pages/pages.dart';
import 'package:plant_tracker/providers/auth.dart';
import 'package:plant_tracker/widgets/navigation_bar.dart';
import 'package:plant_tracker/widgets/burger_menu.dart';

class RouteInfo {
  final IconData icon;
  final String title;

  const RouteInfo({required this.icon, required this.title});
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  final routeTitleMap = {
    r'^/$': RouteInfo(icon: Icons.home, title: 'Home'),
    r'^/settings$': RouteInfo(icon: Icons.settings, title: 'Settings'),
    r'^/plants/[^/]+/edit$': RouteInfo(icon: Icons.edit, title: 'Edit Plant'),
    r'^/plants/add$': RouteInfo(icon: Icons.grass, title: 'Add Plant'),
    r'^/plants/[^/]+$': RouteInfo(icon: Icons.info, title: 'Plant Info'),
    r'^/plants$': RouteInfo(icon: Icons.grass, title: 'Plants'),
    r'^/login$': RouteInfo(icon: Icons.login, title: 'Login')
  };

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (!authState && state.location != '/login') {
        return '/login';
      } else if (authState && state.location == '/login') {
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
                final routeInfo = routeTitleMap.entries.firstWhere(
                    (entry) => RegExp(entry.key).hasMatch(state.location),
                    orElse: () => MapEntry(
                        '', RouteInfo(icon: Icons.error, title: 'Unknown')));
                final title = routeInfo.value.title;
                final icon = routeInfo.value.icon;
                return Row(
                  children: [
                    Icon(icon),
                    SizedBox(width: 8),
                    Text(title),
                  ],
                );
              },
            ),
          ),
          drawer: BurgerMenu(),
          body: child,
          bottomNavigationBar: const NavigationBarMenu(),
        ),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) {
              return const HomePage();
            },
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) {
              return const SettingsPage();
            },
          ),
          GoRoute(
            path: '/plants',
            builder: (context, state) {
              return const PlantsPage();
            },
          ),
          GoRoute(
            path: '/plants/add',
            builder: (context, state) {
              return const PlantAddPage();
            },
          ),
          GoRoute(
            path: '/plants/:plantId',
            builder: (context, state) {
              final plantId = state.params['plantId'];
              return PlantDetailsPage(plantId: plantId!);
            },
          ),
          GoRoute(
            path: '/plants/:plantId/edit',
            builder: (context, state) {
              final plantId = state.params['plantId'];
              return PlantEditPage(plantId: plantId!);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
    ],
  );
});
