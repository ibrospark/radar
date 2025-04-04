import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/_builds/build_chat.dart';
import 'package:radar/utils/constants.dart';

class MessageScreenList extends StatelessWidget {
  const MessageScreenList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Charger les messages de la discussion
    rxMessageController
        .fetchMessages(rxDiscussionController.discussionId.value);

    return Scaffold(
      appBar: buildAppBar(
        leading: Wrap(
          children: [
            buildDiscussionAvatar(),
            buildDiscussionTitle(),
          ],
        ),
        // title: "Discussion",
        actions: [],
      ),
      body: Obx(() {
        if (rxMessageController.isLoading.value) {
          return buildLoading();
        } else {
          return Column(
            children: [
              Expanded(
                child: buildMessageList(),
              ),
              buildMessageInput(),
            ],
          );
        }
      }),
    );
  }
}
