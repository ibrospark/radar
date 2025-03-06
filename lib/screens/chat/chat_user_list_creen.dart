import 'package:flutter/material.dart';

class ChatUserListCreen extends StatefulWidget {
  const ChatUserListCreen({super.key});

  @override
  State<ChatUserListCreen> createState() => _ChatUserListCreenState();
}

class _ChatUserListCreenState extends State<ChatUserListCreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat User List'),
      ),
      body: ListView.builder(
        itemCount: 10, // Replace with the actual number of users
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text('User $index'), // Replace with actual user data
            subtitle: const Text('Last message preview'),
            onTap: () {
              // Handle user tap
            },
          );
        },
      ),
    );
  }
}
