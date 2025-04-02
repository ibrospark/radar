import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/utils/constants.dart';

import '../../_builds/build_chat.dart';

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
