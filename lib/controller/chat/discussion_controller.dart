import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:radar/models/chat/discussion_model.dart';

class DiscussionController extends GetxController {
  var discussions = <Discussion>[].obs;
  var isLoading = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxString discussionId = "".obs;
  RxString receiverId = "".obs;
  Rx<Discussion> currentDiscussion = Discussion(
    discussionId: "",
    senderId: "",
    receiverId: "",
    messages: [],
    lastUpdated: Timestamp.now(),
  ).obs;

  // Fonction pour récupérer toutes les discussions pour un utilisateur
  Future<void> fetchDiscussions(String userId) async {
    try {
      isLoading(true);
      var querySnapshot = await _firestore
          .collection('discussions')
          .where('senderId', isEqualTo: userId)
          .get();

      var discussionsList = querySnapshot.docs.map((doc) {
        return Discussion.fromMap(doc.data());
      }).toList();

      discussions.value = discussionsList;
    } catch (e) {
      print("Erreur lors de la récupération des discussions: $e");
    } finally {
      isLoading(false);
    }
  }

  // Fonction pour créer une nouvelle discussion
  Future<void> createDiscussion(String senderId, String receiverId) async {
    try {
      // Générer un ID de discussion basé sur les deux IDs utilisateurs
      var discussionId = senderId.compareTo(receiverId) < 0
          ? '$senderId-$receiverId'
          : '$receiverId-$senderId';

      var newDiscussion = Discussion(
        discussionId: discussionId,
        senderId: senderId,
        receiverId: receiverId,
        messages: [],
        lastUpdated: Timestamp.now(),
      );

      // Vérifier si la discussion existe déjà
      var docSnapshot =
          await _firestore.collection('discussions').doc(discussionId).get();

      if (!docSnapshot.exists) {
        // Ajouter la nouvelle discussion à Firestore
        await _firestore
            .collection('discussions')
            .doc(discussionId)
            .set(newDiscussion.toMap());

        // Ajouter la discussion à la liste locale
        discussions.add(newDiscussion);
      } else {
        print("La discussion existe déjà.");
      }
    } catch (e) {
      print("Erreur lors de la création de la discussion: $e");
    }
  }
}
