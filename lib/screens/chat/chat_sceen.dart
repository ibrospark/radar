import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/models/conversation_model.dart';
import 'package:radar/models/message_model.dart';
import 'package:radar/utils/constants.dart';

class ChatScreen extends StatelessWidget {
  final Conversation? conversation;
  final TextEditingController messageControllerText = TextEditingController();

  ChatScreen({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        title: 'Discuter avec ${conversation?.user2Id}',
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              // Récupérer les messages de la conversation
              List<Message> messages = rxMessageController.getMessages();
              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  // Vérifiez si le message a été envoyé par l'utilisateur actuel
                  bool isSentByMe = message.senderId == user!.uid;

                  return Align(
                    alignment: isSentByMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: isSentByMe
                            ? Colors.blue
                            : thirdColor, // Couleur différente selon l'expéditeur
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: isSentByMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          // Si nécessaire, afficher l'ID de l'expéditeur
                          if (!isSentByMe)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                conversation?.user1Id ?? '',
                                style: TextStyle(
                                    color: white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          Text(
                            message.content,
                            style: TextStyle(color: white, fontSize: 16),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            message.timestamp.toString(),
                            style: TextStyle(color: white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Container(
            color: white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageControllerText,
                      decoration: const InputDecoration(
                        hintText: 'Saisissez votre message...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (messageControllerText.text.isNotEmpty) {
                        // Envoyer le message
                        rxMessageController.sendMessage(
                            conversation?.user1Id ?? '',
                            user!.uid,
                            messageControllerText.text);
                        messageControllerText
                            .clear(); // Effacer le champ de texte
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
