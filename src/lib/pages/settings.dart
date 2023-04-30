import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:plant_tracker/providers/auth.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _auth = ref.watch(authenticationProvider);

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Sign out'),
          onPressed: () async {
            await _auth.signOut();
          },
        ),
      ),
    );
  }
}
