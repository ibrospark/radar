import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:radar/models/offer/offer_model.dart';
import 'package:radar/_builds/build_all_elements.dart';

class OfferController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final offers = <Offer>[].obs;
  final isLoading = false.obs;

  // Collection Firestore
  CollectionReference get offersCollection => _firestore.collection('offers');

  @override
  void onInit() {
    super.onInit();
    fetchOffers(); // Charger les offres au démarrage
  }

  // Récupérer toutes les offres depuis Firestore
  Future<void> fetchOffers() async {
    try {
      isLoading.value = true;
      final querySnapshot = await offersCollection.get();
      // Charger les offres
      offers.value = querySnapshot.docs
          .map((doc) => Offer.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      // Trier les offres par prix croissant, en prenant en compte les valeurs nulles
      offers.sort((a, b) {
        final aPrice = a.price ??
            double.infinity; // Considérer les prix nuls comme infinis
        final bPrice = b.price ??
            double.infinity; // Considérer les prix nuls comme infinis
        return aPrice.compareTo(bPrice);
      });
    } catch (e) {
      buildSnackbar(
        title: "Erreur !",
        message: "Impossible de récupérer les offres.",
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Ajouter une offre et sauvegarder l'ID généré dans le document
  Future<void> addOffer(Offer offer) async {
    try {
      // Ajouter le document dans Firestore (génération automatique de l'ID)
      final docRef = await offersCollection.add(offer.toMap());

      // Récupérer l'ID généré automatiquement
      final generatedId = docRef.id;

      // Mettre à jour l'offre avec l'ID généré dans Firestore
      await docRef.update({'id': generatedId});

      // Affecter l'ID à l'objet dans l'application
      offer.id = generatedId;

      // Ajouter l'offre à la liste observée
      offers.add(offer);
      buildSnackbar(
        title: "Succès !",
        message: "Offre ajoutée avec succès.",
      );
    } catch (e) {
      buildSnackbar(
        title: "Erreur !",
        message: "Impossible d'ajouter l'offre.",
        backgroundColor: Colors.red,
      );
    }
  }

// Mettre à jour une offre existante
  Future<void> updateOffer(Offer updatedOffer) async {
    try {
      if (updatedOffer.id == null) {
        throw "L'ID de l'offre est manquant"; // Vérification pour s'assurer que l'ID n'est pas null
      }

      // Mise à jour du document dans Firestore avec les nouvelles valeurs
      await offersCollection.doc(updatedOffer.id).update(updatedOffer.toMap());

      // Mettre à jour l'offre dans la liste locale
      final index = offers.indexWhere((offer) => offer.id == updatedOffer.id);
      if (index != -1) {
        offers[index] = updatedOffer; // Mise à jour dans la liste observable
      }
      buildSnackbar(
        title: "Succès !",
        message: "Offre mise à jour avec succès.",
      );
    } catch (e) {
      buildSnackbar(
        title: "Erreur !",
        message: "Impossible de mettre à jour l'offre.",
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> deleteOffer(String offerId) async {
    try {
      await offersCollection.doc(offerId).delete();
      offers.removeWhere((offer) => offer.id == offerId);
      buildSnackbar(
        title: "Succès !",
        message: "Offre supprimée avec succès.",
      );
    } catch (e) {
      buildSnackbar(
        title: "Erreur !",
        message: "Impossible de supprimer l'offre.",
        backgroundColor: Colors.red,
      );
    }
  }
}
