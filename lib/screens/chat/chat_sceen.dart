import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/_builds/build_chat.dart';
import 'package:radar/models/chat/conversation_model.dart';
import 'package:radar/models/chat/message_model.dart';
import 'package:radar/utils/constants.dart';

class ChatScreen extends StatelessWidget {
  final Conversation? conversation;
  final TextEditingController messageControllerText = TextEditingController();

  ChatScreen({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        title: 'Discuter avec ${conversation?.receiverId}',
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              List<Message> messages = rxMessageController.getMessages();
              return buildMessageList(messages);
            }),
          ),
          buildMessageInput(),
        ],
      ),
    );
  }
}
