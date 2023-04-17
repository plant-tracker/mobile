import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_tracker/services/auth.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _auth = ref.watch(authenticationProvider);
    final ButtonStyle testButtonStyle =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _auth.getUsername() ?? '<empty>',
            ),
            const Text(
              'You are logged in!',
            ),
            ElevatedButton(
              style: testButtonStyle,
              onPressed: () async {
                await _auth.signOut();
              },
              child: const Text('Log out!'),
            ),
          ],
        ),
      ),
    );
  }
}
