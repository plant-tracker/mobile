import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:plant_tracker/providers/auth.dart';
import 'package:plant_tracker/widgets/email_login.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authenticationProvider);
    final isLoading = ref.watch(isLoginLoadingProvider);

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
              isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        EmailLoginForm(),
                        Divider(
                          thickness: 2,
                          indent: 50,
                          endIndent: 50,
                        ),
                        Text(
                          "Or",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Divider(
                          thickness: 2,
                          indent: 50,
                          endIndent: 50,
                        ),
                        const SizedBox(height: 16),
                        SocialLoginButton(
                          buttonType: SocialLoginButtonType.google,
                          text: AppLocalizations.of(context)!
                              .signInProvider("Google"),
                          onPressed: () async {
                            await auth.signInWithGoogle();
                          },
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
