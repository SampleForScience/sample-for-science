import 'package:flutter/material.dart';

class SamplePage extends StatelessWidget {
  const SamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> sampleData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
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
            Text(sampleData["registration"],
              style: const TextStyle(
                fontSize: 16
              )
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
