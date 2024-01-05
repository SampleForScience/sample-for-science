import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/providers/sample_provider.dart';

class SeeSampleButton extends StatefulWidget {
  final Map<String, dynamic> sampleData;

  const SeeSampleButton({super.key, required this.sampleData});

  @override
  State<SeeSampleButton> createState() => _SeeSampleButtonState();
}

class _SeeSampleButtonState extends State<SeeSampleButton> {
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Consumer<SampleProvider>(
      builder: (context, provider, child) {
        return IconButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              "/sample",
              arguments: widget.sampleData,
            );
          },
          icon: const Icon(
            Icons
                .sticky_note_2_outlined,
            color: Colors.black,
          ),
        );
      },
    );
  }
}
