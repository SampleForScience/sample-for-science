import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sample/ui/buttons/circular_avatar_button.dart';
import 'package:sample/ui/widgets/custom_drawer.dart';

class NewSamplePage extends StatefulWidget {
  const NewSamplePage({super.key});

  @override
  State<NewSamplePage> createState() => _NewSamplePageState();
}

class _NewSamplePageState extends State<NewSamplePage>
    with SingleTickerProviderStateMixin {
  final db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final auth = FirebaseAuth.instance;
  Map<String, dynamic> newSample = {};
  File? imagePath;
  Uint8List? imageBytes;

  //Basics variables//
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
  // Hazard variables
  bool hazardChecked = false;
  bool animalChecked = false;
  // Status variable
  String publicationStatus = "Public";

  List<String> typeOfSampleList = <String>[
    "Ceramics",
    "Metals",
    "Metal-organic",
    "Polymer / Plastic",
    "Other"
  ];
  String selectedTypeOfSample = "";
  TextEditingController otherTypeController = TextEditingController();

  List<String> morphologyList = <String>[
    "Composite",
    "Nano(particle, wire, ...)",
    "Film(thin, thick, ...)",
    "Bulk",
    "Other"
  ];
  String selectedMorphology = "";
  TextEditingController otherMorphologyController = TextEditingController();

  List<Tab> tabs = <Tab>[
    const Tab(
      text: "Basics",
    ),
    const Tab(
      text: "Results",
    ),
    const Tab(
      text: "Suggestions",
    ),
    const Tab(
      text: "Hazard",
    ),
    const Tab(
      text: "Status",
    ),
  ];
  late TabController _tabController;

  void _handleTabSelection() {
    setState(() {
      _tabController.index;
    });
  }

  void saveNewSample(Map<String, dynamic> newSample, String sampleId) async {
    await db.collection("samples").doc(sampleId).set(newSample).then((_) {
      debugPrint("New sample saved");
      Navigator.pushNamedAndRemoveUntil(
          context, '/dashboard', (route) => false);
    }).onError((e, _) {
      debugPrint("Error saving sample: $e");
    });
  }

  Future<void> saveImage(String fileName) async {
    final ref = storage.ref().child(fileName);
    if (imagePath != null) {
      await ref.putFile(imagePath!);
    }
  }

  void imagePicker() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Uint8List imageBytes = await pickedFile.readAsBytes();
      setState(() {
        this.imageBytes = imageBytes;
      });
      imagePath = File(pickedFile.path);
      debugPrint("Image path: $imagePath");
    }
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
        backgroundColor: const Color.fromARGB(255, 85, 134, 158),
        title:
            const Text("Provide Sample", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: const [CircularAvatarButton()],
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs,
        ),
      ),
      drawer: const CustomDrawer(highlight: Highlight.provide),
      body: TabBarView(controller: _tabController, children: [
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
                          content: const Text(
                              "You can provide a single sample or a pack.Type the total amount of samples."),
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
                          content:
                              const Text("Assign a code for your sample(s)."),
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
                          content: const Text(
                              "Inform the chemical formula for your sample(s). If you are providing a pack of samples, you can simplify the chemical formula.\n\nUsers will find your samples based on this field."),
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
                          content: const Text(
                              "Provide a maximum of five keywords for your samples separated by comma.\n\nUsers will find your samples based on this field."),
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
                    dropdownMenuEntries: typeOfSampleList
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
                  ),
                ],
              ),
              if (selectedTypeOfSample == "Other")
                TextField(
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
                    initialSelection: "",
                    onSelected: (String? value) {
                      setState(() {
                        selectedMorphology = value!;
                      });
                    },
                    dropdownMenuEntries: morphologyList
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
                  ),
                ],
              ),
              if (selectedMorphology == "Other")
                TextField(
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
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          content: const Text(
                              "If you have any previous diffraction measurement comment here.\n\n Example:\n-Room temperature x-ray diffraction(Cu-radiation).\n-Temperature dependent neutrons diffraction"),
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
                      controller: prevDiffractionController,
                      decoration: const InputDecoration(
                        label: Text("Previous diffraction measurement"),
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
                          content: const Text(
                              "If you have any previous thermal\nmeasurement,such as magnetization\nresistivity,specific heat, etc, comment here\n\nExample:\n-ZFC-FC for magnetization\n-Zero field specific heat"),
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
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          content: const Text(
                              "Include optical measurements you have done to characterize your sample(s)"),
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
                      controller: prevOpticalController,
                      decoration: const InputDecoration(
                        label: Text("Previous optical measurements"),
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
                          content: const Text(
                              "If you have made any other characterization, please, comment here.\n\nExamples:\n-Optical or electronical microscopies(SEM,TEM,...)\n-Mechanical characterization\n-etc"),
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
                      controller: prevOtherController,
                      decoration: const InputDecoration(
                        label: Text("Other previous measurements"),
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
                          content: const Text(
                              "This field is mandatory.\n\nProvide the reference where your sample were published."),
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
                                  debugPrint("Image clicked");
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
                              ElevatedButton(
                                  onPressed: imagePicker,
                                  child: const Text("Change Image")),
                            ],
                          )
                        : ElevatedButton(
                            onPressed: imagePicker,
                            child: const Text("Add Image")),
                  ],
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(12),
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
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          content: const Text(
                              "Check this box if your sample emits ionizing radiation or if your sample is:\n- toxic\n- explosive\n- flammable\n- corrosive\n\nIn other words, could adversely affect the health and safety of the public or the workers or harm the environment."),
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
                  Checkbox(
                    value: hazardChecked,
                    onChanged: (newBool) {
                      setState(() {
                        hazardChecked = newBool!;
                      });
                    },
                  ),
                  const Text('Hazardous?'),
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
                          content: const Text(
                              "Check this box if your samples depend on animals (or animals-related products) to be synthesized."),
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
                  Checkbox(
                    value: animalChecked,
                    onChanged: (newBool) {
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
                              content: const Text(
                                  "Public - everyone will be able to see the sample"),
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
                      const SizedBox(
                        height: 7,
                      ),
                      IconButton(
                        icon: const Icon(Icons.info_outline),
                        onPressed: () {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              content: const Text(
                                  "Private - only you will be able to see the sample"),
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
      ]),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (_tabController.index > 0)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _tabController.index--;
                  });
                  _tabController.animateTo(_tabController.index);
                },
                child: const Text("Back"),
              ),
            if (_tabController.index < tabs.length - 1)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _tabController.index++;
                  });
                  _tabController.animateTo(_tabController.index);
                },
                child: const Text("Next"),
              ),
            if (_tabController.index == tabs.length - 1)
              ElevatedButton(
                onPressed: () {
                  String uid = auth.currentUser!.uid;
                  DateTime registrationDate = DateTime.now();
                  String millisecondsTimeStamp =
                      registrationDate.millisecondsSinceEpoch.toString();
                  String sampleId = "$uid$millisecondsTimeStamp";

                  newSample = {
                    "id": sampleId,
                    "provider": uid,
                    "number": numberController.text,
                    "code": codeController.text,
                    "formula": formulaController.text,
                    "keywords": keywordsController.text,
                    "type": selectedTypeOfSample,
                    "otherType": selectedTypeOfSample == "Other"
                        ? otherTypeController.text
                        : "",
                    "morphology": selectedMorphology,
                    "otherMorfology": selectedMorphology == "Other"
                        ? otherMorphologyController.text
                        : "",
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
                    "registration": registrationDate,
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
                            sugOtherController.text)
                        .toLowerCase()
                        .replaceAll(" ", "")
                  };

                  saveNewSample(newSample, sampleId);
                  saveImage(sampleId);
                },
                child: const Text("Add Sample!"),
              )
          ],
        ),
      ),
    );
  }
}
