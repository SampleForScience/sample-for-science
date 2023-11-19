import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/providers/favorite_provider.dart';
import 'package:sample/ui/buttons/circular_avatar_button.dart';
import 'package:sample/ui/views/chat_page.dart';

class ProviderPage extends StatefulWidget {
  const ProviderPage({super.key});

  @override
  State<ProviderPage> createState() => _ProviderPageState();
}

class _ProviderPageState extends State<ProviderPage> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  late Map<String, dynamic> providerId;
  late Map<String, dynamic> providerData;

  Future<void> waitingProviderData() async{
    await Future.delayed(const Duration(milliseconds: 500), () {});
  }

  Future<void> getProvider(String provider) async {
    try{
      await db.collection("users").where("id", isEqualTo: provider).get().then((querySnapshot) async {
        final users = querySnapshot.docs;
        for (var user in users) {
          setState(() {
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
          });
        }
      }, onError: (e) {
        debugPrint("Error completing: $e");
      });
    } catch(e) {
      debugPrint('Error in getUser(): $e');
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      setState(() {
        providerId = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      });
      getProvider(providerId["id"]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample provider'),
        centerTitle: true,
        actions: const [
          CircularAvatarButton(),
        ],
      ),
      body: FutureBuilder<void>(
        future: waitingProviderData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Loading Sample",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
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
                      Text(providerData["name"],
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
                          Consumer<FavoriteProvider>(
                            builder: (context, provider, child) {
                              return ElevatedButton(
                                onPressed: () {
                                  provider.addRemoveFavoriteProvider({
                                    "id": providerData["id"],
                                    "name": providerData["name"],
                                    "email": providerData["email"],
                                  }, context);
                                  debugPrint({
                                    "id": providerData["id"],
                                    "name": providerData["name"],
                                    "email": providerData["email"],
                                  }.toString());
                                },
                                child: const Row(
                                  children: [
                                    Text("Favorite provider "),
                                    Icon(Icons.star)
                                  ],
                                )
                              );
                            },
                          )
                        ],
                      ),
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
