import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:radar/models/chat/chat_model.dart';
import 'package:radar/models/chat/message_model.dart';
import 'package:radar/utils/constants.dart';

class ChatController extends GetxController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observables
  var chatList = <ChatModel>[].obs;
  var messageList = <MessageModel>[].obs;

  RxString receiverId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchChats();
  }

  // Récupérer les chats en cours
  void fetchChats() {
    if (user == null) {
      print("L'utilisateur n'est pas connecté.");
      return;
    }

    _firestore
        .collection('chats')
        .where('senderId', isEqualTo: user!.uid)
        .snapshots()
        .listen((snapshot) {
      chatList.value = snapshot.docs.map((doc) {
        return ChatModel.fromMap(doc.data());
      }).toList();
    });
  }

  // Récupérer les messages d'une chat spécifique
  void fetchMessages(String chatId) {
    _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      messageList.value = snapshot.docs.map((doc) {
        return MessageModel.fromMap(doc.data());
      }).toList();
    });
  }

  // Envoyer un message
  Future<void> sendMessage(
    String chatId,
    String receiverId,
    String content,
  ) async {
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

    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .set(newMessage.toMap());

    // Mettre à jour le dernier message dans le chat principal
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': content,
      'timestamp': Timestamp.now(),
    });
  }

  // Créer une nouvelle chat
  Future<void> createNewChat(String receiverId) async {
    String chatId = '${user!.uid}_$receiverId';

    DocumentReference chatRef = _firestore.collection('chats').doc(chatId);

    // Vérifier si le chat existe déjà
    DocumentSnapshot chatDoc = await chatRef.get();

    if (!chatDoc.exists) {
      ChatModel newChat = ChatModel(
        id: chatId,
        senderId: user!.uid,
        receiverId: receiverId,
        lastMessage: '',
        timestamp: Timestamp.now(),
      );

      await chatRef.set(newChat.toMap());
    }
  }

  String generateChatId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort(); // Trier les IDs pour garantir que l'ordre est toujours le même
    return ids.join('_'); // Renvoie "userId1_userId2"
  }
}
