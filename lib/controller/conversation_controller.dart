import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:radar/models/conversation_model.dart';

class ConversationController extends GetxController {
  var conversations = <Conversation>[].obs; // Liste observable de conversations
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchConversations(); // Charger les conversations lors de l'initialisation
    listenForNewConversations(); // Écoute en temps réel
  }

  // Méthode pour récupérer les conversations depuis la base de données
  Future<void> fetchConversations() async {
    try {
      final querySnapshot = await _firestore.collection('conversations').get();

      conversations.value = querySnapshot.docs.map((doc) {
        return Conversation.fromMap(doc.data());
      }).toList();
    } catch (e) {
      print("Erreur lors de la récupération des conversations: $e");
    }
  }

  // Méthode pour écouter les nouvelles conversations en temps réel
  void listenForNewConversations() {
    _firestore.collection('conversations').snapshots().listen((snapshot) {
      conversations.value = snapshot.docs.map((doc) {
        return Conversation.fromMap(doc.data());
      }).toList();
    });
  }

  // Méthode pour créer une nouvelle conversation
  Future<void> createConversation(String user1Id, String user2Id) async {
    try {
      final newConversation = Conversation(
        user1Id: user1Id,
        user2Id: user2Id,
        lastMessage: '',
        timestamp: DateTime.now(),
      );

      // Ajouter la conversation à Firestore
      final docRef = await _firestore
          .collection('conversations')
          .add(newConversation.toMap());
      newConversation.id =
          docRef.id; // Mettre à jour l'ID de la conversation locale
      conversations.add(newConversation); // Ajouter à la liste locale
    } catch (e) {
      print("Erreur lors de la création de la conversation: $e");
    }
  }

  // Méthode pour obtenir une conversation spécifique
  Conversation? getConversation(String user1Id, String user2Id) {
    return conversations.firstWhereOrNull(
      (conversation) =>
          (conversation.user1Id == user1Id &&
              conversation.user2Id == user2Id) ||
          (conversation.user1Id == user2Id && conversation.user2Id == user1Id),
    );
  }
}
