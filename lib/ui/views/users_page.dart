import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample/ui/views/chat_page.dart';
import 'package:sample/ui/widgets/custom_drawer.dart';

import 'package:sample/ui/buttons/circular_avatar_button.dart';

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
        title: Row(
          children: [
            CircleAvatar(),
            const SizedBox(width: 8),
          Flexible(
            child:
            Text('${data["name"]}\n(${data["email"]})',
              overflow: TextOverflow.ellipsis,),

            )
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUserEmail: data["email"],
                receiverUserId: data["id"],
                receiverUserName: data["name"],
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
      drawer: const CustomDrawer(highlight: Highlight.messages),
      appBar: AppBar(
          actions: [
      CircularAvatarButton()],

        title: const Text("Messages"),
      ),
      body: usersList(),
    );
  }
}
