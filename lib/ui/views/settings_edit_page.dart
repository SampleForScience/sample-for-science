import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/controllers/login_controller.dart';
import 'package:sample/controllers/settings_controller.dart';
import '../../routes/app_pages.dart';

enum MenuItem { itemOne }

class SettingsEditPage extends StatefulWidget {
  const SettingsEditPage({Key? key}) : super(key: key);

  @override
  State<SettingsEditPage> createState() => _SettingsEditPageState();
}

class _SettingsEditPageState extends State<SettingsEditPage> {
  String selectedItem = "Settings";

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
        init: Get.put(SettingsController()),
        builder: (homeController) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Settings(EDIT)'),
              centerTitle: true,
              actions: [
                GetBuilder<LoginController>(
                    init: Get.put(LoginController()),
                    builder: (loginController) {
                      return  PopupMenuButton<MenuItem>(
                          onSelected: (MenuItem item) {
                            if (item == MenuItem.itemOne) {
                              loginController.signInWithGoogle();
                            }
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItem>>[
                            PopupMenuItem<MenuItem>(
                              value: MenuItem.itemOne,
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
                        Get.toNamed(Routes.SETTINGS);
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
                      debugPrint("Settings clicked");
                      Navigator.pop(context);

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          color: Color.fromARGB(100,180,232,199),
                          width: double.infinity,
                          child: Text("Registration",
                              style: TextStyle(fontSize: 30, color: Colors.white))

                      ),
                      Text("User"),
                      Text("Country"),
                      Text("Email"),
                      Text("Institution",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 128))),
                      Text("institution"),
                      Text("Departament",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 128))),
                      Text("departamento"),
                      Text("Full Adress*",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 128))),
                      Text("Adress"),
                      Text("Mobile",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 128))),
                      Text("mobile"),
                      Container(
                        color: Color.fromARGB(100,180,232,199),
                        width: double.infinity,
                        height: 16,

                      ),
                      Text("Personal webpage",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 128))),
                      Text("personal webpage"),
                      Text("ORCID",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 128))),
                      Text("ORCID"),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(100,180,232,199), // Cor de fundo verde
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0), // Define o raio das bordas
                            ),
                          ),
                          onPressed: (){
                            Navigator.of(context).pushNamed(Routes.SETTINGS);

                          },
                          child: const SizedBox(
                            height: 20,
                            width: 50,
                            child:
                            Center(
                              child: Text("Edit",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,

                                  )
                              ),
                            ),


                          ),
                        ),
                      ),
                      Text("Google Scholar",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 128))),
                      Text("Google Scholar"),

                      Text("Other database",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 128))),
                      Text("Other database"),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(100,180,232,199), // Cor de fundo verde
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0), // Define o raio das bordas
                            ),
                          ),
                          onPressed: (){
                            Navigator.of(context).pushNamed(Routes.SETTINGS);

                          },
                          child: const SizedBox(
                            height: 20,
                            width: 50,
                            child:
                            Center(
                              child: Text("Edit",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,

                                  )
                              ),
                            ),


                          ),
                        ),
                      )




                    ]
                )
            ),

          );
        }
    );
  }
}
