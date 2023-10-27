import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample/ui/buttons/circular_avatar_button.dart';
import 'package:sample/ui/widgets/custom_drawer.dart';


// Itens do popMenuButton
enum MenuItem { logIn }

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  Map<String, dynamic> user = {};
  String selectedCountry = "Select country";

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController institutionController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController webpageController = TextEditingController();
  TextEditingController orcidController = TextEditingController();
  TextEditingController scholarController = TextEditingController();
  TextEditingController otherController = TextEditingController();

  Future<Map<String, dynamic>> getUser() async {
    Map<String, dynamic> userData = {};
    await db.collection("users")
        .where("id", isEqualTo: auth.currentUser!.uid)
        .get()
        .then((querySnapshot) {
      debugPrint("Successfully completed");
      for (var docSnapshot in querySnapshot.docs) {
        debugPrint('ID: ${docSnapshot.id}; Data:${docSnapshot.data()}');
        userData = docSnapshot.data();
      }
    },
      onError: (e) => debugPrint("Error completing: $e"),
    );
    debugPrint(userData.toString());
    return userData;
  }

  Future<bool> loadUserData() async {
    user = await getUser();
    setState(() {
      nameController.text = user["name"];
      emailController.text = user["email"];
      institutionController.text = user["institution"];
      departmentController.text = user["department"];
      selectedCountry = user["country"];
      addressController.text = user["address"];
      mobileController.text = user["mobile"];
      webpageController.text = user["webpage"];
      orcidController.text = user["orcid"];
      scholarController.text = user["google_scholar"];
      otherController.text = user["other"];
    });
    return true;
  }

  saveUser(Map<String, dynamic> user) async {
    String fileName = auth.currentUser!.uid;

    await db.collection("users").doc(fileName).set(user).then((_) {
      debugPrint("User saved");
      Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
    }
    ).onError((e, _) {
      debugPrint("Error saving user: $e");
    });
  }

  @override
  void initState() {
    loadUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Registration'),
          centerTitle: true,
          actions: const [
            CircularAvatarButton(),
          ],
        ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  label: Text("Name"),
                ),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  label: Text("Email"),
                ),
              ),
              TextField(
                controller: institutionController,
                decoration: const InputDecoration(
                  label: Text("Institution"),
                ),
              ),
              TextField(
                controller: departmentController,
                decoration: const InputDecoration(
                  label: Text("Department"),
                ),
              ),
              ElevatedButton(onPressed: () {
                showCountryPicker(
                  context: context,
                  onSelect: (Country country) {
                    setState(() {
                      selectedCountry = country.name;
                    });
                    debugPrint('Country code: ${country.countryCode}; Phone code: ${country.phoneCode}');
                  },
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(selectedCountry),
                  const Icon(Icons.arrow_drop_down)
                ],
              )
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  label: Text("Full Address"),
                ),
              ),
              TextField(
                controller: mobileController,
                decoration: const InputDecoration(
                  label: Text("Mobile"),
                ),
              ),
              TextField(
                controller: webpageController,
                decoration: const InputDecoration(
                  label: Text("Personal webpage"),
                ),
              ),
              TextField(
                controller: orcidController,
                decoration: const InputDecoration(
                  label: Text("ORCID"),
                ),
              ),
              TextField(
                controller: scholarController,
                decoration: const InputDecoration(
                  label: Text("Google Scholar"),
                ),
              ),
              TextField(
                controller: otherController,
                decoration: const InputDecoration(
                  label: Text("Other database"),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        user = {
                          "id": auth.currentUser!.uid,
                          "name": nameController.text,
                          "email": emailController.text,
                          "institution": institutionController.text,
                          "department": departmentController.text,
                          "country": selectedCountry,
                          "address": addressController.text,
                          "mobile": mobileController.text,
                          "webpage": webpageController.text,
                          "orcid": orcidController.text,
                          "google_scholar": scholarController.text,
                          "other": otherController.text
                        };

                        saveUser(user);
                      },
                      child: const Text("Save")
                    ),
                  ),
                ]
              )
            ],
          ),
        ),
      )
    );
  }
}