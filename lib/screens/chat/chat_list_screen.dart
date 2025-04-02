import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/models/chat/chat_model.dart';
import 'package:radar/screens/chat/message_sceen.dart';
import 'package:radar/screens/chat/user_list_screen.dart';
import 'package:radar/utils/constants.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: "Discussions"),
      body: Obx(() {
        return ListView.builder(
          itemCount: rxChatController.chatList.length,
          itemBuilder: (context, index) {
            ChatModel chat = rxChatController.chatList[index];
            return buildListTile(
              title: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(chat.receiverId)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return buildText(
                      text: "Chargement...",
                      overflow: TextOverflow.visible,
                    );
                  }
                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      !snapshot.data!.exists) {
                    return buildText(
                      text: "Utilisateur inconnu",
                      overflow: TextOverflow.visible,
                    );
                  }
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  final receiverName =
                      userData['name'] ?? "Utilisateur inconnu";
                  return buildText(
                    text: "Discussion avec $receiverName",
                    overflow: TextOverflow.visible,
                  );
                },
              ),
              subtitle: buildText(
                text: chat.lastMessage,
                overflow: TextOverflow.visible,
              ),
              onTap: () {
                rxChatController.receiverId.value = chat.receiverId;
                rxChatController.fetchMessages(chat.id);
                Get.to(() => const MessageScreen());
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Rediriger vers la liste des utilisateurs pour démarrer une nouvelle conversation
          Get.to(() => const UserListScreen());
        },
      ),
    );
  }
}
