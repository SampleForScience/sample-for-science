import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sample/ui/buttons/circular_avatar_button.dart';
import 'package:sample/ui/buttons/favorite_sample_button.dart';
import 'package:sample/ui/views/chat_page.dart';

class SamplePage extends StatefulWidget {
  const SamplePage({super.key});

  @override
  State<SamplePage> createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  final db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final auth = FirebaseAuth.instance;
  late Map<String, dynamic> providerData;
  late Map<String, dynamic> sampleData; // TODO: iniciar com valores padrão para não dar erro quando a amostra não carregar
  Uint8List? imageBytes;

  Future<void> waitingSampleData() async {
    await Future.delayed(const Duration(milliseconds: 500), () {});
  }

  Future<void> loadSampleImage(String imageName) async {
    if (imageName != "") {
      imageBytes = await storage.ref().child(imageName).getData();
    }
    setState(() {
      imageBytes;
    });
  }

  Future<void> getProvider() async {
    sampleData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    try{
      await db.collection("users").where("id", isEqualTo: sampleData["provider"]).get().then((querySnapshot) async {
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
    } catch (e) {
      debugPrint('Error in getUser(): $e');
    }
  }

  String formatDateWithUserTimezone(DateTime dateTime) {
    final formatter = DateFormat('MM/dd/yyyy HH:mm', Intl.getCurrentLocale());
    return formatter.format(dateTime.toLocal());
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Map<String, dynamic> sampleData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      loadSampleImage(sampleData["image"]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 85, 134, 158),
        title: const Text("Sample", style: TextStyle(color: Colors.white)),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Code:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                              sampleData["code"],
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Number of samples: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(sampleData["number"],
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Formula: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(sampleData["formula"],
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          const Text("Type: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(sampleData["type"],
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          const Text("Morfology: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(sampleData["morphology"],
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Keywords: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(sampleData["keywords"],
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Previous diffraction measurements: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(sampleData["previousDiffraction"],
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Previous thermal measurements: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(sampleData["previousThermal"],
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Previous optical measurements: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(sampleData["previousOptical"],
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const Divider(),
                     Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Other previous measurements: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(sampleData["otherPrevious"],
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("DOI: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(sampleData["doi"],
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Suggestion of diffraction measurements: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(sampleData["suggestionDiffraction"],
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Suggestion of thermal measurements: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(sampleData["suggestionThermal"],
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Suggestion of optical measurements: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(sampleData["suggestionOptical"],
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Other Suggestions: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(sampleData["otherSuggestions"],
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          const Text("Hazardous: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(sampleData["hazardous"].toString(),
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          const Text("Animals: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(sampleData["animals"].toString(),
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          const Text("Registration: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(
                              formatDateWithUserTimezone(
                                  sampleData["registration"].toDate()),
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      if (imageBytes != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                  image: MemoryImage(imageBytes!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              width: 100,
                              height: 100,
                            ),
                          ],
                        ),
                      const Divider(),
                      const Text("Provider",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(
                          "Name: ${providerData['name']}\nEmail: ${providerData['email']}",
                          style: const TextStyle(fontSize: 16)),


                      if (auth.currentUser!.uid == providerData["id"])Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                "/update-sample",
                                arguments: sampleData,
                              );
                            },
                            child: const Row(
                              children: [
                                Text("Edit Sample "),
                                Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),



                      if (auth.currentUser!.uid != providerData["id"])
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, "/provider", arguments: providerData,);
                                    },
                                    child: const SizedBox(
                                        width: 120,
                                        child: Center(child: Text("See Provider"))
                                    )
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, "/provider", arguments: providerData,);
                                    },
                                    child: const SizedBox(
                                        width: 120,
                                        child: Center(child: Text("Contact Provider"))
                                    )
                                ),
                                FavoriteSampleButton(sampleData: sampleData),
                              ],
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
