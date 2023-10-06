import 'package:flutter/material.dart';
import 'package:sample/ui/widgets/circular_avatar_button.dart';
import 'package:sample/ui/widgets/drawer_logout_button.dart';

// Itens do popMenuButton
enum MenuItem { logIn }

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String selectedItem = "Dashboard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: const [
          CircularAvatarButton(),
        ],
      ),
      drawer: Drawer(
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
            Container(
              color: Colors.white,
              child: const SizedBox(
                height: 5,
              ),
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.settings, color: Colors.white70),
                  Text(" Settings", style: TextStyle(color: Colors.white70)),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/registration');
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.info, color: Colors.white70),
                  Text(" Sample.io", style: TextStyle(color: Colors.white70)),
                ],
              ),
              onTap: () {
                debugPrint("Sample.io clicked");
                Navigator.pop(context);
              },
            ),
            const DrawerLogoutButton(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionTile(
              title: const Text('My Samples'),
              children: <Widget>[
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.science),
                      Text(" My samples test item 0"),
                    ],
                  ),
                  onTap: () {
                    debugPrint("My samples test item 0 clicked");
                    // Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.science),
                      Text(" My samples test item 1"),
                    ],
                  ),
                  onTap: () {
                    debugPrint("My samples test item 1 clicked");
                    // Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.science),
                      Text(" My samples test item 2"),
                    ],
                  ),
                  onTap: () {
                    debugPrint("My samples test item 2 clicked");
                    // Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.science),
                      Text(" My samples test item 3"),
                    ],
                  ),
                  onTap: () {
                    debugPrint("My samples test item 3 clicked");
                    // Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.science),
                      Text(" My samples test item 4"),
                    ],
                  ),
                  onTap: () {
                    debugPrint("My samples test item 4 clicked");
                    // Navigator.pop(context);
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Favorite Samples'),
              children: <Widget>[
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.science),
                      Text(" Favorite sample test item 0"),
                    ],
                  ),
                  onTap: () {
                    debugPrint("Favorite sample test item 0 clicked");
                    // Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.science),
                      Text(" Favorite sample test item 1"),
                    ],
                  ),
                  onTap: () {
                    debugPrint("Favorite sample test item 1 clicked");
                    // Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.science),
                      Text(" Favorite sample test item 2"),
                    ],
                  ),
                  onTap: () {
                    debugPrint("Favorite sample test item 2 clicked");
                    // Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.science),
                      Text(" Favorite sample test item 3"),
                    ],
                  ),
                  onTap: () {
                    debugPrint("Favorite sample test item 3 clicked");
                    // Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.science),
                      Text(" Favorite sample test item 4"),
                    ],
                  ),
                  onTap: () {
                    debugPrint("Favorite sample test item 4 clicked");
                    // Navigator.pop(context);
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Favorite Provider'),
              children: <Widget>[
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.science),
                      Text(" Favorite provider test item 0"),
                    ],
                  ),
                  onTap: () {
                    debugPrint("Favorite provider test item 0 clicked");
                    // Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.science),
                      Text(" Favorite provider test item 1"),
                    ],
                  ),
                  onTap: () {
                    debugPrint("Favorite provider test item 1 clicked");
                    // Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.science),
                      Text(" Favorite provider test item 2"),
                    ],
                  ),
                  onTap: () {
                    debugPrint("Favorite provider test item 2 clicked");
                    // Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.science),
                      Text(" Favorite provider test item 3"),
                    ],
                  ),
                  onTap: () {
                    debugPrint("Favorite provider test item 3 clicked");
                    // Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.science),
                      Text(" Favorite provider test item 4"),
                    ],
                  ),
                  onTap: () {
                    debugPrint("Favorite provider test item 4 clicked");
                    // Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
