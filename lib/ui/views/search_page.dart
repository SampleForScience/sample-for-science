// TODO: verificar bug da contagem de amostras encontradas na primeira busca

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sample/providers/sample_provider.dart';
import 'package:sample/ui/buttons/circular_avatar_button.dart';
import 'package:sample/ui/buttons/favorite_provider_button.dart';
import 'package:sample/ui/buttons/favorite_sample_button.dart';
import 'package:sample/ui/buttons/see_sample_button.dart';
import 'package:sample/ui/widgets/custom_drawer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  int page = 1;
  int limit = 25;
  bool searching = false;
  List<Map<String, dynamic>> foundSamples = [];

  TextEditingController searchController = TextEditingController();

  String formatDateWithUserTimezone(DateTime dateTime) {
    final formatter = DateFormat('MM/dd/yyyy HH:mm', Intl.getCurrentLocale());
    return formatter.format(dateTime.toLocal());
  }

  Future<void> getSamples(int limit) async {
    setState(() {
      foundSamples = [];
    });
    late Map<String, dynamic> sampleData;
    try {
      await db.collection("samples").limit(limit).get().then((querySnapshot) async {
        final samples = querySnapshot.docs;
        for (var sample in samples) {
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
            "publicationStatus": sample.data()["publicationStatus"],
            "search": sample.data()["search"],
            "registration": sample.data()["registration"],
            "providerData": providerData,
          };
          setState(() {
            if (sampleData["publicationStatus"] == "Public") {
              foundSamples.add(sampleData);
            }
          });
        }
      }, onError: (e) {
        debugPrint("Error completing: $e");
      });
    } catch (e) {
      debugPrint('error in getMySample(): $e');
    }
  }

  // TODO: limitar quantidade de itens listados
  Future<void> searchSamples(String toSearch, String startAfter, int limit) async {
    setState(() {
      foundSamples = [];
      searching = true;
    });
    try {
      if (startAfter == "") {
        await db.collection("samples").orderBy("id").limit(limit).get().then((querySnapshot) {
          processQuerySnapshot(querySnapshot, toSearch);
        }, onError: (e) {
          debugPrint("Error completing: $e");
        });
      } else {
        await db.collection("samples").orderBy("id").startAfter([startAfter]).get().then((querySnapshot) {
          processQuerySnapshot(querySnapshot, toSearch);
        }, onError: (e) {
          debugPrint("Error completing: $e");
        });
      }
    } catch (e) {
      debugPrint('error in getMySample(): $e');
    }
  }

  // TODO: limitar quantidade de itens listados
  Future<void> processQuerySnapshot(QuerySnapshot<Map<String, dynamic>> querySnapshot, String toSearch) async {
    final samples = querySnapshot.docs;
    late Map<String, dynamic> sampleData;
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
          "publicationStatus": sample.data()["publicationStatus"],
          "search": sample.data()["search"],
          "registration": sample.data()["registration"],
          "providerData": providerData,
        };
        setState(() {
          if (sampleData["publicationStatus"] == "Public") {
            foundSamples.add(sampleData);
          }
        });
        // debugPrint(sampleData.toString());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<SampleProvider>(context, listen: false).getMySamples();
    Provider.of<SampleProvider>(context, listen: false).getFavoriteProviders();
    Provider.of<SampleProvider>(context, listen: false).getFavoriteSamples();
    getSamples(25);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 85, 134, 158),
        title: const Text("Search", style: TextStyle(color: Colors.white)),
        actions: const [CircularAvatarButton()],
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const CustomDrawer(highlight: Highlight.search),
      body: Column(
        children: [
          SizedBox(
            height: 75,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.grey)),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            searchSamples(value, "", 25);
                          }
                        },
                        decoration: const InputDecoration(
                            hintText: ' Type here...',
                            border: InputBorder.none),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 50,
                      height: 75,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 85, 134, 158),
                          borderRadius: BorderRadius.circular(8.0)),
                      child: IconButton(
                          onPressed: () {
                            if (searchController.text.isNotEmpty) {
                              searchSamples(searchController.text, "", 25);
                            }
                          },
                          icon: const Icon(
                            Icons.search_rounded,
                            color: Colors.white,
                            size: 32,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (searching == true)
            Text("${foundSamples.length} ${foundSamples.isNotEmpty && foundSamples.length > 1 ? 'samples' : 'sample'} found"),
          if (searching == true)
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
                    title: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(4, 8))
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 165, 207, 228),
                                    borderRadius:
                                      const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20)
                                      ),
                                    border: Border.all(
                                      color: const Color.fromARGB(255, 165, 207, 228),
                                      width: 5,
                                    )
                                  ),
                                  child: Row(
                                    children: [
                                      if (foundSamples[index]["provider"] != auth.currentUser!.uid)
                                        FavoriteProviderButton(providerData: foundSamples[index]["providerData"]),
                                      if (foundSamples[index]["provider"] != auth.currentUser!.uid)
                                        FavoriteSampleButton(sampleData: foundSamples[index]),
                                      SeeSampleButton(sampleData: foundSamples[index])
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          if (foundSamples.isNotEmpty && searching)
            TextButton(
              onPressed: () {
                setState(() {
                  page++;
                });
              },
              child: Text("${limit * (page - 1) + 1} - ${limit * page}")
            ),
        ],
      ),
    );
  }
}
