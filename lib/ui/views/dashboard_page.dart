import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/controllers/dashboard_controller.dart';
import 'package:sample/controllers/login_controller.dart';
import 'package:sample/routes/app_pages.dart';

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
    return GetBuilder<DashboardController>(
      init: Get.put(DashboardController()),
      builder: (homeController) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard'),
            centerTitle: true,
            actions: [
              GetBuilder<LoginController>(
                init: Get.put(LoginController()),
                builder: (loginController) {
                  return  PopupMenuButton<MenuItem>(
                    onSelected: (MenuItem item) {
                      if (item == MenuItem.logIn) {
                        loginController.signInWithGoogle();
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItem>>[
                      PopupMenuItem<MenuItem>(
                        value: MenuItem.logIn,
                        child: loginController.auth.currentUser != null
                          ? const Text("Sair")
                          : const Text("Entrar"),
                      ),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: loginController.auth.currentUser != null
                        ? CircleAvatar(
                          backgroundImage: NetworkImage(
                            loginController.auth.currentUser!.photoURL!,
                          ),
                        )
                        : IconButton(
                          onPressed: null,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0),),),
                          ),
                          icon: const Icon(
                            Icons.person_rounded, color: Colors.white,),
                        ),
                    )
                  );
                }
              ),
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
                    Get.toNamed(Routes.REGISTRATION);
                    // Navigator.pop(context);
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
                GetBuilder<LoginController>(
                  init: Get.put(LoginController()),
                  builder: (loginController) {
                  return ListTile(
                    title: Row(
                      children: [
                        SizedBox(
                            width: 140,
                            child: Text(loginController.auth.currentUser!.displayName!,
                              style: const TextStyle(color: Colors.white70)
                            ),
                        ),
                        const Icon(Icons.exit_to_app, color: Colors.white70),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Future.delayed(const Duration(seconds: 1), () {
                        loginController.signInWithGoogle();
                      });
                    },
                  );
                }),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ExpansionTile(
                  title: Text('My Samples'),
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
                  title: Text('Favorite Samples'),
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
                  title: Text('Favorite Provider'),
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
    );
  }
}
