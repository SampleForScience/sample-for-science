import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample/ui/widgets/buttons/circular_avatar_button.dart';
import 'package:sample/ui/widgets/buttons/drawer_logout_button.dart';

class NewSamplePage extends StatefulWidget {
  const NewSamplePage({super.key});

  @override
  State<NewSamplePage> createState() => _NewSamplePageState();
}

class _NewSamplePageState extends State<NewSamplePage> with SingleTickerProviderStateMixin {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  Map<String, dynamic> newSample = {};

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

  saveNewSample(Map<String, dynamic> newSample, String sampleId) async {
    await db.collection("samples").doc(sampleId).set(newSample).then((_) {
      debugPrint("New sample saved");
      Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
    }
    ).onError((e, _) {
      debugPrint("Error saving sample: $e");
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
      drawer: Drawer(
        width: 200,
        backgroundColor: const Color.fromARGB(255, 55, 98, 118),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 245, 252, 255),
              ),
              child: Image(image: AssetImage("assets/logo.png")),
            ),
            ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.apps,color: Colors.white),
                    Text(" Dashboard",style: TextStyle(color: Colors.white70)),
                  ],
                ),
                onTap: () {
                  debugPrint("Dashboard clicked");
                  Navigator.of(context).pushNamed('/dashboard');

                },
              ),

            Container(
              color: const Color.fromARGB(255, 245, 252, 255),
              child: ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.add),
                    Text(" Provide sample"),
                  ],
                ),
                onTap: () {
                  debugPrint("Provide sample clicked");
                  Navigator.of(context).pushNamed('/new-sample');
                },
              ),
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.search, color: Colors.white70),
                  Text(" Search", style: TextStyle(color: Colors.white70)),
                ],
              ),
              onTap: () {
                debugPrint("Search clicked");
                Navigator.pop(context);

              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.messenger_outline_sharp, color: Colors.white70),
                  Text(" Messages", style: TextStyle(color: Colors.white70)),
                ],
              ),
              onTap: () {
                debugPrint("Messages clicked");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.info, color: Colors.white70),
                  Text(" About", style: TextStyle(color: Colors.white70)),
                ],
              ),
              onTap: () {
                debugPrint("About clicked");
                Navigator.pop(context);
              },
            ),
            const DrawerLogoutButton(),
          ],
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
                            content: const Text("If you have any previous diffraction measurement comment here.\n\n Example:\n-Room temperature x-ray diffraction(Cu-radiation).\n-Temperature dependent neutrons diffraction"),
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
                        controller: sugDiffractionController,
                        decoration: const InputDecoration(
                          label: Text("Previous diffraction means..."),
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
                            content: const Text("If you have any previous thermal\nmeasurement,such as magnetization\nresistivity,specific heat, etc, comment here\n\nExample:\n-ZFC-FC for magnetization\n-Zero field specific heat"),
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
                            content: const Text("Include otpical measurements you have done to characterize your sample(s)"),
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
                          label: Text("Previous optical measurements..."),
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
                            content: const Text("If you have made any other\ncharacterization, please, comment here.\n\nExamples:\n-Optical or eletronical microscopies(SEM,TEM,...)\n-Mechanical characterization\n-etc"),
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
                    IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            content: const Text("This field is mandatory.\n\nProvide the reference(s) where your sample(s) were published"
                                " You only need to include the DOI - if more than one, separated by space"
                            ),
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
                    IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            content: const Text("Check this box if your sample:\n\n"
                                "-emits ionizing radiation:\n\n"
                                "or, if your sample is:\n\n"
                                "-toxic:\n-explosive:\n-flammable:\n-corrosive.\n\n"
                                "In other words, could adversely affect the\n"
                                "health and safety of the public or the workers or harm the environment."
                            ),
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
                    IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            content: const Text("If you have any previous thermal\nmeasurement,such as magnetization\nresistivity,specific heat, etc, comment here\n\nExample:\n-ZFC-FC for magnetization\n-Zero field specific heat"),
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