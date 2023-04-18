import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_tracker/services/auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _auth = ref.watch(authenticationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.titleHome),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!
                  .hello(_auth.getUsername() ?? '<empty>'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _auth.signOut();
              },
              child: Text(AppLocalizations.of(context)!.logOut),
            ),
          ],
        ),
      ),
    );
  }
}
