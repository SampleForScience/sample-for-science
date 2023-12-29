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
  List<Map<String, dynamic>> usersToShow = [];
  List<String> foundChatRooms = [];

  Future<void>getProvidersToShow() async {
    try{
      await db.collection("users")
          .where("id", isEqualTo: auth.currentUser!.uid)
          .get()
          .then((querySnapshot) async {
        final users = querySnapshot.docs;
        for (var user in users) {
          setState(() {
            usersToShow = [...user["favoriteProviders"]];
          });
        }
      }, onError: (e) {
        debugPrint("Error completing: $e");
      });

      await db.collection("chat_rooms")
          .get()
          .then((querySnapshot) async {
        final chatRooms = querySnapshot.docs;
        for (var chatRoom in chatRooms) {
          setState(() {
            foundChatRooms.add(chatRoom.id);
          });
        }
      }, onError: (e) {
        debugPrint("Error completing: $e");
      });

      await db.collection("users").get().then((querySnapshot) async {
        bool alreadyFound = false;
        final users = querySnapshot.docs;
        for (var user in users) {
          for (var chatRoom in foundChatRooms) {
            if (chatRoom.contains(user["id"])) {
              for (var userToShow in usersToShow) {
                if (user["id"] == userToShow["id"]) {
                  alreadyFound = true;
                }
              }
              if (!alreadyFound) {
                setState(() {
                  usersToShow.add(user.data());
                });
              }
              alreadyFound = false;
            }
          }
        }
      }, onError: (e) {
        debugPrint("Error completing: $e");
      });

      debugPrint("Added");
    } catch(e) {
      debugPrint('error in getFavoriteProviders(): $e');
    }
  }

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

        return Consumer<SampleProvider>(
          builder: (context, provider, child) {
            // List<Map<String, dynamic>> favoriteProviders = provider.favoriteProviders;

            return ListView(
              children: usersToShow.map<Widget>((map) {
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
              )
            )
          );
        });
    } else {
      return Container();
    }
  }

  @override
  void initState() {
    super.initState();
    getProvidersToShow();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(highlight: Highlight.messages),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 85, 134, 158),
        actions: [CircularAvatarButton()],
        title: const Text("Messages", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: usersList(),
    );
  }
}
