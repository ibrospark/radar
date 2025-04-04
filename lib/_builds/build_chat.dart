import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/_builds/build_form.dart';
import 'package:radar/models/user_model.dart';
import 'package:radar/screens/chat/message_sceen.dart';
import 'package:radar/utils/constants.dart';

// Build de la liste des discussions
Widget buildDiscussionList() {
  return Obx(() {
    return ListView.builder(
      itemCount: rxDiscussionController.discussions.length,
      itemBuilder: (context, index) {
        final discussion = rxDiscussionController.discussions[index];
        return buildListTile(
          leading: buildDiscussionAvatar(),
          title: buildDiscussionTitle(),
          subtitle: buildSubtitle(),
          onTap: () {
            rxDiscussionController.currentDiscussion.value = discussion;
            // Ouvrir la discussion spécifique
            Get.to(MessageScreenList());
          },
        );
      },
    );
  });
}

// Build du Loading Indicator
Widget buildLoading() {
  return Center(child: CircularProgressIndicator());
}

// Build de l'avatar de l'utilisateur dans la discussion
Widget buildDiscussionAvatar() {
  return Obx(() {
    return _buildUserAvatar(
        rxDiscussionController.currentDiscussion.value.receiverId);
  });
}

// Build du titre de chaque discussion
Widget buildDiscussionTitle() {
  return Obx(() {
    return _buildUserTitle(
        rxDiscussionController.currentDiscussion.value.receiverId);
  });
}

// Build du sous-titre de chaque discussion
Widget buildSubtitle() {
  return Obx(() {
    return Text(
      "Dernier message: ${rxMessageController.messages.isNotEmpty ? rxMessageController.messages.last.content : "Pas de message"}",
    );
  });
}

// Construire un avatar utilisateur de manière générique
Widget _buildUserAvatar(String userId) {
  return Obx(() {
    final selectedUser = rxUserController.users.firstWhere(
      (u) => u.id == userId,
      orElse: () => UserModel(
        id: '',
        firstName: 'Inconnu',
        lastName: '',
        phoneNumber: '',
        avatar: null,
      ),
    );
    return CircleAvatar(
      backgroundImage:
          selectedUser.avatar != null && selectedUser.avatar!.isNotEmpty
              ? NetworkImage(selectedUser.avatar!)
              : AssetImage('assets/images/default_avatar.png') as ImageProvider,
    );
  });
}

// Construire le titre d'un utilisateur de manière générique
Widget _buildUserTitle(String userId) {
  return Obx(() {
    final selectedUser = rxUserController.users.firstWhere(
      (u) => u.id == userId,
      orElse: () => UserModel(
        id: '',
        firstName: 'Inconnu',
        lastName: '',
        phoneNumber: '',
      ),
    );
    return Text(
      "${selectedUser.firstName} ${selectedUser.lastName} - ${selectedUser.phoneNumber != null && selectedUser.phoneNumber!.isNotEmpty ? selectedUser.phoneNumber : 'Numéro de téléphone non disponible'}",
    );
  });
}

// Build du message d'entrée
Widget buildMessageInput() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    decoration: BoxDecoration(
      color: thirdColor,
      border: Border(
        top: BorderSide(color: Colors.grey.shade300),
      ),
    ),
    child: Row(
      children: [
        Expanded(child: Obx(() {
          return buildTextFormField(
            controller: rxMessageController.messageController.value,
            maxLines: 5,
            labelText: "Tapez un message",
            disableLabel: false,
            onFieldSubmitted: (text) => _sendMessage(),
          );
        })),
        InkWell(
          onTap: _sendMessage,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor,
            ),
            child: Icon(Icons.send, color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

// Méthode pour envoyer un message
void _sendMessage() {
  rxMessageController.sendMessage(
    rxDiscussionController.discussionId.value,
    user!.uid,
    rxDiscussionController.receiverId.value,
    rxMessageController.messageController.value.text,
  );
}

// Build de la liste des messages
Widget buildMessageList() {
  return Obx(() {
    return ListView.builder(
      itemCount: rxMessageController.messages.length,
      itemBuilder: (context, index) {
        final message = rxMessageController.messages[index];
        final isSender = message.senderId == user!.uid;
        return _buildMessageItem(message, isSender);
      },
    );
  });
}

// Build de chaque élément du message
Widget _buildMessageItem(message, bool isSender) {
  return Align(
    alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: isSender ? primaryColor : thirdColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          bottomLeft: isSender ? Radius.circular(12) : Radius.zero,
          bottomRight: isSender ? Radius.zero : Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.content,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 4),
          Text(
            message.timestamp.toDate().toString(),
            style: TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    ),
  );
}
