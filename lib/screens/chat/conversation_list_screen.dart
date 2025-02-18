import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radar/screens/chat/chat_sceen.dart';
import 'package:radar/utils/constants.dart';
import 'package:radar/utils/routes.dart';

class ConversationListView extends StatelessWidget {
  const ConversationListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations'),
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: rxConversationController.conversations.length,
          itemBuilder: (context, index) {
            final conversation = rxConversationController.conversations[index];
            return ListTile(
              title: Text(conversation.lastMessage),
              subtitle: Text(conversation.timestamp.toString()),
              onTap: () {
                // Naviguer vers la vue de chat pour cette conversation
                Get.to(() => ChatScreen(conversation: conversation));
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Naviguer vers une vue pour sélectionner un nouvel utilisateur ou démarrer une nouvelle conversation
          Get.toNamed(Routes.userList);
        },
        tooltip: 'Ajouter une conversation',
        child: const Icon(Icons.add),
      ),
    );
  }
}
