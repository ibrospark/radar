import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/utils/constants.dart';

class UserSearchScreen extends StatelessWidget {
  const UserSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Rechercher les utilisateurs
    rxUserController.fetchAllUsers();

    return Scaffold(
      appBar: buildAppBar(
        title: ("Rechercher un utilisateur"),
      ),
      body: Obx(() {
        if (rxUserController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: rxUserController.users.length,
            itemBuilder: (context, index) {
              return buildListTile(
                title: Text(
                    "${rxUserController.users[index].firstName!} ${rxUserController.users[index].lastName}"),
                subtitle: buildText(
                  text: rxUserController.users[index].phoneNumber ??
                      user?.phoneNumber ??
                      'No phone number available',
                  color: white,
                ),
                onTap: () async {
                  // Créer une nouvelle discussion avec l'utilisateur sélectionné
                  await rxDiscussionController.createDiscussion(
                      user!.uid, rxUserController.users[index].id);
                  Get.back(); // Retour à l'écran précédent après création
                },
              );
            },
          );
        }
      }),
    );
  }
}
