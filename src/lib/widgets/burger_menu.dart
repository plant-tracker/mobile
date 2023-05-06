import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BurgerMenu extends StatelessWidget {
  const BurgerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        children: [
          const SizedBox(height: 16),
          _DrawerSection(
            title: 'Pages',
            children: [
              _DrawerMenuItem(
                icon: Icons.home,
                title: 'Home',
                onTap: () {
                  Navigator.pop(context);
                  context.go('/');
                },
              ),
              _DrawerMenuItem(
                icon: Icons.local_florist,
                title: 'Plants',
                onTap: () {
                  Navigator.pop(context);
                  context.go('/plants');
                },
              ),
              _DrawerMenuItem(
                icon: Icons.settings,
                title: 'Settings',
                onTap: () {
                  Navigator.pop(context);
                  context.go('/settings');
                },
              ),
            ],
          ),
          const Divider(),
          _DrawerSection(
            title: 'Actions',
            children: [
              _DrawerMenuItem(
                icon: Icons.add,
                title: 'Add plant',
                onTap: () {
                  Navigator.pop(context);
                  context.go('/plants/add');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DrawerSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _DrawerSection({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        ...children,
      ],
    );
  }
}

class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DrawerMenuItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
