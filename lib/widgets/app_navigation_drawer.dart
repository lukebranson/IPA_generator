import 'package:flutter/material.dart';
import 'package:slp_notebook/pages/about_page.dart';
import 'package:slp_notebook/pages/home_page.dart';

class AppNavigationDrawer extends StatefulWidget {
  const AppNavigationDrawer({super.key});

  @override
  State<AppNavigationDrawer> createState() => _AppNavigationDrawerState();
}

class _AppNavigationDrawerState extends State<AppNavigationDrawer> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: const Text(
                'SLP Notebook',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Clients'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const HomePage();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload),
              title: const Text('Import/Export'),
              onTap: () {
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const AboutPage(title: 'About');
                }));
              },
            ),
          ],
        ),
      );
  }
}
