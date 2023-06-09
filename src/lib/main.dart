import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:plant_tracker/router/router.dart';
import 'package:plant_tracker/providers/locale.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocaleService locale = ref.watch(localeProvider);
    GoRouter router = ref.watch(routerProvider);

    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.tealAccent,
        brightness: Brightness.dark,
      ),
      localizationsDelegates: locale.delegates,
      supportedLocales: locale.supportedLocales,
    );
  }
}
