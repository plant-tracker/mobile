import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final pageIndexProvider = StateProvider<int>(
  (ref) => 0,
);

class NavigationWidget extends ConsumerStatefulWidget {
  const NavigationWidget({Key? key}) : super(key: key);

  @override
  NavigationWidgetState createState() => NavigationWidgetState();
}

class NavigationWidgetState extends ConsumerState<NavigationWidget> {
  void _onItemTapped(int index) {
    setState(() {
      ref.read(pageIndexProvider.notifier).state = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ref.read(pageIndexProvider.notifier).state = 0;
    });

    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_florist),
          label: 'Plants',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: ref.read(pageIndexProvider.notifier).state,
      onTap: _onItemTapped,
    );
  }
}
