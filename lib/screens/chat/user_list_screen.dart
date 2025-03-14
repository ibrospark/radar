import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/controller/chat/chat_controller.dart';
import 'package:radar/models/user_model.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController searchController = TextEditingController();
  List<UserModel> userList = [];
  List<UserModel> filteredList = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  // Récupérer la liste des utilisateurs depuis Firestore
  void fetchUsers() async {
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    userList = snapshot.docs
        .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
    setState(() {
      filteredList = userList;
    });
  }

  // Filtrer la liste des utilisateurs en fonction de la recherche
  void filterUsers(String query) {
    List<UserModel> filtered = userList.where((user) {
      return (user.firstName != null &&
              user.firstName!.toLowerCase().contains(query.toLowerCase())) ||
          user.lastName!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredList = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        title: "Rechercher un utilisateur",
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Rechercher un utilisateur...",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                filterUsers(value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                UserModel user = filteredList[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.avatar != null
                        ? NetworkImage(user.avatar!)
                        : AssetImage('assets/images/avatar.png')
                            as ImageProvider,
                  ),
                  title: Text('${user.firstName} ${user.lastName}'),
                  onTap: () {
                    // Démarrer une conversation avec cet utilisateur
                    Get.find<ChatController>().createNewChat(user.id);
                    Get.back(); // Retourner à la liste des discussions
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
