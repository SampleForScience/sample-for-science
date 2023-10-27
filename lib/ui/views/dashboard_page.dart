import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sample/ui/buttons/circular_avatar_button.dart';
import 'package:sample/ui/widgets/custom_drawer.dart';

// Itens do popMenuButton
enum MenuItem { logIn }

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
    mySamples = [];
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
    getMySamples();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: const [
          CircularAvatarButton(),
        ],
      ),
      drawer: const CustomDrawer(),

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
            ExpansionTile(
              title: const Text('Favorite Samples'),
              children: <Widget>[
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.science),
                      Text(" Favorite sample test item 0"),
                    ],
                  ),
                  onTap: () {
                    debugPrint("Favorite sample test item 0 clicked");
                    // Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.science),
                      Text(" Favorite sample test item 1"),
                    ],
                  ),
                  onTap: () {
                    debugPrint("Favorite sample test item 1 clicked");
                    // Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.science),
                      Text(" Favorite sample test item 2"),
                    ],
                  ),
                  onTap: () {
                    debugPrint("Favorite sample test item 2 clicked");
                    // Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.science),
                      Text(" Favorite sample test item 3"),
                    ],
                  ),
                  onTap: () {
                    debugPrint("Favorite sample test item 3 clicked");
                    // Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.science),
                      Text(" Favorite sample test item 4"),
                    ],
                  ),
                  onTap: () {
                    debugPrint("Favorite sample test item 4 clicked");
                    // Navigator.pop(context);
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Favorite Providers'),
              children: <Widget>[
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.science),
                      Text(" Favorite provider test item 0"),
                    ],
                  ),
                  onTap: () {
                    debugPrint("Favorite provider test item 0 clicked");
                    // Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.science),
                      Text(" Favorite provider test item 1"),
                    ],
                  ),
                  onTap: () {
                    debugPrint("Favorite provider test item 1 clicked");
                    // Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.science),
                      Text(" Favorite provider test item 2"),
                    ],
                  ),
                  onTap: () {
                    debugPrint("Favorite provider test item 2 clicked");
                    // Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.science),
                      Text(" Favorite provider test item 3"),
                    ],
                  ),
                  onTap: () {
                    debugPrint("Favorite provider test item 3 clicked");
                    // Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.science),
                      Text(" Favorite provider test item 4"),
                    ],
                  ),
                  onTap: () {
                    debugPrint("Favorite provider test item 4 clicked");
                    // Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
