import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

import 'package:plant_tracker/providers/auth.dart';

class EmailLoginForm extends ConsumerStatefulWidget {
  const EmailLoginForm({Key? key}) : super(key: key);

  @override
  ConsumerState<EmailLoginForm> createState() {
    return _EmailLoginFormState();
  }
}

class _EmailLoginFormState extends ConsumerState<EmailLoginForm> {
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authenticationProvider);
    final isLoading = ref.watch(isLoginLoadingProvider);

    return FormBuilder(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(
        children: [
          FormBuilderTextField(
            name: 'email',
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.email(),
            ]),
          ),
          const SizedBox(height: 16),
          FormBuilderTextField(
              name: 'password',
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ])),
          const SizedBox(height: 16),
          SocialLoginButton(
            backgroundColor: Colors.teal,
            height: 50,
            text: 'Sign in',
            buttonType: SocialLoginButtonType.generalLogin,
            onPressed: () async {
              if (_formKey.currentState?.saveAndValidate() ?? false) {
                final formData = _formKey.currentState?.value;
                final email = formData!['email'] as String;
                final password = formData!['password'] as String;
                await auth.signInWithEmailAndPassword(email, password);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Validation failed'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Your account will be created automatically.',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w300)),
          ),
        ],
      ),
    );
  }
}
