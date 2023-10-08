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

  saveNewSample(Map<String, dynamic> newSample) async {
    String uid = auth.currentUser!.uid;
    String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    String fileName = "$uid$timeStamp";

    await db.collection("samples").doc(fileName).set(newSample).then((_) {
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
          Column(
            children: [
              const Text("Basic Information"),
              TextField(
                controller: numberController,
                decoration: const InputDecoration(
                  label: Text("Number of samples"),
                ),
              ),
              TextField(
                controller: codeController,
                decoration: const InputDecoration(
                  label: Text("Assign a code"),
                ),
              ),
              TextField(
                controller: formulaController,
                decoration: const InputDecoration(
                  label: Text("Chemical formula"),
                ),
              ),
              TextField(
                controller: keywordsController,
                decoration: const InputDecoration(
                  label: Text("Keywords"),
                ),
              ),
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
              )
            ],
          ),
          const Column(
            children: [
              Text("data")
            ],
          ),
          const Column(
            children: [
              Text("data")
            ],
          ),
          const Column(
            children: [
              Text("data")
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
                String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
                String sampleId = "$uid$timeStamp";

                newSample = {
                  "id": sampleId,
                  "provider": uid,
                  "number": numberController.text,
                  "code": codeController.text,
                  "formula": formulaController.text,
                  "keywords": keywordsController.text,
                  "type": selectedTypeOfSample,
                  "morphology": selectedMorphology,
                };

                saveNewSample(newSample);
              },
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}