import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:sample/providers/sample_provider.dart";

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
            // TODO: Mostrar popup perguntando se quer tornar a amostra !publicationStatus
            DocumentReference<Map<String, dynamic>> docRef = FirebaseFirestore.instance.collection("samples").doc(widget.sampleData["id"]);

            // Navigator.pushReplacementNamed(context, "/dashboard");

            if(widget.sampleData["publicationStatus"] == "Public") {
              docRef.update({"publicationStatus": "Private"}).then((_) {
                setState(() {
                  widget.sampleData["publicationStatus"] = "Private";
                });
                debugPrint("Updated!");
              }).catchError((e) {
                debugPrint("Erro updating: $e");
              });
            } else {
              docRef.update({"publicationStatus": "Public"}).then((_) {
                setState(() {
                  widget.sampleData["publicationStatus"] = "Public";
                });
                debugPrint("Updated!");
              }).catchError((e) {
                debugPrint("Erro updating: $e");
              });
            }
          },
          icon: widget.sampleData["publicationStatus"] == "Public"
            ? const Icon(Icons.visibility_rounded, color: Colors.black,)
            : const Icon(Icons.visibility_off, color: Colors.black,),
        );
      },
    );
  }
}
