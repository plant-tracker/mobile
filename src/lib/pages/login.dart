import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_tracker/services/auth.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            Text(
              AppLocalizations.of(context)!.signIn,
            ),
            const SizedBox(height: 10),
            SocialLoginButton(
              buttonType: SocialLoginButtonType.google,
              text: AppLocalizations.of(context)!.signInProvider("Google"),
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
