import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  String anim = "next";
  int page = 1;
  int limitPerPage = 10;
  int count = 0;
  bool searching = false;
  List<Map<String, dynamic>> foundSamples = [];
  List<Map<String, dynamic>> samplesToShow = [];
  List<List<Map<String, dynamic>>> paginatedSamples = [];

  TextEditingController searchController = TextEditingController();

  String formatDateWithUserTimezone(DateTime dateTime) {
    final formatter = DateFormat('MM/dd/yyyy HH:mm', Intl.getCurrentLocale());
    return formatter.format(dateTime.toLocal());
  }

  List<Tab> tabs = <Tab>[
    const Tab(text: "Samples",),
    const Tab(text: "Users",),
  ];
  late TabController _tabController;

  void _handleTabSelection() {
    setState(() {
      _tabController.index;
    });
  }

  Future<void> getSamples(int limit) async {
    setState(() {
      foundSamples = [];
    });
    // late Map<String, dynamic> sampleData;
    try {
      await db.collection("samples").limit(limit).get().then((querySnapshot) async {
        processSearchQuerySnapshot(querySnapshot, "");
      }, onError: (e) {
        debugPrint("Error completing: $e");
      });
    } catch (e) {
      debugPrint('error in getMySample(): $e');
    }
  }

  Future<void> searchSamples(String toSearch) async {
    setState(() {
      foundSamples = [];
      searching = true;
    });
    try {
      await db.collection("samples").orderBy("id").get().then((querySnapshot) {
        processSearchQuerySnapshot(querySnapshot, toSearch);
      }, onError: (e) {
        debugPrint("Error completing: $e");
      });
    } catch (e) {
      debugPrint('error in getMySample(): $e');
    }
  }


  // TODO: passar querysnapshot como parâmetro pra não precisar fazer busca extra pra contar amostras encontradas
  Future<void> countFoundSamples(String toSearch) async {
    setState(() {
      count = 0;
    });
    await db.collection("samples").get().then((querySnapshot) {
      final samples = querySnapshot.docs;
      for (var sample in samples) {
        if (sample
            .data()["search"]
            .toString()
            .contains(toSearch.toLowerCase().replaceAll(" ", ""))) {
          setState(() {
            count += 1;
          });
        }
      }
    }, onError: (e) {
      debugPrint("Error completing: $e");
    });
  }

  // TODO: limitar quantidade de itens listados
  Future<void> processSearchQuerySnapshot(QuerySnapshot<Map<String, dynamic>> querySnapshot, String toSearch) async {
    setState(() {
      count = 0;
    });

    final samples = querySnapshot.docs;
    late Map<String, dynamic> sampleData;

    for (var sample in samples) {
      if (toSearch == "") {
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
            count += 1;
          }
        });
      } else {
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
              count += 1;
            }
          });
        }
      }
    }
    // TODO: trocar pelo limitPerPage
    for (int i = 0; i < foundSamples.length; i += limitPerPage) {
      int end = i + limitPerPage;
      if (end > foundSamples.length) {
        end = foundSamples.length;
      }
      paginatedSamples.add(foundSamples.sublist(i, end));
    }
    samplesToShow = paginatedSamples[0];
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
    _tabController.addListener(_handleTabSelection);
    Provider.of<SampleProvider>(context, listen: false).getMySamples();
    Provider.of<SampleProvider>(context, listen: false).getFavoriteProviders();
    Provider.of<SampleProvider>(context, listen: false).getFavoriteSamples();
    getSamples(500);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        bottom: TabBar(
          labelColor: Colors.white,
          controller: _tabController,
          tabs: tabs,
        ),
      ),
      drawer: const CustomDrawer(highlight: Highlight.search),
      body: TabBarView(
        controller: _tabController,
        children: [
          Column(
            children: [
              SizedBox(
                height: 75,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.grey)),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  foundSamples.clear();
                                  samplesToShow.clear();
                                  paginatedSamples.clear();
                                });
                                // countFoundSamples(searchController.text);
                                searchSamples(searchController.text);
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
                              color: const Color.fromARGB(255, 85, 134, 158),
                              borderRadius: BorderRadius.circular(8.0)),
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  foundSamples.clear();
                                  samplesToShow.clear();
                                  paginatedSamples.clear();
                                });
                                if (searchController.text.isNotEmpty) {
                                  // countFoundSamples(searchController.text);
                                  searchSamples(searchController.text);
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
              // if (searching == true)
              //   Text("${foundSamples.length} ${foundSamples.isNotEmpty && foundSamples.length > 1 ? 'samples' : 'sample'} found"),
              if (searching == true)
                TextButton(
                  onPressed: () {
                    setState(() {
                      searching = false;
                      searchController.text = "";
                      count = 0;
                      foundSamples.clear();
                      samplesToShow.clear();
                      paginatedSamples.clear();
                    });
                  },
                  child: const Text("Clear Search"),
                ),
              if (samplesToShow.isNotEmpty)
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return SlideTransition(
                        position:
                        Tween<Offset>(
                          begin: anim == "next"
                              ? const Offset(2.0, 0.0)
                              : const Offset(-2.0, 0.0)
                          ,
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                    child: ListView.builder(
                      key: UniqueKey(),
                      itemCount: samplesToShow.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(4, 8),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Code",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(samplesToShow[index]['code']),
                                  const Text(
                                    "Chemical Formula",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(samplesToShow[index]['formula']),
                                  const Text(
                                    "Registration date",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(formatDateWithUserTimezone(samplesToShow[index]["registration"].toDate())),
                                  if (samplesToShow[index]["provider"] != auth.currentUser!.uid)
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context, "/provider", arguments: samplesToShow[index]["provider"],);
                                        },
                                        child: const Center(child: Text("See Provider"))
                                    ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(255, 165, 207, 228),
                                          borderRadius:
                                          const BorderRadius.all(Radius.circular(20)),
                                          border: Border.all(
                                            color: const Color.fromARGB(255, 165, 207, 228),
                                            width: 5,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            if (samplesToShow[index]["provider"] !=
                                                auth.currentUser!.uid)
                                              FavoriteProviderButton(
                                                  providerData:
                                                  samplesToShow[index]["providerData"]),
                                            if (samplesToShow[index]["provider"] !=
                                                auth.currentUser!.uid)
                                              FavoriteSampleButton(
                                                  sampleData: samplesToShow[index]),
                                            SeeSampleButton(sampleData: samplesToShow[index]),
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
                ),
              if (foundSamples.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    page <= 1
                        ? const TextButton(
                        onPressed: null,
                        child: Text("<")
                    )
                        : TextButton(
                        onPressed: () {
                          setState(() {
                            anim = "previous";
                            page -= 1;
                            samplesToShow = paginatedSamples[page - 1];
                          });
                        },
                        child: const Text("<")
                    ),
                    Text("showing  ${limitPerPage * (page - 1) + 1} - ${limitPerPage * page >= count ? count : limitPerPage * page}  of  $count"),
                    ((limitPerPage * page) >= count)
                        ? const TextButton(
                        onPressed: null,
                        child: Text(">")
                    )
                        : TextButton(
                        onPressed: () {
                          setState(() {
                            anim = "next";
                            page += 1;
                            samplesToShow = paginatedSamples[page - 1];
                          });
                        },
                        child: const Text(">")
                    ),
                  ],
                ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 75,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.grey)),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  foundSamples.clear();
                                  samplesToShow.clear();
                                  paginatedSamples.clear();
                                });
                                // countFoundSamples(searchController.text);
                                searchSamples(searchController.text);
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
                              color: const Color.fromARGB(255, 85, 134, 158),
                              borderRadius: BorderRadius.circular(8.0)),
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  foundSamples.clear();
                                  samplesToShow.clear();
                                  paginatedSamples.clear();
                                });
                                if (searchController.text.isNotEmpty) {
                                  // countFoundSamples(searchController.text);
                                  searchSamples(searchController.text);
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
              // if (searching == true)
              //   Text("${foundSamples.length} ${foundSamples.isNotEmpty && foundSamples.length > 1 ? 'samples' : 'sample'} found"),
              if (searching == true)
                TextButton(
                  onPressed: () {
                    setState(() {
                      searching = false;
                      searchController.text = "";
                      count = 0;
                      foundSamples.clear();
                      samplesToShow.clear();
                      paginatedSamples.clear();
                    });
                  },
                  child: const Text("Clear Search"),
                ),
              if (samplesToShow.isNotEmpty)
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return SlideTransition(
                        position:
                        Tween<Offset>(
                          begin: anim == "next"
                              ? const Offset(2.0, 0.0)
                              : const Offset(-2.0, 0.0)
                          ,
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                    child: ListView.builder(
                      key: UniqueKey(),
                      itemCount: samplesToShow.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(4, 8),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Code",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(samplesToShow[index]['code']),
                                  const Text(
                                    "Chemical Formula",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(samplesToShow[index]['formula']),
                                  const Text(
                                    "Registration date",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(formatDateWithUserTimezone(samplesToShow[index]["registration"].toDate())),
                                  if (samplesToShow[index]["provider"] != auth.currentUser!.uid)
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context, "/provider", arguments: samplesToShow[index]["provider"],);
                                        },
                                        child: const Center(child: Text("See Provider"))
                                    ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(255, 165, 207, 228),
                                          borderRadius:
                                          const BorderRadius.all(Radius.circular(20)),
                                          border: Border.all(
                                            color: const Color.fromARGB(255, 165, 207, 228),
                                            width: 5,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            if (samplesToShow[index]["provider"] !=
                                                auth.currentUser!.uid)
                                              FavoriteProviderButton(
                                                  providerData:
                                                  samplesToShow[index]["providerData"]),
                                            if (samplesToShow[index]["provider"] !=
                                                auth.currentUser!.uid)
                                              FavoriteSampleButton(
                                                  sampleData: samplesToShow[index]),
                                            SeeSampleButton(sampleData: samplesToShow[index]),
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
                ),
              if (foundSamples.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    page <= 1
                        ? const TextButton(
                        onPressed: null,
                        child: Text("<")
                    )
                        : TextButton(
                        onPressed: () {
                          setState(() {
                            anim = "previous";
                            page -= 1;
                            samplesToShow = paginatedSamples[page - 1];
                          });
                        },
                        child: const Text("<")
                    ),
                    Text("showing  ${limitPerPage * (page - 1) + 1} - ${limitPerPage * page >= count ? count : limitPerPage * page}  of  $count"),
                    ((limitPerPage * page) >= count)
                        ? const TextButton(
                        onPressed: null,
                        child: Text(">")
                    )
                        : TextButton(
                        onPressed: () {
                          setState(() {
                            anim = "next";
                            page += 1;
                            samplesToShow = paginatedSamples[page - 1];
                          });
                        },
                        child: const Text(">")
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
