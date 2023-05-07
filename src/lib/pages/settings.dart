import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_tracker/providers/auth.dart';
import 'package:package_info/package_info.dart';
import 'package:android_intent/android_intent.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authenticationProvider);

    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final appVersion = snapshot.data!.version;
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            _buildCategory(
              context,
              'Actions',
              <Widget>[
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Sign Out'),
                  onTap: () async {
                    await auth.signOut();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete Account'),
                  onTap: () {},
                ),
              ],
            ),
            const Divider(),
            _buildCategory(
              context,
              'External',
              <Widget>[
                ListTile(
                  leading: const Icon(Icons.code),
                  title: const Text('View Source Code'),
                  onTap: () async {
                    final intent = AndroidIntent(
                      action: 'action_view',
                      data: 'https://github.com/plant-tracker/mobile',
                    );
                    intent.launch();
                  },
                ),
              ],
            ),
            const Divider(),
            Card(
              child: ExpansionTile(
                title: const Text('Info'),
                children: <Widget>[
                  Container(
                    child: ListTile(
                      title: const Text('App Version'),
                      trailing: Text(appVersion),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategory(
      BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        const SizedBox(height: 8.0),
        ...items,
      ],
    );
  }
}
