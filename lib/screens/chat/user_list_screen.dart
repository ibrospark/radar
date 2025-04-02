import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/_builds/build_form.dart';
import 'package:radar/controller/chat/chat_controller.dart';
import 'package:radar/models/user_model.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController searchController = TextEditingController();
  List<UserModel> userList = [];
  List<UserModel> filteredList = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final snapshot = await _firestore.collection('users').get();
    final users = snapshot.docs
        .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
    setState(() {
      userList = users;
      filteredList = users;
    });
  }

  void filterUsers(String query) {
    setState(() {
      filteredList = userList.where((user) {
        final firstName = user.firstName?.toLowerCase() ?? '';
        final lastName = user.lastName?.toLowerCase() ?? '';
        return firstName.contains(query.toLowerCase()) ||
            lastName.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: "Rechercher un utilisateur"),
      body: Column(
        children: [
          buildSearchBar(),
          buildUserList(),
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: buildTextFormField(
        controller: searchController,
        prefix: const Icon(Icons.search),
        labelText: "Rechercher un utilisateur",
        onChanged: filterUsers,
      ),
    );
  }

  Widget buildUserList() {
    return Expanded(
      child: ListView.builder(
          itemCount: filteredList.length,
          itemBuilder: (context, index) => buildListTile(
                leading: CircleAvatar(
                  backgroundImage: filteredList[index].avatar != null
                      ? NetworkImage(filteredList[index].avatar!)
                      : const AssetImage('assets/images/avatar.png')
                          as ImageProvider,
                ),
                title: Text(
                    '${filteredList[index].firstName} ${filteredList[index].lastName}'),
                onTap: () {
                  Get.find<ChatController>()
                      .createNewChat(filteredList[index].id);
                  Get.back();
                },
              )),
    );
  }
}

class UserTile extends StatelessWidget {
  final UserModel user;

  const UserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return buildListTile(
      leading: CircleAvatar(
        backgroundImage: user.avatar != null
            ? NetworkImage(user.avatar!)
            : const AssetImage('assets/images/avatar.png') as ImageProvider,
      ),
      title: Text('${user.firstName} ${user.lastName}'),
      onTap: () {
        Get.find<ChatController>().createNewChat(user.id);
        Get.back();
      },
    );
  }
}
