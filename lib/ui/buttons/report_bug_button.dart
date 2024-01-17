import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportBugButton extends StatefulWidget {
  const ReportBugButton({super.key});

  @override
  State<ReportBugButton> createState() => _ReportBugButtonState();
}

class _ReportBugButtonState extends State<ReportBugButton> {
  late String packageVersion;
  late TextEditingController _messageController;
  late String _username;

  Future<void> getPackageVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      packageVersion = packageInfo.version;
    });
  }

  @override
  void initState() {
    Firebase.initializeApp();
    getPackageVersion();
    _messageController = TextEditingController();
    _username = FirebaseAuth.instance.currentUser?.displayName ?? 'Usuário Anônimo';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Row(
        children: [
          Icon(Icons.bug_report, color: Colors.white70),
          Text(" Report Bug", style: TextStyle(color: Colors.white70)),
        ],
      ),
      onTap: () {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      // Envia a mensagem para o Firebase
                      FirebaseFirestore.instance
                          .collection('bugs')
                          .add({
                            'version': packageVersion,
                            'username': _username,
                            'message': _messageController.text,
                          });

                      // Mostra a mensagem de confirmação
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text( 'Thank you. Your report has been sent'),
                        ),
                      );

                      Navigator.of(context).pop();
                    },
                    child: const Text('Send', style: TextStyle(fontSize: 16)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ],
              ),
            ],
            title: Center(child: const Text('Report a Bug')),
            content: Container(
              height: 150,
              width: 300,
              child: Column(
                children: [
                  Text("Por favor, detalhe o bug que você achou"),
                  Container(
                    width: 280,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        filled: false,
                      ),
                      maxLines: 4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
