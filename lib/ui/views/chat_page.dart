import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
            decoration: const InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              contentPadding: EdgeInsets.only(left: 12),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black38),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black38),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
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
    DateTime timestamp = (data["timestamp"] as Timestamp).toDate();
    // TODO: formatar de acordo com a localização
    String formattedTimestamp = DateFormat('dd/MM/yyyy HH:mm:ss').format(timestamp);

    Alignment alignment = (data["senderId"] == auth.currentUser!.uid)
      ? Alignment.centerRight
      : Alignment.centerLeft;

    CrossAxisAlignment crossAxisAlignment = (data["senderId"] == auth.currentUser!.uid)
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: alignment,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Text(
            formattedTimestamp,
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            width: 200,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              data["message"],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16
              ),
            )
          ),
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
