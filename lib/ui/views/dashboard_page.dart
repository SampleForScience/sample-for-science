import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/controllers/dashboard_controller.dart';
import 'package:sample/controllers/login_controller.dart';
import 'package:sample/controllers/settings_controller.dart';
import '../../routes/app_pages.dart';

// Itens do popMenuButton
enum MenuItem { itemOne }

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

            title: const Text('Settings'),
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
                      Get.toNamed(Routes.DASHBOARD);
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
                    Get.toNamed(Routes.SETTINGS);

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

                  title:SizedBox(
                    height: 25,
                    child: Container(color: const Color.fromARGB(100,251,241,219),
                        child: Center(child: Container(
                            decoration:BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ) ,

                            child: const Text('My Samples',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),)))
                    ),
                  ),
                  children: <Widget>[
                    SizedBox(
                      width:500,
                      height:200,
                      child: Column(
                        children: [

                          SizedBox(
                            height:150,
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // Alinhamento vertical superior

                              children: <Widget>[
                                Text(
                                  'Code ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // Negrito
                                  ),
                                ),
                                Text(
                                  'code1',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic, // Itálico
                                  ),
                                ),
                                Text(
                                  'Chemical Formula ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // Negrito
                                  ),
                                ),
                                Text(
                                  'formula1',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic, // Itálico
                                  ),
                                ),
                                Text(
                                  'Registration Date ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // Negrito
                                  ),
                                ),
                                Text(
                                  'date1',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic, // Itálico
                                  ),
                                ),

                              ],
                            )
                            ,
                          ),


                          SizedBox(
                            height:50,

                            child: Container(color: const Color.fromARGB(100,251,241,219),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.delete),
                                  Icon(Icons.remove_red_eye_outlined),
                                  Icon(Icons.edit),
                                ],
                              ),),
                          )],
                      ),
                    ),

                    SizedBox(
                      width:500,
                      height:200,
                      child: Column(
                        children: [

                          SizedBox(
                            height:150,
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // Alinhamento vertical superior

                              children: <Widget>[
                                Text(
                                  'Code ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // Negrito
                                  ),
                                ),
                                Text(
                                  'code2',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic, // Itálico
                                  ),
                                ),
                                Text(
                                  'Chemical Formula ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // Negrito
                                  ),
                                ),
                                Text(
                                  'formula2',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic, // Itálico
                                  ),
                                ),
                                Text(
                                  'Registration Date ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // Negrito
                                  ),
                                ),
                                Text(
                                  'date2',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic, // Itálico
                                  ),
                                ),

                              ],
                            )
                            ,
                          ),


                          SizedBox(
                            height:50,

                            child: Container(color: const Color.fromARGB(100,251,241,219),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.delete),
                                  Icon(Icons.remove_red_eye_outlined),
                                  Icon(Icons.edit),
                                ],
                              ),),
                          )],
                      ),
                    ),

                  ],
                ),//My Sample
                ExpansionTile(

                  title:SizedBox(
                    height: 35,
                    child: Container(color: const Color.fromARGB(100,181,232,196),
                        child: Center(child: Container(
                            decoration:BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ) ,

                            child: const Text('Favorite Sample',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),)))
                    ),
                  ),
                  children: <Widget>[
                    SizedBox(
                      width:500,
                      height:200,
                      child: Column(
                        children: [

                          SizedBox(
                            height:150,
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // Alinhamento vertical superior

                              children: <Widget>[
                                Text(
                                  'Code ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // Negrito
                                  ),
                                ),
                                Text(
                                  'code1',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic, // Itálico
                                  ),
                                ),
                                Text(
                                  'Chemical Formula ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // Negrito
                                  ),
                                ),
                                Text(
                                  'formula1',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic, // Itálico
                                  ),
                                ),
                                Text(
                                  'Registration Date ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // Negrito
                                  ),
                                ),
                                Text(
                                  'date1',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic, // Itálico
                                  ),
                                ),

                              ],
                            )
                            ,
                          ),


                          SizedBox(
                            height:50,

                            child: Container(color: const Color.fromARGB(100,181,232,196),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.delete),
                                  Icon(Icons.remove_red_eye_outlined),
                                  Icon(Icons.chat),
                                ],
                              ),),
                          )],
                      ),
                    ),

                    SizedBox(
                      width:500,
                      height:200,
                      child: Column(
                        children: [

                          SizedBox(
                            height:150,
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // Alinhamento vertical superior

                              children: <Widget>[
                                Text(
                                  'Code ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // Negrito
                                  ),
                                ),
                                Text(
                                  'code2',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic, // Itálico
                                  ),
                                ),
                                Text(
                                  'Chemical Formula ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // Negrito
                                  ),
                                ),
                                Text(
                                  'formula2',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic, // Itálico
                                  ),
                                ),
                                Text(
                                  'Registration Date ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // Negrito
                                  ),
                                ),
                                Text(
                                  'date2',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic, // Itálico
                                  ),
                                ),

                              ],
                            )
                            ,
                          ),


                          SizedBox(
                            height:50,

                            child: Container(color: const Color.fromARGB(100,181,232,196),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.delete),
                                  Icon(Icons.remove_red_eye_outlined),
                                  Icon(Icons.chat),
                                ],
                              ),),
                          )],
                      ),
                    ),

                  ],
                ),
                ExpansionTile(

                  title:SizedBox(
                    height: 25,
                    child: Container(color: const Color.fromARGB(100,200,209,242),
                        child: Center(child: Container(
                            decoration:BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ) ,

                            child: const Text('Favorite Provider',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),)))
                    ),
                  ),
                  children: <Widget>[
                    SizedBox(
                      width:500,
                      height:200,
                      child: Column(
                        children: [

                          SizedBox(
                            height:150,
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // Alinhamento vertical superior

                              children: <Widget>[
                                Text(
                                  'Code ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // Negrito
                                  ),
                                ),
                                Text(
                                  'code1',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic, // Itálico
                                  ),
                                ),
                                Text(
                                  'Chemical Formula ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // Negrito
                                  ),
                                ),
                                Text(
                                  'formula1',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic, // Itálico
                                  ),
                                ),
                                Text(
                                  'Registration Date ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // Negrito
                                  ),
                                ),
                                Text(
                                  'date1',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic, // Itálico
                                  ),
                                ),

                              ],
                            )
                            ,
                          ),


                          SizedBox(
                            height:50,

                            child: Container(color: const Color.fromARGB(100,200,209,242),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(onPressed: () {
                                    debugPrint("Deletar Amostra CLICADO");}, icon: Icon(Icons.delete))
                                  ,
                                  Icon(Icons.remove_red_eye_outlined),
                                  Icon(Icons.chat),
                                ],
                              ),),
                          )],
                      ),
                    ),

                    SizedBox(
                      width:500,
                      height:200,
                      child: Column(
                        children: [

                          SizedBox(
                            height:150,
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // Alinhamento vertical superior

                              children: <Widget>[
                                Text(
                                  'Code ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // Negrito
                                  ),
                                ),
                                Text(
                                  'code2',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic, // Itálico
                                  ),
                                ),
                                Text(
                                  'Chemical Formula ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // Negrito
                                  ),
                                ),
                                Text(
                                  'formula2',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic, // Itálico
                                  ),
                                ),
                                Text(
                                  'Registration Date ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // Negrito
                                  ),
                                ),
                                Text(
                                  'date2',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic, // Itálico
                                  ),
                                ),

                              ],
                            )
                            ,
                          ),


                          SizedBox(
                            height:50,

                            child: Container(color: const Color.fromARGB(100,200,209,242),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.delete),
                                  Icon(Icons.remove_red_eye_outlined),
                                  Icon(Icons.chat),
                                ],
                              ),),
                          )],
                      ),
                    ),

                  ],
                ),//Favorite Sample



              ],
            ),
          ),
        );
      }
    );
  }
}