import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/controller/chat/chat_controller.dart';
import 'package:radar/models/chat/message_model.dart';
import 'package:radar/utils/constants.dart';

final TextEditingController messageControllerText = TextEditingController();

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: "Messages"),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return buildMessageList(rxChatController.messageList);
            }),
          ),
          buildMessageInput(),
        ],
      ),
    );
  }
}

Widget buildMessageList(List<MessageModel> messages) {
  return ListView.builder(
    reverse: true,
    itemCount: messages.length,
    itemBuilder: (context, index) {
      final message = messages[index];
      bool isSentByMe = message.senderId == user!.uid;
      return buildMessageItem(message, isSentByMe);
    },
  );
}

Widget buildMessageItem(MessageModel message, bool isSentByMe) {
  return Align(
    alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: isSentByMe ? primaryColor : thirdColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment:
            isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isSentByMe)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                message.senderId,
                style: TextStyle(color: white, fontWeight: FontWeight.bold),
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
}

Widget buildMessageInput() {
  return Container(
    color: thirdColor,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageControllerText,
              decoration: InputDecoration(
                hintText: 'Saisissez votre message...',
                hintStyle: TextStyle(color: white),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 2,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: white,
            ),
            onPressed: () {
              if (messageControllerText.text.isNotEmpty) {
                ChatController().sendMessage(
                    rxChatController.generateChatId(
                      user!.uid,
                      rxChatController.receiverId.value,
                    ),
                    user!.uid,
                    messageControllerText.text);
                messageControllerText.clear();
              }
            },
          ),
        ],
      ),
    ),
  );
}
