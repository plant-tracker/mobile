import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:plant_tracker/providers/auth.dart';

final navbarProvider = StateProvider<int>((_) => 0);

class NavigationBarMenu extends ConsumerWidget {
  const NavigationBarMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _navbarIndex = ref.watch(navbarProvider.notifier).state;

    return BottomNavigationBar(
      currentIndex: _navbarIndex,
      onTap: (int index) {
        ref.read(navbarProvider.notifier).state = index;
        switch (index) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.go('/plants');
            break;
          case 2:
            context.go('/settings');
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.grass),
          label: 'Plants',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
