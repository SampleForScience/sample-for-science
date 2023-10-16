import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample/ui/widgets/buttons/circular_avatar_button.dart';

class UpdateSamplePage extends StatefulWidget {
  const UpdateSamplePage({super.key});

  @override
  State<UpdateSamplePage> createState() => _UpdateSamplePageState();
}

class _UpdateSamplePageState extends State<UpdateSamplePage> with SingleTickerProviderStateMixin {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  Map<String, dynamic> sample = {};
  late Map<String, dynamic> sampleData;

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

  updateSample(Map<String, dynamic> sample, String sampleId) async {
    await db.collection("samples").doc(sampleId).set(sample).then((_) {
      debugPrint("New sample saved");
      Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
    }
    ).onError((e, _) {
      debugPrint("Error saving user: $e");
    });
  }

  Future<bool> loadUserData(sampleData) async {
    setState(() {
      numberController.text = sampleData["number"];
      codeController.text = sampleData["code"];
      formulaController.text = sampleData["formula"];
      keywordsController.text = sampleData["keywords"];
      selectedTypeOfSample = sampleData["type"];
      selectedMorphology = sampleData["morphology"];
    });
    return true;
  }

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: tabs.length);
    _tabController.addListener(_handleTabSelection);
    Future.delayed(Duration.zero, () {
      loadUserData(sampleData);
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    sampleData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Sample"),
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
                      initialSelection: sampleData["type"],
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
                      initialSelection: sampleData["morphology"],
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
                String sampleId = sampleData["id"];

                sample = {
                  "id": sampleData["id"],
                  "provider": sampleData["provider"],
                  "number": numberController.text,
                  "code": codeController.text,
                  "formula": formulaController.text,
                  "keywords": keywordsController.text,
                  "type": selectedTypeOfSample,
                  "morphology": selectedMorphology,
                  "registration": sampleData["registration"],
                };

                updateSample(sample, sampleId);
              },
              child: const Text("Update Sample!"),
            )
          ],
        ),
      ),
    );
  }
}