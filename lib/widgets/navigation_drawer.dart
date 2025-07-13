import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );

  //so that it is correctly aligned
  Widget buildHeader(BuildContext context) => Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top));
  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        child: const Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              //onTap: () {}, //TODO
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text("Groups"),
              //onTap: () {}, //TODO
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              //onTap: () {}, //TODO
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text("Log In"),
              //onTap: () {}, //TODO
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Log Out"),
              //onTap: () {}, //TODO
            ),
          ],
        ),
      );
}
