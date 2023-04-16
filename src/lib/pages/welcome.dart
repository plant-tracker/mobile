import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  Widget build(BuildContext context) {
    final ButtonStyle testButtonStyle =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome!',
            ),
            ElevatedButton(
              style: testButtonStyle,
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              child: const Text('Go to home'),
            ),
          ],
        ),
      ),
    );
  }
}
