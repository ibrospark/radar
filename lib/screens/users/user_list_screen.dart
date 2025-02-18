import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/models/conversation_model.dart';
import 'package:radar/screens/chat/chat_sceen.dart';
import 'package:radar/utils/constants.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        title: "Discussions",
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: rxUserController.users.length,
          itemBuilder: (context, index) {
            final user = rxUserController.users[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.avatar.toString()),
              ),
              title: Text(user.lastName.toString()),
              onTap: () {
                // Créer ou obtenir la conversation
                final conversation = rxConversationController.getConversation(
                    rxUserController.users.first.id, user.id);
                if (conversation == null) {
                  // Si aucune conversation n'existe, créez-en une nouvelle
                  rxConversationController.conversations.add(Conversation(
                    user1Id: rxUserController.users.first.id,
                    user2Id: user.id,
                    lastMessage: '',
                    timestamp: DateTime.now(),
                  ));
                }
                // Naviguer vers la vue de chat
                Get.to(() => ChatScreen(conversation: conversation));
              },
            );
          },
        );
      }),
    );
  }
}
