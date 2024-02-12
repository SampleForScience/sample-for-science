import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sample/services/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserId;
  final String receiverUserName;
  const ChatPage(
      {super.key,
      required this.receiverUserEmail,
      required this.receiverUserId,
      required this.receiverUserName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController messageContrtoller = TextEditingController();
  final ChatService chatService = ChatService();

  void sendMessage() async {
    if (messageContrtoller.text.isNotEmpty) {
      await chatService.sendMessage(
          widget.receiverUserId, messageContrtoller.text);
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
            onSubmitted: (value) {
              sendMessage();
            },
          ),
        ),
        IconButton(onPressed: sendMessage, icon: const Icon(Icons.send))
      ],
    );
  }

  Widget messageList() {
    return StreamBuilder(
        stream: chatService.getMessages(
            widget.receiverUserId, auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          return ListView(
            children: snapshot.data!.docs
                .map((document) => messageItem(document))
                .toList(),
          );
        });
  }

  Widget messageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    DateTime timestamp = (data["timestamp"] as Timestamp).toDate();
    String formattedTimestamp =
        DateFormat('dd/MM/yyyy HH:mm:ss').format(timestamp);

    bool isMyMessage = (data["senderId"] == auth.currentUser!.uid);

    Alignment alignment =
        isMyMessage ? Alignment.centerRight : Alignment.centerLeft;

    CrossAxisAlignment crossAxisAlignment =
        isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    Color boxColor =
        isMyMessage ? Colors.blue : Color.fromARGB(99, 58, 108, 245);

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
              color: boxColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              data["message"],
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                '${widget.receiverUserName} (${widget.receiverUserEmail})',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: messageList()),
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 24.0),
            child: messageInput(),
          ),
        ],
      ),
    );
  }
}
