import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample/ui/buttons/circular_avatar_button.dart';
import 'package:sample/ui/buttons/favorite_provider_button.dart';
import 'package:sample/ui/views/chat_page.dart';

class ProviderPage extends StatefulWidget {
  const ProviderPage({super.key});

  @override
  State<ProviderPage> createState() => _ProviderPageState();
}

class _ProviderPageState extends State<ProviderPage> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  late Map<String, dynamic> providerData;

  Future<void> waitingProviderData() async{
    await Future.delayed(const Duration(milliseconds: 100), () {});
  }

  Future<void> getProvider() async {
    String providerId = ModalRoute.of(context)!.settings.arguments as String;

    try{
      await db.collection("users").where("id", isEqualTo: providerId).get().then((querySnapshot) async {
        final users = querySnapshot.docs;
        for (var user in users) {
          providerData = {
            "id": user.data()["id"],
            "name": user.data()["name"],
            "email": user.data()["email"],
            "address": user.data()["address"],
            "country": user.data()["country"],
            "department": user.data()["department"],
            "google_scholar": user.data()["google_scholar"],
            "institution": user.data()["institution"],
            "mobile": user.data()["mobile"],
            "orcid": user.data()["orcid"],
            "other": user.data()["other"],
            "webpage": user.data()["webpage"],
          };
        }
      }, onError: (e) {
        debugPrint("Error completing: $e");
      });
    } catch(e) {
      debugPrint('Error in getUser(): $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: const Color.fromARGB(255, 85, 134, 158),
          title: const Text('Sample provider', style: TextStyle(color: Colors.white)),
           iconTheme: const IconThemeData(color: Colors.white),
          
        centerTitle: true,
        actions: const [
          CircularAvatarButton(),
        ],
      ),
      body: FutureBuilder<void>(
        future: getProvider(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text("An error occurred trying to load provider information, try again later.\nSorry 😕"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Back"),
                )
              ],
            );
          }
          else {
            return Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Name",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      Text(providerData["name"] ?? "",
                        style: const TextStyle(
                          fontSize: 16
                        )
                      ),
                      const Divider(),
                      const Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      Text(providerData["email"],
                          style: const TextStyle(
                              fontSize: 16
                          )
                      ),
                      const Divider(),
                      const Text(
                          "Adress",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      Text(providerData["address"],
                          style: const TextStyle(
                              fontSize: 16
                          )
                      ),
                      const Divider(),
                      const Text(
                          "Country",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      Text(providerData["country"],
                          style: const TextStyle(
                              fontSize: 16
                          )
                      ),
                      const Divider(),
                      const Text(
                          "Department",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      Text(providerData["department"],
                          style: const TextStyle(
                              fontSize: 16
                          )
                      ),
                      const Divider(),
                      const Text(
                        "Google scholar",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      Text(providerData["google_scholar"],
                        style: const TextStyle(
                          fontSize: 16
                        )
                      ),
                      const Divider(),
                      const Text(
                          "Institution",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      Text(providerData["institution"],
                          style: const TextStyle(
                              fontSize: 16
                          )
                      ),
                      const Text(
                          "Mobile",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      Text(providerData["mobile"],
                          style: const TextStyle(
                              fontSize: 16
                          )
                      ),
                      const Text(
                          "Orcid",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      Text(providerData["orcid"],
                          style: const TextStyle(
                              fontSize: 16
                          )
                      ),
                      const Text(
                          "Other",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      Text(providerData["other"],
                          style: const TextStyle(
                              fontSize: 16
                          )
                      ),
                      const Text(
                          "Webpage",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      Text(providerData["webpage"],
                          style: const TextStyle(
                              fontSize: 16
                          )
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    receiverUserEmail: providerData["email"],
                                    receiverUserId: providerData["id"],
                                    receiverUserName: providerData["name"],
                                  ),
                                )
                              );
                            },
                            child: const Row(
                              children: [
                                Text("Contact provider "),
                                Icon(Icons.send_sharp)
                              ],
                            )
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FavoriteProviderButton(providerData: providerData),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
