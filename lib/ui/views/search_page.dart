import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sample/ui/widgets/custom_drawer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> foundSamples = [];

  TextEditingController searchController = TextEditingController();

  String formatDateWithUserTimezone(DateTime dateTime) {
    final formatter = DateFormat('MM/dd/yyyy HH:mm', Intl.getCurrentLocale());
    return formatter.format(dateTime.toLocal());
  }

  Future<void>searchSamples(String toSearch) async {
    debugPrint("searching: $toSearch");
    setState(() {
      foundSamples = [];
    });
    late Map<String, dynamic> sampleData;
    try{
      await db.collection("samples").get().then((querySnapshot) async {
        final samples = querySnapshot.docs;
        for (var sample in samples) {
          if (sample.data()["search"].toString().contains(toSearch.toLowerCase())) {
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
            };
            setState(() {
              foundSamples.add(sampleData);
            });
            debugPrint(sampleData.toString());
          }
        }
      }, onError: (e) {
        debugPrint("Error completing: $e");
      });
    } catch(e) {
      debugPrint('error in getMySample(): $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
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
                      decoration: const InputDecoration(
                        hintText: 'Type here...',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (searchController.text != "") {
                        searchSamples(searchController.text);
                      }
                    },
                    icon: const Icon(
                      Icons.search_rounded,
                      color: Colors.black,
                      size: 35,
                    )
                  ),
                ],
              ),
            ),
          ),
          if (foundSamples.isNotEmpty) Expanded(
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
                      Text(formatDateWithUserTimezone(foundSamples[index]["registration"].toDate())),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/sample", arguments: foundSamples[index],);
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
