import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample/ui/views/chat_page.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Widget usersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: db.collection("users").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text ("Loading users...");
        }
        return ListView (
          children: snapshot.data!.docs.map<Widget>((doc) => usersListItem(doc)).toList(),
        );
      }
    );
  }

  Widget usersListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (data.isNotEmpty && auth.currentUser!.email != data["email"]) {
      return ListTile(
        title: Text(data["email"]),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUserEmail: data["email"],
                receiverUserId: data["id"],
              )
            )
          );
        }
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
      ),
      body: usersList(),
    );
  }
}
