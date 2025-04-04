import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:radar/models/chat/message_model.dart';

class Discussion {
  final String discussionId;
  final String senderId;
  final String receiverId;
  final List<Message> messages;
  final Timestamp lastUpdated;

  Discussion({
    required this.discussionId,
    required this.senderId,
    required this.receiverId,
    required this.messages,
    required this.lastUpdated,
  });

  // Convertir la discussion en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'discussionId': discussionId,
      'senderId': senderId,
      'receiverId': receiverId,
      'messages': messages.map((e) => e.toMap()).toList(),
      'lastUpdated': lastUpdated,
    };
  }

  // Créer une discussion à partir d'un Map (Firestore)
  factory Discussion.fromMap(Map<String, dynamic> map) {
    var messagesFromMap = map['messages'] as List? ?? [];
    List<Message> messageList = messagesFromMap
        .map((msgMap) => Message.fromMap(msgMap as Map<String, dynamic>))
        .toList();

    return Discussion(
      discussionId: map['discussionId'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      messages: messageList,
      lastUpdated: map['lastUpdated'] ?? Timestamp.now(),
    );
  }
}
