import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sample/providers/sample_provider.dart';
import 'package:sample/ui/buttons/circular_avatar_button.dart';
import 'package:sample/ui/buttons/favorite_provider_button.dart';
import 'package:sample/ui/buttons/favorite_sample_button.dart';
import 'package:sample/ui/buttons/publication_button.dart';
import 'package:sample/ui/buttons/see_sample_button.dart';
import 'package:sample/ui/widgets/custom_drawer.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  String formatDateWithUserTimezone(DateTime dateTime) {
    final formatter = DateFormat('MM/dd/yyyy HH:mm', Intl.getCurrentLocale());
    return formatter.format(dateTime.toLocal());
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<SampleProvider>(context, listen: false).getMySamples();
      Provider.of<SampleProvider>(context, listen: false)
          .getFavoriteProviders();
      Provider.of<SampleProvider>(context, listen: false).getFavoriteSamples();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show the AlertDialog and wait for the user's response
        bool? shouldPop = await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            backgroundColor: Colors.blueGrey,
            content: const Text(
              "Do you want to exit the app?",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text(
                  "Leave",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 18,
                      color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  "Stay",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 18,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        );
        // Lidar com o caso quando a caixa de diálogo é descartada sem nenhuma seleção
        // Por exemplo, quando o usuário toca fora da caixa de diálogo para ignorá-la
        return shouldPop ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 85, 134, 158),
          title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: const [
            CircularAvatarButton(),
          ],
        ),
        drawer: const CustomDrawer(highlight: Highlight.dashboard),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<SampleProvider>(
                builder: (context, provider, child) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          
                          color: Color.fromARGB(255, 213, 227, 246),
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
                      child: ExpansionTile(
                          title: const Row(
                            children: [
                              Icon(Icons.science, color: Colors.black),
                              Text('My Samples'),
                            ],
                          ),
                          children: provider.mySamples.isEmpty
                              ? <ListTile>[
                                  ListTile(
                                    title: const Text(
                                        "Your samples will be shown here."),
                                    onTap: () {
                                      debugPrint(
                                          "Favorite sample test item 0 clicked");
                                      // Navigator.pop(context);
                                    },
                                  ),
                                ]
                              : provider.mySamples.map((sampleData) {
                                  return ListTile(
                                    title: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(Radius.circular(10)
                                           ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          
                                          const Text(
                                            "Code",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(sampleData['code']),
                                          const Text(
                                            "Chemical Formula",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(sampleData['formula']),
                                          const Text(
                                            "Registration date",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(formatDateWithUserTimezone(
                                              sampleData["registration"]
                                                  .toDate())),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 165, 207, 228),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20),
                                                            topRight:
                                                                Radius.circular(
                                                                    20),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    20),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    20)),
                                                    border: Border.all(
                                                      color: Color.fromARGB(
                                                          255, 165, 207, 228),
                                                      width: 5,
                                                    )),
                                                child: Row(
                                                  children: [
                                                    PublicationButton(
                                                        sampleData: sampleData),
                                                    IconButton(
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  "Confirm Deletion"),
                                                              content: const Text(
                                                                  "Are you sure you want to delete this sample?"),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(); // Fecha o diálogo
                                                                  },
                                                                  child: const Text(
                                                                      "Cancel"),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    db
                                                                        .collection(
                                                                            "samples")
                                                                        .doc(sampleData[
                                                                            "id"])
                                                                        .delete()
                                                                        .then(
                                                                          (doc) =>
                                                                              debugPrint("Sample deleted"),
                                                                          onError: (e) =>
                                                                              debugPrint("Error updating document $e"),
                                                                        );
                                                                    provider
                                                                        .getMySamples();
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: const Text(
                                                                      "Delete"),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        Navigator.pushNamed(
                                                          context,
                                                          "/update-sample",
                                                          arguments: sampleData,
                                                        );
                                                      },
                                                      icon: const Icon(
                                                        Icons.edit,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    SeeSampleButton(sampleData: sampleData),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList()),
                    ),
                  );
                },
              ),
              Consumer<SampleProvider>(
                builder: (context, provider, child) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 219, 240, 239),
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
                      child: ExpansionTile(
                          title: const Row(
                            children: [
                              Icon(Icons.star, color: Colors.black),
                              Text('Favorite Samples'),
                            ],
                          ),
                          children: provider.favoriteSamples.isEmpty
                              ? <ListTile>[
                                  const ListTile(
                                    title: Text(
                                        "Your favorite samples will be shown here."),
                                  ),
                                ]
                              : provider.favoriteSamples.map((favSample) {
                                  return ListTile(
                                    // title: Text("${favSample}"),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Code",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(favSample["code"]),
                                        const Text(
                                          "Chemical Formula",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(favSample["formula"]),
                                        const Text(
                                          "Registration date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(formatDateWithUserTimezone(
                                            favSample["registration"]
                                                .toDate())),
                                       Row(
                                        mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                         children: [
                                           Container(
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                        255, 165, 207, 228),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20),
                                                            topRight:
                                                                Radius.circular(
                                                                    20),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    20),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    20)),
                                                    border: Border.all(
                                                      color: Color.fromARGB(
                                                          255, 165, 207, 228),
                                                      width: 5,
                                                    )
                                            ),
                                             child: Row(                                              
                                                  children: [
                                                    if (favSample["provider"] !=
                                                        auth.currentUser!.uid)
                                                      FavoriteProviderButton(
                                                          providerData: favSample[
                                                              "providerData"]),
                                                    FavoriteSampleButton(
                                                        sampleData: favSample),
                                                    SeeSampleButton(sampleData: favSample)
                                                  ],
                                                ),
                                           ),
                                         ],
                                       )
                                        ],                                        
                                    ),
                                    
                                  );
                                }).toList()),
                    ),
                  );
                },
              ),
              Consumer<SampleProvider>(
                builder: (context, provider, child) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 240, 247, 238),
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
                      child: ExpansionTile(
                          title: const Row(
                            children: [
                              Icon(Icons.person),
                              Text('Favorite Providers'),
                            ],
                          ),
                          children: provider.favoriteProviders.isEmpty
                              ? <ListTile>[
                                  const ListTile(
                                    title: Text(
                                        "Your favorite providers will be shown here."),
                                  ),
                                ]
                              : provider.favoriteProviders.map((providerData) {
                                  return ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Provider",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        Text(
                                            "Name: ${providerData['name']}\nEmail: ${providerData['email']}",
                                            style:
                                                const TextStyle(fontSize: 16)),
                                        if (auth.currentUser!.uid !=
                                            providerData["id"])
                                          Row(
                                            mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                            255, 165, 207, 228),
                                                        borderRadius:
                                                            const BorderRadius.only(
                                                                topLeft:
                                                                    Radius.circular(
                                                                        20),
                                                                topRight:
                                                                    Radius.circular(
                                                                        20),
                                                                bottomLeft:
                                                                    Radius.circular(
                                                                        20),
                                                                bottomRight:
                                                                    Radius.circular(
                                                                        20)),
                                                        border: Border.all(
                                                          color: Color.fromARGB(
                                                              255, 165, 207, 228),
                                                          width: 5,
                                                        )
                                                ),
                                                child: Row(
                                                                                                      
                                                  children: [
                                                    FavoriteProviderButton(
                                                        providerData: providerData),
                                                    IconButton(
                                                      onPressed: () {
                                                        Navigator.pushNamed(
                                                          context,
                                                          "/provider",
                                                          arguments: providerData,
                                                        );
                                                      },
                                                      icon: const Icon(Icons
                                                          .sticky_note_2_outlined),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  );
                                }).toList()),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
