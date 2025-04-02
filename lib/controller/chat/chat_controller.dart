import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:radar/models/chat/chat_model.dart';
import 'package:radar/models/chat/message_model.dart';
import 'package:radar/utils/constants.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observables
  var chatList = <ChatModel>[].obs;
  var messageList = <MessageModel>[].obs;
  RxString receiverId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchChats();
  }

  /// Récupère la liste des chats de l'utilisateur connecté
  void fetchChats() {
    if (user == null) {
      print("L'utilisateur n'est pas connecté.");
      return;
    }

    _firestore
        .collection('chats')
        .where('senderId', isEqualTo: user!.uid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ChatModel.fromMap(doc.data())).toList())
        .listen(chatList.assignAll, onError: _handleError);
  }

  /// Récupère la liste des messages d'un chat spécifique
  void fetchMessages(String chatId) {
    if (chatId.isEmpty) {
      print("L'ID du chat est vide.");
      return;
    }

    _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(doc.data()))
            .toList())
        .listen(messageList.assignAll, onError: _handleError);
  }

  /// Envoie un message dans un chat donné
  Future<void> sendMessage(
      String chatId, String receiverId, String content) async {
    if ([chatId, receiverId, content].any((param) => param.isEmpty)) {
      print("Les paramètres du message sont invalides.");
      return;
    }

    try {
      String messageId = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc()
          .id;
      MessageModel newMessage = MessageModel(
        messageId: messageId,
        senderId: user!.uid,
        receiverId: receiverId,
        content: content,
        timestamp: Timestamp.now(),
      );

      WriteBatch batch = _firestore.batch();
      DocumentReference messageRef = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId);
      DocumentReference chatRef = _firestore.collection('chats').doc(chatId);

      batch.set(messageRef, newMessage.toMap());
      batch.update(
          chatRef, {'lastMessage': content, 'timestamp': Timestamp.now()});

      await batch.commit();
    } catch (e) {
      _handleError(e);
    }
  }

  /// Crée un nouveau chat entre l'utilisateur et un destinataire
  Future<void> createNewChat(String receiverId) async {
    if (receiverId.isEmpty) {
      print("L'ID du destinataire est vide.");
      return;
    }

    try {
      String chatId = generateChatId(user!.uid, receiverId);
      DocumentReference chatRef = _firestore.collection('chats').doc(chatId);
      if (!(await chatRef.get()).exists) {
        await chatRef.set(ChatModel(
          id: chatId,
          senderId: user!.uid,
          receiverId: receiverId,
          lastMessage: '',
          timestamp: Timestamp.now(),
        ).toMap());
      }
    } catch (e) {
      _handleError(e);
    }
  }

  /// Génère un ID unique pour un chat entre deux utilisateurs
  String generateChatId(String userId1, String userId2) {
    List<String> sortedIds = [userId1, userId2]..sort();
    return sortedIds.join('_');
  }

  /// Gère et affiche les erreurs
  void _handleError(dynamic error) => print("Erreur : $error");

  /// Supprime un message d'un chat
  Future<void> deleteMessage(String chatId, String messageId) async {
    if (chatId.isEmpty || messageId.isEmpty) {
      print("Les paramètres de suppression sont invalides.");
      return;
    }

    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .delete();
    } catch (e) {
      _handleError(e);
    }
  }

  /// Supprime un chat et tous ses messages
  Future<void> deleteChat(String chatId) async {
    if (chatId.isEmpty) {
      print("L'ID du chat est vide.");
      return;
    }

    try {
      WriteBatch batch = _firestore.batch();
      CollectionReference messagesRef =
          _firestore.collection('chats').doc(chatId).collection('messages');

      // Supprimer tous les messages du chat
      QuerySnapshot messagesSnapshot = await messagesRef.get();
      for (var doc in messagesSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Supprimer le chat lui-même
      batch.delete(_firestore.collection('chats').doc(chatId));

      await batch.commit();
    } catch (e) {
      _handleError(e);
    }
  }

  /// Marque un message comme lu
  Future<void> markMessageAsRead(String chatId, String messageId) async {
    if (chatId.isEmpty || messageId.isEmpty) {
      print("Les paramètres sont invalides.");
      return;
    }

    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .update({'isRead': true});
    } catch (e) {
      _handleError(e);
    }
  }

  /// Récupère la liste des chats où l'utilisateur est impliqué
  void fetchUserChats() {
    if (user == null) {
      print("L'utilisateur n'est pas connecté.");
      return;
    }

    _firestore
        .collection('chats')
        .where(Filter.or(
          Filter('senderId', isEqualTo: user!.uid),
          Filter('receiverId', isEqualTo: user!.uid),
        ))
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ChatModel.fromMap(doc.data())).toList())
        .listen(chatList.assignAll, onError: _handleError);
  }
}
