import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/models/chat/chat_model.dart';
import 'package:radar/screens/chat/message_sceen.dart';
import 'package:radar/screens/chat/user_list_screen.dart';
import 'package:radar/utils/constants.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: "Discussions"),
      body: Obx(() {
        return ListView.builder(
          itemCount: rxChatController.chatList.length,
          itemBuilder: (context, index) {
            ChatModel chat = rxChatController.chatList[index];
            return ListTile(
              title: Text("Discussion avec ${chat.receiverId}"),
              subtitle: Text(chat.lastMessage),
              onTap: () {
                rxChatController.receiverId.value = chat.receiverId;
                Get.to(() => MessageScreen());
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Rediriger vers la liste des utilisateurs pour démarrer une nouvelle conversation
          Get.to(() => UserListScreen());
        },
      ),
    );
  }
}
