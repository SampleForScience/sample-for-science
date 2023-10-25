import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SamplePage extends StatefulWidget {
  const SamplePage({super.key});

  @override
  State<SamplePage> createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  final storage = FirebaseStorage.instance;
  late Map<String, dynamic> sampleData;
  Uint8List? imageBytes;

  Future<void> loadSampleImage(String imageName) async {
    if(imageName != "") {
      imageBytes = await storage.ref().child(imageName).getData();
    }
    setState(() {
      imageBytes;
    });
  }

  String formatDateWithUserTimezone(DateTime dateTime) {
    final formatter = DateFormat('MM/dd/yyyy HH:mm', Intl.getCurrentLocale());
    return formatter.format(dateTime.toLocal());
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      setState(() {
        sampleData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      });
      loadSampleImage(sampleData["image"]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text("Sample"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Code",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(sampleData["code"],
              style: const TextStyle(
                fontSize: 16
              )
            ),
            const Divider(),
            const Text(
              "Number",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )
            ),
            Text(sampleData["number"],
              style: const TextStyle(
                fontSize: 16
              )
            ),
            const Divider(),
            const Text(
              "Formula",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )
            ),
            Text(sampleData["formula"],
              style: const TextStyle(
                fontSize: 16
              )
            ),
            const Divider(),
            const Text(
              "Type",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )
            ),
            Text(sampleData["type"],
              style: const TextStyle(
                fontSize: 16
              )
            ),
            const Divider(),
            const Text(
              "Morfology",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )
            ),
            Text(sampleData["morphology"],
              style: const TextStyle(
                fontSize: 16
              )
            ),
            const Divider(),
            const Text(
              "Keywords",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )
            ),
            Text(sampleData["keywords"],
              style: const TextStyle(
                fontSize: 16
              )
            ),
            const Divider(),
            const Text(
              "Registration",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )
            ),
            Text(formatDateWithUserTimezone(sampleData["registration"].toDate()),
              style: const TextStyle(
                fontSize: 16
              )
            ),
            const Divider(),
            if (imageBytes != null) Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: MemoryImage(imageBytes!),
                  fit: BoxFit.cover,
                ),
              ),
              width: 100,
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
