import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:radar/models/message_model.dart';

class MessageController extends GetxController {
  var messages = <Message>[].obs; // Liste observable de messages
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Méthode pour récupérer les messages d'une conversation
  Future<void> fetchMessages(String conversationId) async {
    try {
      final querySnapshot = await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .get();

      messages.value = querySnapshot.docs.map((doc) {
        return Message.fromMap(doc.data());
      }).toList();
    } catch (e) {
      print("Erreur lors de la récupération des messages: $e");
    }
  }

  // Méthode pour envoyer un message
  Future<void> sendMessage(
      String conversationId, String senderId, String content) async {
    try {
      final newMessage = Message(
        senderId: senderId,
        content: content,
        timestamp: DateTime.now(),
      );

      // Sauvegarder le message dans Firestore
      final docRef = await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .add(newMessage.toMap());
      newMessage.id = docRef.id; // Associer l'ID du document créé
      messages.add(newMessage); // Ajouter le message à la liste locale
    } catch (e) {
      print("Erreur lors de l'envoi du message: $e");
    }
  }

  // Méthode pour écouter les nouveaux messages en temps réel
  void listenForNewMessages(String conversationId) {
    _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) {
      messages.value = snapshot.docs.map((doc) {
        return Message.fromMap(doc.data());
      }).toList();
    });
  }

  // Méthode pour obtenir tous les messages
  List<Message> getMessages() {
    return messages;
  }
}
