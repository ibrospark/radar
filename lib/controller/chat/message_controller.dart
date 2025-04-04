import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radar/models/chat/discussion_model.dart';
import 'package:radar/models/chat/message_model.dart';

class MessageController extends GetxController {
  var messages = <Message>[].obs;
  var isLoading = false.obs;
  Rx<TextEditingController> messageController = TextEditingController().obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fonction pour récupérer les messages d'une discussion
  Future<void> fetchMessages(String discussionId) async {
    try {
      isLoading(true);
      var discussionDoc =
          await _firestore.collection('discussions').doc(discussionId).get();

      if (discussionDoc.exists) {
        var discussionData = discussionDoc.data();
        Discussion discussion = Discussion.fromMap(discussionData!);

        // Met à jour la liste des messages
        messages.value = discussion.messages;
      }
    } catch (e) {
      print("Erreur lors de la récupération des messages: $e");
    } finally {
      isLoading(false);
    }
  }

  // Fonction pour envoyer un message
  Future<void> sendMessage(
    String discussionId,
    String senderId,
    String receiverId,
    String content,
  ) async {
    try {
      var messageId = _firestore.collection('messages').doc().id;
      var newMessage = Message(
        messageId: messageId,
        senderId: senderId,
        receiverId: receiverId,
        content: content,
        timestamp: Timestamp.now(),
      );

      // Ajouter le message à Firestore
      await _firestore.collection('discussions').doc(discussionId).update({
        'messages': FieldValue.arrayUnion([newMessage.toMap()])
      });

      // Recharger les messages depuis Firestore pour garantir la cohérence
      await fetchMessages(discussionId);
    } catch (e) {
      print("Erreur lors de l'envoi du message: $e");
    }
  }
}
