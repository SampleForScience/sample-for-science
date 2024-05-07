import 'dart:io';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ReportBugButton extends StatefulWidget {
  const ReportBugButton({Key? key}) : super(key: key);

  @override
  State<ReportBugButton> createState() => _ReportBugButtonState();
}

class _ReportBugButtonState extends State<ReportBugButton> {
  late String packageVersion;
  late TextEditingController _messageController;
  late String _username;
  File? _imageFile;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _init();
    _messageController = TextEditingController();
  }

  Future<void> _init() async {
    await Firebase.initializeApp();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      packageVersion = packageInfo.version;
    });
    _username =
        FirebaseAuth.instance.currentUser?.displayName ?? 'Usuário Anônimo';
  }

  Future<File?> _getImage() async {
    print('Get Image function called');
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<void> _sendReport() async {
    if (_messageController.text.isEmpty) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please, insert a text explaining the bug.'),
        ),
      );
      return;
    }

    String? imageUrl;
    if (_imageFile != null) {
      final ref =
          _storage.ref().child('bugs/${DateTime.now().millisecondsSinceEpoch}');
      await ref.putFile(
          _imageFile!, SettableMetadata(contentType: 'image/jpeg'));
      imageUrl = await ref.getDownloadURL();
    }

    await _firestore.collection('bugs').add({
      'version': packageVersion,
      'username': _username,
      'message': _messageController.text,
      'image': imageUrl,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Thanks! Your report has been sent.'),
      ),
    );

    Navigator.of(context).pop();
  }

  Widget _buildDialog(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final imageWidth = screenSize.width * 0.6;

    return AlertDialog(
      title: Center(child: const Text('Report a bug')),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Describe in details the bug you found"),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    width: screenSize.width * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        filled: false,
                      ),
                      maxLines: 6,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: _getImageAndRefreshDialog,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Color.fromARGB(255, 85, 138, 163)),
                      ),
                      child: Center(
                        child: _imageFile != null
                            ? Image.file(_imageFile!, width: imageWidth)
                            : Icon(
                                Icons.image,
                                color: Color.fromARGB(255, 85, 138, 163),
                                size: 48,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _sendReport();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Send', style: TextStyle(fontSize: 16)),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _imageFile = null;
                    });
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close', style: TextStyle(fontSize: 16)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImageAndRefreshDialog() async {
    final File? imageFile = await _getImage();
    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => _buildDialog(context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Row(
        children: [
          Icon(Icons.bug_report, color: Colors.white70),
          Text("Report Bug", style: TextStyle(color: Colors.white70)),
        ],
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => _buildDialog(context),
        );
      },
    );
  }
}
