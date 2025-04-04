import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/screens/chat/user_search_screen.dart';
import 'package:radar/utils/constants.dart';

import '../../_builds/build_chat.dart';

class DiscussionListScreen extends StatelessWidget {
  const DiscussionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Charger les discussions de l'utilisateur
    rxDiscussionController.fetchDiscussions(user!.uid);

    return Scaffold(
      appBar: buildAppBar(
        title: "Mes Discussions",
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Action pour rechercher un utilisateur
              Get.to(UserSearchScreen());
            },
          ),
        ],
      ),
      body: Obx(() {
        if (rxDiscussionController.isLoading.value) {
          return buildLoading();
        } else {
          return buildDiscussionList();
        }
      }),
    );
  }
}
