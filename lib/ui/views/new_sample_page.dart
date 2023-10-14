import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample/ui/widgets/buttons/circular_avatar_button.dart';

class NewSamplePage extends StatefulWidget {
  const NewSamplePage({super.key});

  @override
  State<NewSamplePage> createState() => _NewSamplePageState();
}

class _NewSamplePageState extends State<NewSamplePage> with SingleTickerProviderStateMixin {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  Map<String, dynamic> newSample = {};

  TextEditingController numberController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController formulaController = TextEditingController();
  TextEditingController keywordsController = TextEditingController();
  List<String> typeOfsampleList = <String>[
    "Ceramics",
    "Metals",
    "Metal-organic",
    "Polymer / Plastic"];
  String selectedTypeOfSample = "";
  List<String> morphologyList = <String>[
    "Composite",
    "Nano(particle, wire, ...)",
    "Film(thin, thick, ...)",
    "Bulk"
  ];
  String selectedMorphology = "";

  List<Tab> tabs = <Tab>[
    const Tab(text: "Basics",),
    const Tab(text: "Results",),
    const Tab(text: "Suggestions",),
    const Tab(text: "Hazard",),
  ];
  late TabController _tabController;

  void _handleTabSelection() {
    setState(() {
      _tabController.index;
    });
  }

  saveNewSample(Map<String, dynamic> newSample, String sampleId) async {
    await db.collection("samples").doc(sampleId).set(newSample).then((_) {
      debugPrint("New sample saved");
      Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
    }
    ).onError((e, _) {
      debugPrint("Error saving user: $e");
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
    _tabController.addListener(_handleTabSelection);
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
        title: const Text("New Sample"),
        centerTitle: true,
        actions: const [
          CircularAvatarButton()
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Basic Information",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            content: const Text("You can provide a single sample or a pack.Type the total amount of samples."),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: numberController,
                        decoration: const InputDecoration(
                          label: Text("Number of samples"),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            content: const Text("Assign a code for your sample(s)."),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: codeController,
                        decoration: const InputDecoration(
                          label: Text("Assign a code"),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            content: const Text("Inform the chemical formula for your sample(s). If you are providing a pack of samples, you can simplify the chemical formula.\n\nUsers will find your samples based on this field."),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: formulaController,
                        decoration: const InputDecoration(
                          label: Text("Chemical formula"),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            content: const Text("Provide a maximum of five keywords for your samples.\n\nUsers will find your samples based on this field. "),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: keywordsController,
                        decoration: const InputDecoration(
                          label: Text("Keywords"),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    DropdownMenu<String>(
                      width: MediaQuery.of(context).size.width,
                      hintText: "Type of Sample",
                      initialSelection: "",
                      onSelected: (String? value) {
                        setState(() {
                          selectedTypeOfSample = value!;
                        });
                      },
                      dropdownMenuEntries: typeOfsampleList.map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(value: value, label: value);
                      }).toList(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    DropdownMenu<String>(
                      width: MediaQuery.of(context).size.width,
                      hintText: "Morphology",
                      initialSelection: "",
                      onSelected: (String? value) {
                        setState(() {
                          selectedMorphology = value!;
                        });
                      },
                      dropdownMenuEntries: morphologyList.map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(value: value, label: value);
                      }).toList(),
                    ),
                  ],
                )
              ],
            ),
          ),
          const Column(
            children: [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "Previous results",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              )
            ],
          ),
          const Column(
            children: [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "Suggestions for new measurements",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              )
            ],
          ),
          const Column(
            children: [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "Hazardousness and Ethics",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              )
            ],
          ),
        ]
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (_tabController.index > 0) ElevatedButton(
              onPressed: () {
                setState(() {
                  _tabController.index--;
                });
                _tabController.animateTo(_tabController.index);
              },
              child: const Text("Back"),
            ),
            if (_tabController.index < tabs.length - 1) ElevatedButton(
              onPressed: () {
                setState(() {
                  _tabController.index++;
                });
                _tabController.animateTo(_tabController.index);
              },
              child: const Text("Next"),
            ),
            if (_tabController.index == tabs.length - 1) ElevatedButton(
              onPressed: () {
                String uid = auth.currentUser!.uid;
                DateTime registrationDate = DateTime.now();
                String milissecondsTimeStamp = registrationDate.millisecondsSinceEpoch.toString();
                String sampleId = "$uid$milissecondsTimeStamp";

                newSample = {
                  "id": sampleId,
                  "provider": uid,
                  "number": numberController.text,
                  "code": codeController.text,
                  "formula": formulaController.text,
                  "keywords": keywordsController.text,
                  "type": selectedTypeOfSample,
                  "morphology": selectedMorphology,
                  "registration": registrationDate,
                };

                saveNewSample(newSample, sampleId);
              },
              child: const Text("Add Sample!"),
            )
          ],
        ),
      ),
    );
  }
}