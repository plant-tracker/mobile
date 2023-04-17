import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_tracker/services/auth.dart';

class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _auth = ref.watch(authenticationProvider);
    final ButtonStyle testButtonStyle =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Please, log in!',
            ),
            ElevatedButton(
              style: testButtonStyle,
              onPressed: () async {
                await _auth.signInWithGoogle();
              },
              child: const Text('Log in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
