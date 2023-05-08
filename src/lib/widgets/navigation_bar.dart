import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navbarProvider = StateProvider.autoDispose<int>((_) => 0);

class NavigationBarMenu extends ConsumerWidget {
  const NavigationBarMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navbarIndex = ref.watch(navbarProvider.notifier).state;

    return BottomNavigationBar(
      backgroundColor: Theme.of(context).cardColor,
      currentIndex: navbarIndex,
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
      items: const [
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
