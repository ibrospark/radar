import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String id;
  String senderId;
  String receiverId;
  String lastMessage;
  Timestamp timestamp;

  ChatModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.lastMessage,
    required this.timestamp,
  });

  factory ChatModel.fromMap(Map<String, dynamic> data) {
    return ChatModel(
      id: data['id'],
      senderId: data['senderId'],
      receiverId: data['receiverId'],
      lastMessage: data['lastMessage'],
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'lastMessage': lastMessage,
      'timestamp': timestamp,
    };
  }
}
