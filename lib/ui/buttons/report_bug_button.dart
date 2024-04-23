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
  late String _imageUrl;
  File? _imageFile;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _init();
    _messageController = TextEditingController();
    _imageUrl = '';
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
          content: Text('Please, insert a text explaing the bug.'),
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

    _imageUrl = imageUrl ?? '';

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Thanks! Your report has been sent.'),
      ),
    );

    Navigator.of(context).pop();
  }

  Widget _buildDialog(BuildContext context) {
    return AlertDialog(
      title: Center(child: const Text('Report a bug')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Describe in details the bug you found"),
          SizedBox(height: 8),
          Container(
            width: 280,
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
          SizedBox(height: 8),
          Column(
            children: [
              ElevatedButton(
                onPressed: _getImageAndRefreshDialog,
                child: const Text('Upload Image'),
              ),
              SizedBox(width: 20),
            ],
          ),
          SizedBox(height: 8),
          _imageFile != null ? Image.file(_imageFile!, height: 95) : SizedBox(),
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
