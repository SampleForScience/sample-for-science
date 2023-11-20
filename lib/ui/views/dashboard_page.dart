import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sample/providers/favorite_provider.dart';
import 'package:sample/ui/buttons/circular_avatar_button.dart';
import 'package:sample/ui/buttons/favorite_provider_button.dart';
import 'package:sample/ui/buttons/favorite_sample_button.dart';
import 'package:sample/ui/widgets/custom_drawer.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> mySamples = [];

  String formatDateWithUserTimezone(DateTime dateTime) {
    final formatter = DateFormat('MM/dd/yyyy HH:mm', Intl.getCurrentLocale());
    return formatter.format(dateTime.toLocal());
  }

  Future<void>getMySamples() async {
    setState(() {
      mySamples = [];
    });
    late Map<String, dynamic> sampleData;
    try{
      await db.collection("samples")
        .where("provider", isEqualTo: auth.currentUser!.uid)
        .get()
        .then((querySnapshot) async {
          final samples = querySnapshot.docs;
          for (var sample in samples) {
            sampleData = {
              "id": sample.data()["id"],
              "provider": sample.data()["provider"],
              "number": sample.data()["number"],
              "code": sample.data()["code"],
              "formula": sample.data()["formula"],
              "keywords": sample.data()["keywords"],
              "type": sample.data()["type"],
              "otherType": sample.data()["otherType"],
              "morphology": sample.data()["morphology"],
              "otherMorphology": sample.data()["otherMorphology"],
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
              "registration": sample.data()["registration"],
            };
            setState(() {
              mySamples.add(sampleData);
            });
          }
        }, onError: (e) {
          debugPrint("Error completing: $e");
        });
    } catch(e) {
      debugPrint('error in getMySample(): $e');
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      getMySamples();
      Provider.of<FavoriteProvider>(context, listen: false).getFavoriteProviders();
      Provider.of<FavoriteProvider>(context, listen: false).getFavoriteSamples();
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
            content: const Text("Do you want to exit the app?",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white),
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
                    color: Colors.white
                  ),
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
                    color: Colors.white
                  ),
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
          title: const Text('Dashboard'),
          centerTitle: true,
          actions: const [
            CircularAvatarButton(),
          ],
        ),
        drawer: const CustomDrawer(highlight: Highlight.dashboard),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ExpansionTile(
                  title: const Text('My Samples'),
                  children: mySamples.isEmpty
                      ? <ListTile>[ListTile(
                    title: const Text("Your samples will be shown here."),
                    onTap: () {
                      debugPrint("Favorite sample test item 0 clicked");
                      // Navigator.pop(context);
                    },
                  ),]
                      : mySamples.map((sampleData) {
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
                          Text(sampleData['code']),
                          const Text(
                            "Chemical Formula",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(sampleData['formula']),
                          const Text(
                            "Registration date",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(formatDateWithUserTimezone(sampleData["registration"].toDate())),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Confirm Deletion"),
                                        content: const Text("Are you sure you want to delete this sample?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(); // Fecha o diálogo
                                            },
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              db.collection("samples")
                                                  .doc(sampleData["id"])
                                                  .delete()
                                                  .then((doc) => debugPrint("Sample deleted"),
                                                onError: (e) => debugPrint("Error updating document $e"),
                                              );
                                              getMySamples();
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Delete"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.delete),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, "/sample", arguments: sampleData,);
                                },
                                icon: const Icon(Icons.remove_red_eye),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, "/update-sample", arguments: sampleData,);
                                },
                                icon: const Icon(Icons.edit),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList()
              ),
              Consumer<FavoriteProvider>(
                builder: (context, provider, child) {
                  return ExpansionTile(
                      title: const Text('Favorite Samples'),
                      children: provider.favoriteSamples.isEmpty
                          ? <ListTile>[const ListTile(
                        title: Text("Your favorite samples will be shown here."),
                      ),]
                          : provider.favoriteSamples.map((sampleData) {
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
                              Text(sampleData['code']),
                              const Text(
                                "Chemical Formula",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(sampleData['formula']),
                              const Text(
                                "Registration date",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(formatDateWithUserTimezone(sampleData["registration"].toDate())),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (sampleData["provider"] != auth.currentUser!.uid)
                                    FavoriteProviderButton(providerData: sampleData["providerData"]),
                                  FavoriteSampleButton(providerData: sampleData),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, "/sample", arguments: sampleData,);
                                    },
                                    icon: const Icon(Icons.remove_red_eye),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList()
                  );
                },
              ),
              Consumer<FavoriteProvider>(
                builder: (context, provider, child) {
                  return ExpansionTile(
                      title: const Text('Favorite Providers'),
                      children: provider.favoriteProviders.isEmpty
                          ? <ListTile>[const ListTile(
                        title: Text("Your favorite providers will be shown here."),
                      ),]
                          : provider.favoriteProviders.map((providerData) {
                        return ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                  "Provider",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )
                              ),
                              Text("Name: ${providerData['name']}\nEmail: ${providerData['email']}",
                                  style: const TextStyle(
                                      fontSize: 16
                                  )
                              ),
                              if (auth.currentUser!.uid != providerData["id"])Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FavoriteProviderButton(providerData: providerData),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, "/provider", arguments: providerData,);
                                    },
                                    icon: const Icon(Icons.remove_red_eye),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList()
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
