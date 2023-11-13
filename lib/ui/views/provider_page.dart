import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sample/ui/buttons/circular_avatar_button.dart';

class ProviderPage extends StatefulWidget {
  const ProviderPage({super.key});

  @override
  State<ProviderPage> createState() => _ProviderPageState();
}

class _ProviderPageState extends State<ProviderPage> {
  final db = FirebaseFirestore.instance;
  late Map<String, dynamic> providerData;

  Future<void> waitingProviderData() async{
    await Future.delayed(const Duration(milliseconds: 1000), () {});
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      setState(() {
        providerData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample'),
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
                              debugPrint("Send message");
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
                          ElevatedButton(
                            onPressed: () {
                              debugPrint("Favorite provider");
                            },
                            child: const Row(
                              children: [
                                Text("Favorite provider "),
                                Icon(Icons.star)
                              ],
                            )
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
