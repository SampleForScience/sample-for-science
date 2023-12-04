// TODO: criar botão e checagem nas funções getSample

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/providers/sample_provider.dart';

class PublicationButton extends StatefulWidget {
  final Map<String, dynamic> sampleData;

  const PublicationButton({super.key, required this.sampleData});

  @override
  State<PublicationButton> createState() => _PublicationButtonState();
}

class _PublicationButtonState extends State<PublicationButton> {
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Consumer<SampleProvider>(
      builder: (context, provider, child) {
        return IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Confirm Deletion"),
                  content: const Text("Are you sure you want to delete this sample?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Fecha o diálogo
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        db.collection("samples")
                            .doc(widget.sampleData["id"])
                            .delete()
                            .then((doc) => debugPrint("Sample deleted"),
                          onError: (e) => debugPrint("Error updating document $e"),
                        );
                        Provider.of<SampleProvider>(context, listen: false).getMySamples();
                        Navigator.of(context).pop();
                      },
                      child: const Text("Delete"),
                    ),
                  ],
                );
              },
            );
          },
          icon: widget.sampleData["publicationStatus"] == "Public"
            ? const Icon(Icons.visibility_rounded, color: Colors.black,)
            : const Icon(Icons.visibility_off, color: Colors.black,),
        );
      },
    );
  }
}
