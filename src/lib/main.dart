import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/navigation.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Home",
      initialRoute: '/',
      routes: NavigationService.routes,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
    );
  }
}


