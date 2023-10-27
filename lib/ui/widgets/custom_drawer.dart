import 'package:flutter/material.dart';
import 'package:sample/ui/buttons/drawer_logout_button.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 200,
      backgroundColor: const Color.fromARGB(255, 55, 98, 118),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 245, 252, 255),
            ),
            child: Image(image: AssetImage("assets/logo.png")),
          ),
          Container(
            color: const Color.fromARGB(255, 245, 252, 255),
            child: ListTile(
              title: const Row(
                children: [
                  Icon(Icons.apps),
                  Text(" Dashboard"),
                ],
              ),
              onTap: () {
                debugPrint("Dashboard clicked");
                Navigator.pop(context);
                Navigator.of(context).pushNamedAndRemoveUntil("/dashboard", (route) => false);
              },
            ),
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.add, color: Colors.white70),
                Text(" Provide sample", style: TextStyle(color: Colors.white70)),
              ],
            ),
            onTap: () {
              debugPrint("Provide sample clicked");
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/new-sample');
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.search, color: Colors.white70),
                Text(" Search", style: TextStyle(color: Colors.white70)),
              ],
            ),
            onTap: () {
              debugPrint("Search clicked");
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/search');
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.messenger_outline_sharp, color: Colors.white70),
                Text(" Messages", style: TextStyle(color: Colors.white70)),
              ],
            ),
            onTap: () {
              debugPrint("Messages clicked");
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.info, color: Colors.white70),
                Text(" About", style: TextStyle(color: Colors.white70)),
              ],
            ),
            onTap: () {
              debugPrint("About clicked");
              Navigator.pop(context);
            },
          ),
          const DrawerLogoutButton(),
        ],
      ),
    );
  }
}
