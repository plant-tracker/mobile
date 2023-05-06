import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:plant_tracker/providers/auth.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authenticationProvider);

    return Center(
      child: ElevatedButton(
        child: const Text('Sign out'),
        onPressed: () async {
          await auth.signOut();
        },
      ),
    );
  }
}
