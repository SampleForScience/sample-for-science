import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sample/ui/buttons/circular_avatar_button.dart';

class UpdateSamplePage extends StatefulWidget {
  const UpdateSamplePage({super.key});

  @override
  State<UpdateSamplePage> createState() => _UpdateSamplePageState();
}

class _UpdateSamplePageState extends State<UpdateSamplePage> with SingleTickerProviderStateMixin {
  final db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final auth = FirebaseAuth.instance;
  Map<String, dynamic> sample = {};
  late Map<String, dynamic> sampleData;
  late String imageName;
  File? imagePath;
  Uint8List? imageBytes;

  TextEditingController numberController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController formulaController = TextEditingController();
  TextEditingController keywordsController = TextEditingController();
  //Results variables//
  TextEditingController prevDiffractionController = TextEditingController();
  TextEditingController prevThermalController = TextEditingController();
  TextEditingController prevOpticalController = TextEditingController();
  TextEditingController prevOtherController = TextEditingController();
  TextEditingController doiController = TextEditingController();
  //Suggestions variables//
  TextEditingController sugDiffractionController = TextEditingController();
  TextEditingController sugThermalController = TextEditingController();
  TextEditingController sugOpticalController = TextEditingController();
  TextEditingController sugOtherController = TextEditingController();
  bool hazardChecked = false;
  bool animalChecked = false;

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
      debugPrint("Sample saved");
      Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
    }
    ).onError((e, _) {
      debugPrint("Error saving user: $e");
    });
  }

  Future<bool> loadSampleData(sampleData) async {
    setState(() {
      numberController.text = sampleData["number"];
      codeController.text = sampleData["code"];
      formulaController.text = sampleData["formula"];
      keywordsController.text = sampleData["keywords"];
      selectedTypeOfSample = sampleData["type"];
      selectedMorphology = sampleData["morphology"];
      //Results variables//
      prevDiffractionController.text = sampleData["previousDiffraction"];
      prevThermalController.text = sampleData["previousThermal"];
      prevOpticalController.text = sampleData["previousOptical"];
      prevOtherController.text = sampleData["otherPrevious"];
      doiController.text = sampleData["doi"];
      //Suggestions variables//
      sugDiffractionController.text = sampleData["suggestionDiffraction"];
      sugThermalController.text = sampleData["suggestionThermal"];
      sugOpticalController.text = sampleData["suggestionOptical"];
      sugOtherController.text = sampleData["otherSuggestions"];
      animalChecked = sampleData["animals"];
      hazardChecked = sampleData["hazardous"];
      imageName = sampleData["image"];
    });
    if(imageName != "") {
      imageBytes = await storage.ref().child(imageName).getData();
    }
    return true;
  }

  void imagePicker() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Uint8List imageBytes = await pickedFile.readAsBytes();
      setState(() {
        this.imageBytes = imageBytes;
      });
      imagePath = File(pickedFile.path);
      debugPrint("Image path: $imagePath");
    }
  }

  Future<void> saveImage(String fileName) async {
    final ref = storage.ref().child(fileName);
    if (imagePath != null) {
      await ref.putFile(imagePath!);
    }
  }

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: tabs.length);
    _tabController.addListener(_handleTabSelection);
    Future.delayed(Duration.zero, () {
      loadSampleData(sampleData);
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
          SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Previous results",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: prevDiffractionController,
                        decoration: const InputDecoration(
                          label: Text("Previous diffraction means..."),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [

                    Expanded(
                      child: TextField(
                        controller: prevThermalController,
                        decoration: const InputDecoration(
                          label: Text("Previous thermal measurement"),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [

                    Expanded(
                      child: TextField(
                        controller: prevOpticalController,
                        decoration: const InputDecoration(
                          label: Text("Previous optical measurements..."),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [

                    Expanded(
                      child: TextField(
                        controller: prevOtherController ,
                        decoration: const InputDecoration(
                          label: Text("Other previous mesrurements"),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [

                    Expanded(
                      child: TextField(
                        controller: doiController,
                        decoration: const InputDecoration(
                          label: Text("doi*..."),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Suggestions for new measurements",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: sugDiffractionController,
                        decoration: const InputDecoration(
                          label: Text("Suggestion of diffraction measurements"),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: sugThermalController,
                        decoration: const InputDecoration(
                          label: Text("Suggestion of thermal measurements"),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: sugOpticalController,
                        decoration: const InputDecoration(
                          label: Text("Suggestion of optical measurements"),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: sugOtherController,
                        decoration: const InputDecoration(
                          label: Text("Other suggestion"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Hazardousness and Ethics",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Row(
                  children: [

                    Checkbox(
                      value: hazardChecked,
                      onChanged: (newBool){
                        setState(() {
                          hazardChecked = newBool!;
                        });
                      }, ),
                    const Text('Hazardous?'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: animalChecked,
                      onChanged: (newBool){
                        setState(() {
                          animalChecked = newBool!;
                        });
                      },
                    ),
                    const Text('Animals?'),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      imageBytes != null
                        ? InkWell(
                          onTap: imagePicker,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: MemoryImage(imageBytes!),
                                fit: BoxFit.cover,
                              ),
                            ),
                            width: 100,
                            height: 100,
                          ),
                        )
                        : ElevatedButton(onPressed: imagePicker, child: const Text("Add Image")),
                    ],
                  ),
                ),
              ],
            ),
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
                  "previousDiffraction": prevDiffractionController.text,
                  "previousThermal": prevThermalController.text,
                  "previousOptical": prevOpticalController.text,
                  "otherPrevious": prevOtherController.text,
                  "doi": doiController.text,
                  "suggestionDiffraction": sugDiffractionController.text,
                  "suggestionThermal": sugThermalController.text,
                  "suggestionOptical": sugOpticalController.text,
                  "otherSuggestions": sugOtherController.text,
                  "hazardous": hazardChecked,
                  "animals": animalChecked,
                  "image": imagePath != null ? sampleId : "",
                  "search": (codeController.text +
                      formulaController.text +
                      keywordsController.text +
                      selectedTypeOfSample +
                      selectedMorphology +
                      prevDiffractionController.text +
                      prevThermalController.text +
                      prevThermalController.text +
                      prevOpticalController.text +
                      prevOtherController.text +
                      sugDiffractionController.text +
                      sugThermalController.text +
                      sugOpticalController.text +
                      sugOtherController.text).toLowerCase()
                };

                updateSample(sample, sampleId);
                saveImage(sampleId);
              },
              child: const Text("Update Sample!"),
            )
          ],
        ),
      ),
    );
  }
}