import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sample/ui/buttons/circular_avatar_button.dart';
import 'package:sample/ui/buttons/favorite_provider_button.dart';
import 'package:sample/ui/buttons/favorite_sample_button.dart';
import 'package:sample/ui/widgets/custom_drawer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  bool searching = false;
  List<Map<String, dynamic>> foundSamples = [];

  TextEditingController searchController = TextEditingController();

  String formatDateWithUserTimezone(DateTime dateTime) {
    final formatter = DateFormat('MM/dd/yyyy HH:mm', Intl.getCurrentLocale());
    return formatter.format(dateTime.toLocal());
  }

  Future<void> searchSamples(String toSearch) async {
    setState(() {
      foundSamples = [];
    });
    late Map<String, dynamic> sampleData;
    try {
      await db.collection("samples").get().then((querySnapshot) async {
        final samples = querySnapshot.docs;
        for (var sample in samples) {
          if (sample
              .data()["search"]
              .toString()
              .contains(toSearch.toLowerCase().replaceAll(" ", ""))) {
            Map<String, dynamic> providerData = {};
            await db
                .collection("users")
                .where("id", isEqualTo: sample.data()["provider"])
                .get()
                .then((querySnapshot) async {
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
            sampleData = {
              "id": sample.data()["id"],
              "provider": sample.data()["provider"],
              "number": sample.data()["number"],
              "code": sample.data()["code"],
              "formula": sample.data()["formula"],
              "keywords": sample.data()["keywords"],
              "type": sample.data()["type"],
              "morphology": sample.data()["morphology"],
              "previousDiffraction": sample.data()["previousDiffraction"],
              "previousThermal": sample.data()["previousThermal"],
              "previousOptical": sample.data()["previousOptical"],
              "otherPrevious": sample.data()["otherPrevious"],
              "doi": sample.data()["doi"],
              "suggestionDiffraction": sample.data()["suggestionDiffraction"],
              "suggestionThermal": sample.data()["suggestionThermal"],
              "suggestionOptical": sample.data()["suggestionOptical"],
              "otherSuggestions": sample.data()["otherSuggestions"],
              "hazardous": sample.data()["hazardous"],
              "animals": sample.data()["animals"],
              "image": sample.data()["image"],
              "search": sample.data()["search"],
              "registration": sample.data()["registration"],
              "providerData": providerData,
            };
            setState(() {
              foundSamples.add(sampleData);
            });
            // debugPrint(sampleData.toString());
          }
        }
      }, onError: (e) {
        debugPrint("Error completing: $e");
      });
    } catch (e) {
      debugPrint('error in getMySample(): $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        actions: const [CircularAvatarButton()],
        centerTitle: true,
      ),
      drawer: const CustomDrawer(highlight: Highlight.search),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          searchSamples(value);
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: 'Type here...',
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 1, 134, 243),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: IconButton(
                        onPressed: () {
                          if (searchController.text.isNotEmpty) {
                            searchSamples(searchController.text);
                            Timer.periodic(const Duration(milliseconds: 500),
                                (timer) {
                              setState(() {
                                searching = true;
                              });
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.search_rounded,
                          color: Colors.black,
                          size: 28,
                        )),
                  ),
                ],
              ),
            ),
          ),
          if (searching)
            Text(
                "${foundSamples.length} ${foundSamples.isNotEmpty && foundSamples.length > 1 ? 'samples' : 'sample'} found"),
          if (foundSamples.isNotEmpty)
            TextButton(
              onPressed: () {
                setState(() {
                  searching = false;
                  searchController.text = "";
                  foundSamples.clear();
                });
              },
              child: const Text("Clear Search"),
            ),
          if (foundSamples.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: foundSamples.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(
                          thickness: 1,
                        ),
                        const Text(
                          "Code",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(foundSamples[index]['code']),
                        const Text(
                          "Chemical Formula",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(foundSamples[index]['formula']),
                        const Text(
                          "Registration date",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(formatDateWithUserTimezone(
                            foundSamples[index]["registration"].toDate())),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (foundSamples[index]["provider"] !=
                                auth.currentUser!.uid)
                              FavoriteProviderButton(
                                  providerData: foundSamples[index]
                                      ["providerData"]),
                            FavoriteSampleButton(
                                sampleData: foundSamples[index]),
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  "/sample",
                                  arguments: foundSamples[index],
                                );
                              },
                              icon: const Icon(Icons.remove_red_eye),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
