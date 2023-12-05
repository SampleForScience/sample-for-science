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
  TextEditingController otherTypeController = TextEditingController();
  TextEditingController otherMorphologyController = TextEditingController();
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
  // Hazard variables
  bool hazardChecked = false;
  bool animalChecked = false;
  // Status variable
  String publicationStatus = "Public";

  List<String> typeOfsampleList = <String>[
    "Ceramics",
    "Metals",
    "Metal-organic",
    "Polymer / Plastic",
    "Other"
  ];
  String selectedTypeOfSample = "";

  List<String> morphologyList = <String>[
    "Composite",
    "Nano(particle, wire, ...)",
    "Film(thin, thick, ...)",
    "Bulk",
    "Other"
  ];
  String selectedMorphology = "";

  List<Tab> tabs = <Tab>[
    const Tab(text: "Basics",),
    const Tab(text: "Results",),
    const Tab(text: "Suggestions",),
    const Tab(text: "Hazard",),
    const Tab(text: "Status",),
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
      if(sampleData["type"]== "Other"){
        otherTypeController.text = sampleData["otherType"];
      }
      selectedMorphology = sampleData["morphology"];
      if(sampleData["morphology"]=="Other"){
        otherMorphologyController.text = sampleData["otherMorphology"];
      }
      prevDiffractionController.text = sampleData["previousDiffraction"];
      prevThermalController.text = sampleData["previousThermal"];
      prevOpticalController.text = sampleData["previousOptical"];
      prevOtherController.text = sampleData["otherPrevious"];
      doiController.text = sampleData["doi"];
      sugDiffractionController.text = sampleData["suggestionDiffraction"];
      sugThermalController.text = sampleData["suggestionThermal"];
      sugOpticalController.text = sampleData["suggestionOptical"];
      sugOtherController.text = sampleData["otherSuggestions"];
      animalChecked = sampleData["animals"];
      hazardChecked = sampleData["hazardous"];
      publicationStatus = sampleData["publicationStatus"];
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
                if (selectedTypeOfSample == "Other") TextField(
                  controller: otherTypeController,
                  decoration: const InputDecoration(
                    label: Text("Type of sample"),
                  ),
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
                ),
                if (selectedMorphology == "Other") TextField(
                  controller: otherMorphologyController,
                  decoration: const InputDecoration(
                    label: Text("Morphology"),
                  ),
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
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      imageBytes != null
                      ? Column(
                        children: [
                          InkWell(
                            onTap: () {
                              debugPrint("Image Clicked");
                            },
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
                          ),
                          ElevatedButton(onPressed: imagePicker, child: const Text("Change Image")),
                        ],
                      )
                      : ElevatedButton(onPressed: imagePicker, child: const Text("Add Image")),
                    ],
                  ),
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
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Publication Status",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                content: const Text("Public - everyone will be able to see the sample"),
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
                        const SizedBox(height: 7,),
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                content: const Text("Private - only you will be able to see the sample"),
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
                      ],
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          RadioListTile(
                            title: const Text('Public'),
                            value: 'Public',
                            groupValue: publicationStatus,
                            onChanged: (value) {
                              setState(() {
                                publicationStatus = value.toString();
                              });
                            },
                          ),
                          RadioListTile(
                            title: const Text('Private'),
                            value: 'Private',
                            groupValue: publicationStatus,
                            onChanged: (value) {
                              setState(() {
                                publicationStatus = value.toString();
                              });
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                )
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
                  "otherType": selectedTypeOfSample == "Other" ? otherTypeController.text : "",
                  "morphology": selectedMorphology,
                  "otherMorphology": selectedMorphology == "Other" ? otherMorphologyController.text : "",
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
                  "publicationStatus": publicationStatus,
                  "search": (codeController.text +
                      formulaController.text +
                      keywordsController.text +
                      selectedTypeOfSample +
                      otherTypeController.text +
                      selectedMorphology +
                      otherMorphologyController.text +
                      prevDiffractionController.text +
                      prevThermalController.text +
                      prevThermalController.text +
                      prevOpticalController.text +
                      prevOtherController.text +
                      sugDiffractionController.text +
                      sugThermalController.text +
                      sugOpticalController.text +
                      sugOtherController.text).toLowerCase().replaceAll(" ", "")
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