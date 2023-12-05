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
            debugPrint("publicationStatus button clicked..."); // TODO: função para mudar status
          },
          icon: widget.sampleData["publicationStatus"] == "Public"
            ? const Icon(Icons.visibility_rounded, color: Colors.black,)
            : const Icon(Icons.visibility_off, color: Colors.black,),
        );
      },
    );
  }
}
