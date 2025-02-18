import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/models/offer_subscription_model.dart';

class OfferSubscriptionController extends GetxController {
  var offersSubscriptions = <OfferSubscription>[].obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference get _offersSubscriptionsCollection =>
      firestore.collection('offers subscriptions'); // Corrected name

  Stream<QuerySnapshot> get offersStream =>
      _offersSubscriptionsCollection.snapshots();

  @override
  void onInit() {
    super.onInit();
    loadUserSubscriptions();
  }

  User? get currentUser => auth.currentUser;

  Future<void> loadUserSubscriptions() async {
    if (currentUser == null) {
      _log("No user is currently signed in.");
      return;
    }

    try {
      final snapshot = await _offersSubscriptionsCollection
          .where('idUser', isEqualTo: currentUser!.uid)
          .get();

      offersSubscriptions.value = snapshot.docs
          .map((doc) =>
              OfferSubscription.fromMap(doc.data() as Map<String, dynamic>)
                ..id = doc.id)
          .toList();
    } catch (e) {
      _log("Error loading subscriptions: $e");
    }
  }

  Future<void> addSubscription({
    required String name,
    required int price,
    required int numberOfPublication,
    required int numberOfDay,
  }) async {
    if (currentUser == null) {
      _log("No user is currently signed in.");
      return;
    }

    try {
      await _removeActiveSubscriptions(); // Ensure only one active subscription

      final DateTime startedAt = DateTime.now();
      final DateTime expiredAt = startedAt.add(Duration(days: numberOfDay));

      final newSubscriptionData = {
        'idUser': currentUser!.uid,
        'name': name,
        'price': price,
        'numberOfPublication': numberOfPublication,
        'numberOfDay': numberOfDay,
        'isActive': true,
        'startedAt': startedAt,
        'expiredAt': expiredAt,
      };

      final docRef =
          await _offersSubscriptionsCollection.add(newSubscriptionData);

      offersSubscriptions.add(OfferSubscription(
        id: docRef.id,
        idUser: currentUser!.uid,
        name: name,
        price: price,
        numberOfPublication: numberOfPublication,
        numberOfDay: numberOfDay,
        isActive: true,
        startedAt: startedAt,
        expiredAt: expiredAt,
      ));
      buildSnackbar(
        title: "Succès !",
        message: "Offre activé avec succès.",
      );
    } catch (e) {
      _log("Error adding subscription: $e");
    }
  }

  Future<void> _removeActiveSubscriptions() async {
    if (currentUser == null) return;

    final existingSubscriptions = await _offersSubscriptionsCollection
        .where('idUser', isEqualTo: currentUser!.uid)
        .where('isActive', isEqualTo: true)
        .get();

    if (existingSubscriptions.docs.isNotEmpty) {
      final WriteBatch batch = firestore.batch();

      for (var doc in existingSubscriptions.docs) {
        batch.delete(_offersSubscriptionsCollection.doc(doc.id));
      }

      await batch.commit();
      offersSubscriptions.removeWhere((sub) => sub.isActive == true);
    }
  }

  Future<void> updateSubscription(OfferSubscription subscription) async {
    final index =
        offersSubscriptions.indexWhere((sub) => sub.id == subscription.id);

    if (index != -1) {
      try {
        await _offersSubscriptionsCollection
            .doc(subscription.id)
            .update(subscription.toMap());

        offersSubscriptions[index] = subscription; // Update the local state
      } catch (e) {
        _log("Error updating subscription: $e");
      }
    }
  }

  Future<void> deleteSubscription(String id) async {
    try {
      await _offersSubscriptionsCollection.doc(id).delete();
      offersSubscriptions.removeWhere((sub) => sub.id == id);
    } catch (e) {
      _log("Error deleting subscription: $e");
    }
  }

  Future<void> decreasePublicationCount(int index, int decrementBy) async {
    if (_isValidIndex(index)) {
      final subscription = offersSubscriptions[index];
      if (subscription.numberOfPublication! >= decrementBy) {
        subscription.numberOfPublication =
            subscription.numberOfPublication! - decrementBy;
        _updatePublicationCount(subscription);
      } else {
        _log("Not enough publications to decrement.");
      }
    } else {
      _log("Invalid subscription index.");
    }
  }

  void increasePublicationCount(int index, int incrementBy) {
    if (_isValidIndex(index)) {
      final subscription = offersSubscriptions[index];
      subscription.numberOfPublication =
          (subscription.numberOfPublication ?? 0) + incrementBy;
      _updatePublicationCount(subscription);
    } else {
      _log("Invalid subscription index.");
    }
  }

  Future<void> _updatePublicationCount(OfferSubscription subscription) async {
    try {
      await _offersSubscriptionsCollection
          .doc(subscription.id)
          .update({'numberOfPublication': subscription.numberOfPublication});
      _log("Updated Firestore with new publication count.");
    } catch (e) {
      _log("Error updating Firestore: $e");
    }
  }

  bool _isValidIndex(int index) =>
      index >= 0 && index < offersSubscriptions.length;

  void _log(String message) {
    if (kDebugMode) {
      print(message);
    }
  }
}
