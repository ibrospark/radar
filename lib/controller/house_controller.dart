import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radar/models/houses_model.dart';
import '../utils/constants.dart';

class HouseController extends GetxController {
  final CollectionReference<Map<String, dynamic>> housesCollectionFirestore =
      FirebaseFirestore.instance.collection('houses');

  RxList<House> houses = <House>[].obs;
  Rx<House> currentHouse = House().obs;

  // Observables
  RxBool isUpdateHouse = false.obs;
  RxString currentHouseId = ''.obs;
  RxBool isCurrentUserHouses = false.obs;
  RxString selectedRentalDuration = ''.obs;
  RxString selectedTransactionType = transactionsTypeList.first.obs;
  RxString selectedCurrency = 'Xof'.obs;
  RxString selectedCategory = categoriesList.first.obs;
  RxList<String> selectedOptions = <String>[].obs;

  // TextEditingControllers
  final titleController = TextEditingController().obs;
  final descriptionController = TextEditingController().obs;
  final regionController = TextEditingController().obs;
  final rentalDurationController = TextEditingController().obs;
  final transactionTypeController = TextEditingController().obs;
  final priceController = TextEditingController().obs;
  final minPriceController = TextEditingController().obs;
  final maxPriceController = TextEditingController().obs;
  final areaController = TextEditingController().obs;
  final numberOfBedroomsController = TextEditingController().obs;
  final numberOfRoomsController = TextEditingController().obs;
  final numberOfLivingRoomsController = TextEditingController().obs;
  final numberOfBathroomsController = TextEditingController().obs;
  final numberOfFloorsController = TextEditingController().obs;

  @override
  void onReady() {
    super.onReady();
    _initializeControllers();
  }

  @override
  void onClose() {
    stopHousesStream();
    _disposeControllers();
    super.onClose();
  }

  // Initialize controllers
  void _initializeControllers() {
    for (var controller in [
      titleController,
      descriptionController,
      regionController,
      rentalDurationController,
      transactionTypeController,
      priceController,
      areaController,
      numberOfBedroomsController,
      numberOfRoomsController,
      numberOfLivingRoomsController,
      numberOfBathroomsController,
      numberOfFloorsController
    ]) {
      controller.value = TextEditingController();
    }
  }

  // Dispose controllers
  void _disposeControllers() {
    for (var controller in [
      titleController,
      descriptionController,
      regionController,
      rentalDurationController,
      transactionTypeController,
      priceController,
      areaController,
      numberOfBedroomsController,
      numberOfRoomsController,
      numberOfLivingRoomsController,
      numberOfBathroomsController,
      numberOfFloorsController
    ]) {
      controller.value.dispose();
    }
  }

  // Reset all controllers to their initial values
  void resetAllControllers() {
    titleController.value.text = '';
    descriptionController.value.text = '';
    regionController.value.text = '';
    rentalDurationController.value.text = '';
    transactionTypeController.value.text = '';
    priceController.value.text = '';
    minPriceController.value.text = '';
    maxPriceController.value.text = '';
    areaController.value.text = '';
    numberOfBedroomsController.value.text = '';
    numberOfRoomsController.value.text = '';
    numberOfLivingRoomsController.value.text = '';
    numberOfBathroomsController.value.text = '';
    numberOfFloorsController.value.text = '';

    selectedRentalDuration.value = '';
    selectedTransactionType.value = transactionsTypeList.first;
    selectedCurrency.value = 'Xof';
    selectedCategory.value = categoriesList.first;
    selectedOptions.clear();
  }

  // Generate total number of pieces
  int generateTotalOfPieces() {
    final int numBedrooms =
        int.tryParse(numberOfBedroomsController.value.text) ?? 0;
    final int numLivingRooms =
        int.tryParse(numberOfLivingRoomsController.value.text) ?? 0;
    return numBedrooms + numLivingRooms;
  }

  // Generate house title
  String generateHouseTitle() {
    final totalRooms = generateTotalOfPieces();
    final List<String> titleParts = [];

    // Add category
    titleParts.add(selectedCategory.value);

    // Add number of bedrooms
    final int numBedrooms =
        int.tryParse(numberOfBedroomsController.value.text) ?? 0;
    if (numBedrooms > 0) {
      titleParts.add('$numBedrooms chambre${numBedrooms > 1 ? 's' : ''}');
    }

    // Add number of living rooms
    final int numLivingRooms =
        int.tryParse(numberOfLivingRoomsController.value.text) ?? 0;
    if (numLivingRooms > 0) {
      titleParts.add('$numLivingRooms salon${numLivingRooms > 1 ? 's' : ''}');
    }

    // Default title if no rooms specified
    if (titleParts.isEmpty) {
      return '${selectedCategory.value} sans spécification - Total de $totalRooms pièce${totalRooms > 1 ? 's' : ''}';
    }

    // Add total rooms
    titleParts.add(' - Total de $totalRooms pièce${totalRooms > 1 ? 's' : ''}');

    return titleParts.join(' ').trim();
  }

  // Add house
  Future<void> addHouse() async {
    await _saveHouse(housesCollectionFirestore.doc());
  }

  // Update house
  Future<void> updateHouse(String houseId) async {
    final houseRef = housesCollectionFirestore.doc(houseId);
    await _saveHouse(houseRef);
  }

  // Save house (common method)
  Future<void> _saveHouse(
      DocumentReference<Map<String, dynamic>> houseRef) async {
    try {
      await houseRef.set({
        'Titre': generateHouseTitle(),
        'Description': descriptionController.value.text,
        'Catégorie': selectedCategory.value,
        'Région': regionController.value.text,
        'Quartier': rxMapController.neighborhood.value,
        'Type de transaction': selectedTransactionType.value,
        'Prix': double.tryParse(priceController.value.text),
        'Devise': selectedCurrency.value,
        'Nombre de pièces': generateTotalOfPieces(),
        'Nombre de chambres':
            int.tryParse(numberOfBedroomsController.value.text),
        'Nombre de salons':
            int.tryParse(numberOfLivingRoomsController.value.text),
        'Nombre de salles de bain':
            int.tryParse(numberOfBathroomsController.value.text),
        'Nombre d\'étages': int.tryParse(numberOfFloorsController.value.text),
        'Lien Image': rxImageController.imagesLinks,
        'Superficie': double.tryParse(areaController.value.text),
        'Options': selectedOptions.join(', '),
        'Durée locative': selectedRentalDuration.value,
        'Adresse': rxSearchPlaceController.placeName.value,
        'coords': GeoPoint(rxMapController.currentHouseLatLng.value.latitude,
            rxMapController.currentHouseLatLng.value.longitude),
        'Date de publication': FieldValue.serverTimestamp(),
        'Statut': 'En cours de validation',
      });
    } catch (e) {
      print("Erreur lors de l'enregistrement de la maison: $e");
    }
  }

  // Publish house
  Future<void> publishOrUpdateHouse() async {
    if (isUpdateHouse.isTrue) {
      await updateHouse(currentHouseId.value);
    } else {
      await addHouse();
    }
  }

  // Delete house
  Future<void> deleteHouse(String houseId) async {
    try {
      await FirebaseFirestore.instance
          .collection('houses')
          .doc(houseId)
          .delete();
    } catch (e) {
      print("Erreur lors de la suppression de la maison: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    bindHousesStream();
  }

  // Bind Firestore stream to the houses list
  void bindHousesStream() {
    if (housesSubscription != null) {
      return; // If already subscribed, do nothing
    }
    housesSubscription = housesCollectionFirestore.snapshots().listen(
      (querySnapshot) {
        houses.value = querySnapshot.docs
            .map((doc) => House.fromMap(doc.data(), doc.id))
            .toList();
      },
      onError: (e) {
        print("Erreur lors de la récupération des maisons : $e");
      },
      onDone: () {
        update();
      },
    );
  }

  StreamSubscription<QuerySnapshot>? housesSubscription;

  // Stop the houses stream
  void stopHousesStream() {
    housesSubscription?.cancel();
    housesSubscription = null;
  }
}
