import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_tracker/services/auth.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _auth = ref.watch(authenticationProvider);

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Image(
              image: AssetImage('assets/icons/logo.png'),
              width: 150,
            ),
            const Text(
              'Please, log in!',
            ),
            const SizedBox(height: 10),
            SocialLoginButton(
              buttonType: SocialLoginButtonType.google,
              onPressed: () async {
                await _auth.signInWithGoogle();
              },
            ),
          ],
        ),
      ),
    ));
  }
}
