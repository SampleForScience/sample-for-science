import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/providers/sample_provider.dart';
import 'package:sample/ui/buttons/favorite_provider_button.dart';
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
          return const Text("Loading users...");
        }

        Provider.of<SampleProvider>(context, listen: false).getFavoriteProviders();

        return Consumer<SampleProvider>(
          builder: (context, provider, child) {
            List<Map<String, dynamic>> favoriteProviders = provider.favoriteProviders;

            return ListView(
              children: favoriteProviders.map<Widget>((map) {
                return usersListItem(map);
              }).toList(),
            );
          },
        );
      },
    );
  }

  Widget usersListItem(Map<String, dynamic> data) {
    // Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    List<String> initials = data["name"].split(' ');

    if (data.isNotEmpty && auth.currentUser!.email != data["email"]) {
      return ListTile(
        title: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  minRadius: 25,
                  child: Text("${initials[0][0]} ${initials[initials.length - 1][0]}"),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${data["name"]}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '(${data["email"]})',
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          FavoriteProviderButton(providerData: data)
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
          ],
        ),
        onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute( builder: (context) =>
            ChatPage(
              receiverUserEmail: data["email"],
              receiverUserId: data["id"],
              receiverUserName: data["name"],
            )));
        });
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(highlight: Highlight.messages),
      appBar: AppBar(
        actions: [CircularAvatarButton()],
        title: const Text("Messages"),
      ),
      body: usersList(),
    );
  }
}
