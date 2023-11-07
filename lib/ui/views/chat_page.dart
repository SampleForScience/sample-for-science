import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample/services/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserId;
  const ChatPage({super.key, required this.receiverUserEmail, required this.receiverUserId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController messageContrtoller = TextEditingController();
  final ChatService chatService = ChatService();
  
  void sendMessage() async {
    if (messageContrtoller.text.isNotEmpty) {
      await chatService.sendMessage(widget.receiverUserId, messageContrtoller.text);
      messageContrtoller.clear();
    }
  }

  Widget messageInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: messageContrtoller,
          ),
        ),
        IconButton(onPressed: sendMessage, icon: const Icon(Icons.send))
      ],
    );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: chatService.getMessages(widget.receiverUserId, auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        return ListView(
          children: snapshot.data!.docs.map((document) => messageItem(document)).toList(),
        );
      }
    );
  }

  Widget messageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    debugPrint("===== testando =====");
    debugPrint(data.toString());

    Alignment alignment = (data["senderId"] == auth.currentUser!.uid)
      ? Alignment.centerRight
      : Alignment.bottomCenter;

    return Container(
      alignment: alignment,
      child: Column(
        children: [
          Text(data["email"]),
          Text(data["message"]),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserEmail),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: messageList()),
          messageInput(),
        ],
      ),
    );
  }
}
