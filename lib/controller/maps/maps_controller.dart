import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:radar/_builds/build_house.dart';
import 'package:radar/models/houses_model.dart';
import 'package:radar/utils/constants.dart';
import 'package:radar/utils/functions.dart';
import 'package:radar/utils/map_style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class MapController extends GetxController {
  // Camera position
  Rx<CameraPosition> cameraPosition =
      const CameraPosition(target: LatLng(0, 0), zoom: 18.0).obs;

  Rx<LatLng> initialPosition = const LatLng(37.7749, -122.4194).obs;

  // Current USER VARS ----------------------------------------------------------------
  RxString neighborhood = ''.obs; // Quartier
  // CURRENT USER ----------------------------------------------------------------
  Rx<LatLng> currentUserLatLng = const LatLng(0.0, 0.0).obs;
  // CURRENT CAMERA IDLE ----------------------------------------------------------------
  Rx<LatLng> currentCameraIdleLatLng = const LatLng(0.0, 0.0).obs;
  // CURRENT HOUSE ----------------------------------------------------------------
  Rx<LatLng> currentHouseLatLng = const LatLng(0.0, 0.0).obs;

  // Map controller
  Rx<GoogleMapController?> googleMapController = Rx<GoogleMapController?>(null);
  Completer<GoogleMapController> googleMapCompleter = Completer();

  // Markers and polylines
  RxSet<Marker> markers = <Marker>{}.obs;
  RxSet<Polyline> polylines = <Polyline>{}.obs;
  List<LatLng> polylineCoordinates = [];
  Rx<PolylinePoints> polylinePointsBetween = PolylinePoints().obs;

  // UI State management
  RxBool isMapCreated = false.obs;
  RxBool isMapReady = false.obs;
  RxBool isPickerMode = false.obs;
  RxBool isRouteMode = false.obs;
  RxBool displayCurrentPositionBtnCircular = true.obs;
  RxBool displayCurrentPositionBtnLg = false.obs;
  RxBool displaySearchLocationBar = true.obs;
  RxBool displayIconPickerHouse = false.obs;
  RxBool displayValidatePositionBtnLg = false.obs;
  RxBool displayFilterPanel = true.obs;
  RxBool displayDrawerBtn = true.obs;
  RxBool displayPublishBtn = true.obs;
  RxDouble distanceInMeters = 0.0.obs;

  // Location and Camera Management ----------------------------------------------------
  Future<void> setCurrentLocation() async {
    Position position = await determineCurrentPosition();

    moveCamera(position.latitude, position.longitude);
    // Define current user location
    currentUserLatLng.value = LatLng(position.latitude, position.longitude);

    clearSpecificMarker('current_position');
    clearSpecificMarker('place_selection');

    await addMarker(
        currentUserLatLng.value, 'current_position', 'currentPosition');
  }

// Determiner la position actuelle de l'utilisateur
  Future<Position> determineCurrentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return Future.error("Location services disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error("Location permissions denied.");
      }
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  void moveCamera(double latitude, double longitude) {
    googleMapController.value?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 16.0,
        ),
      ),
    );
  }

// Quand la caméra est immobile
  void onCameraIdle() {
    final latLng = cameraPosition.value.target;
    currentCameraIdleLatLng.value = latLng;
  }

  //  Ajouter un marqueur sur la carte
  Future<void> addMarker(LatLng position, String idMarker, String type) async {
    final iconPath = markerIcons[type] ?? markerIcons['other']!;
    final markerIcon = await getBytesFromAsset(iconPath, 100);

    markers.add(Marker(
      markerId: MarkerId(idMarker),
      position: position,
      icon: BitmapDescriptor.fromBytes(markerIcon),
    ));
  }

  Future<void> addFilteredFirebaseCircularMarker() async {
    try {
      List<House> houses = await _fetchHousesFromFirebase();
      List<House> filteredHouses = _applyFilters(houses);
      await _updateMarkers(
          filteredHouses); // Déplacer la logique de mise à jour ici.
      _showResultsSnackbar(filteredHouses);
      _adjustCameraToMarkers();
    } catch (e) {
      _showErrorSnackbar(e);
    }
  }

  Future<List<House>> _fetchHousesFromFirebase() async {
    CollectionReference<Map<String, dynamic>> collectionHouses =
        FirebaseFirestore.instance.collection('houses');

    // Limitez les résultats pour ne pas charger trop de données
    QuerySnapshot<Map<String, dynamic>> snapshots = await collectionHouses
        .limit(50) // Limitez à 50 maisons par requête
        .get();
    return snapshots.docs
        .map((doc) => House.fromMap(doc.data(), doc.id))
        .toList();
  }

  List<House> _applyFilters(List<House> houses) {
    return houses.where((house) {
      bool matches = true;
      if (rxHouseController.selectedCategory.value.isNotEmpty) {
        matches &= house.category == rxHouseController.selectedCategory.value;
      }
      if (rxHouseController.selectedTransactionType.value.isNotEmpty) {
        matches &= house.transactionType ==
            rxHouseController.selectedTransactionType.value;
      }
      if (rxHouseController.numberOfBedroomsController.value.text.isNotEmpty) {
        matches &= house.numberOfBedrooms ==
            int.tryParse(
                rxHouseController.numberOfBedroomsController.value.text);
      }
      if (rxHouseController
          .numberOfLivingRoomsController.value.text.isNotEmpty) {
        matches &= house.numberOfLivingRooms ==
            int.tryParse(
                rxHouseController.numberOfLivingRoomsController.value.text);
      }
      if (rxHouseController.numberOfBathroomsController.value.text.isNotEmpty) {
        matches &= house.numberOfBathrooms ==
            int.tryParse(
                rxHouseController.numberOfBathroomsController.value.text);
      }
      if (rxHouseController.numberOfFloorsController.value.text.isNotEmpty) {
        matches &= house.numberOfFloors ==
            int.tryParse(rxHouseController.numberOfFloorsController.value.text);
      }
      if (rxHouseController.areaController.value.text.isNotEmpty) {
        matches &= house.area ==
            int.tryParse(rxHouseController.areaController.value.text);
      }
      if (rxHouseController.selectedRentalDuration.value.isNotEmpty) {
        matches &= house.rentalDuration ==
            rxHouseController.selectedRentalDuration.value;
      }
      if (rxHouseController.selectedCurrency.value.isNotEmpty) {
        matches &= house.currency == rxHouseController.selectedCurrency.value;
      }
      if (neighborhood.value.isNotEmpty) {
        matches &= house.neighborhood == neighborhood.value;
      }
      if (rxHouseController.selectedOptions.isNotEmpty) {
        matches &= rxHouseController.selectedOptions
            .every((option) => house.options?.contains(option) ?? false);
      }
      int minPrix =
          int.tryParse(rxHouseController.minPriceController.value.text) ?? 0;
      int? maxPrix =
          int.tryParse(rxHouseController.maxPriceController.value.text);
      matches &= (house.price ?? 0) >= minPrix;
      if (maxPrix != null) {
        matches &= (house.price ?? 0) <= maxPrix;
      }
      return matches;
    }).toList();
  }

  Future<void> _updateMarkers(List<House> houses) async {
    clearMarkersExcept(['current_position']);
    for (var houseData in houses) {
      markers.add(
        Marker(
          icon: await MarkerIcon.downloadResizePictureCircle(
              houseData.imageLinks!.isNotEmpty
                  ? houseData.imageLinks!.first
                  : "https://firebasestorage.googleapis.com/v0/b/radar-2024.appspot.com/o/default%2Fempty.png?alt=media&token=faadf156-26ce-4973-b130-b7a723247124",
              size: 150,
              addBorder: true,
              borderColor: Colors.white,
              borderSize: 15),
          markerId: MarkerId(houseData.id!),
          position:
              LatLng(houseData.coords!.latitude, houseData.coords!.longitude),
          onTap: () {
            rxHouseController.currentHouse.value = houseData;
            openModalBottomSheet(buildShowHousePanel());
          },
        ),
      );
    }
  }

  void _adjustCameraToMarkers() {
    if (markers.isNotEmpty) {
      LatLngBounds bounds = _createLatLngBoundsFromMarkers();
      googleMapController.value?.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
    }
  }

  LatLngBounds _createLatLngBoundsFromMarkers() {
    final List<LatLng> markerPositions =
        markers.map((marker) => marker.position).toList();
    double southWestLat = markerPositions
        .map((p) => p.latitude)
        .reduce((value, element) => value < element ? value : element);
    double southWestLng = markerPositions
        .map((p) => p.longitude)
        .reduce((value, element) => value < element ? value : element);
    double northEastLat = markerPositions
        .map((p) => p.latitude)
        .reduce((value, element) => value > element ? value : element);
    double northEastLng = markerPositions
        .map((p) => p.longitude)
        .reduce((value, element) => value > element ? value : element);
    return LatLngBounds(
      southwest: LatLng(southWestLat, southWestLng),
      northeast: LatLng(northEastLat, northEastLng),
    );
  }

  void _showResultsSnackbar(List<House> houses) {
    if (houses.isNotEmpty) {
      Get.snackbar(
        "Bien(s) trouvé(s) !",
        "Nous avons trouvé ${houses.length} bien(s) sur la carte!",
        backgroundColor: Colors.green,
      );
    } else {
      Get.snackbar(
        "Désolé !",
        "Aucun bien trouvé !",
        backgroundColor: Colors.redAccent,
      );
    }
  }

  void _showErrorSnackbar(dynamic error) {
    Get.snackbar(
      "Erreur !",
      "Une erreur est survenue : ${error.toString()}",
      backgroundColor: Colors.redAccent,
    );
    print(error.toString());
  }

  void clearMarkers() {
    markers.clear();
  }

  void clearSpecificMarker(String markerId) {
    markers.removeWhere((marker) => marker.markerId.value == markerId);
  }

  void clearMarkersExcept(List<String> markerIdsToKeep) {
    markers.removeWhere(
        (marker) => !markerIdsToKeep.contains(marker.markerId.value));
  }

  void clearPolylines() {
    polylines.clear();
    polylineCoordinates.clear();
  }

  // Map Creation and Interaction ------------------------------------------------------
  void onMapCreated(GoogleMapController controller) async {
    googleMapController.value = controller;

    if (!googleMapCompleter.isCompleted) {
      googleMapCompleter.complete(controller);
    }

    googleMapController.value!.setMapStyle(mapStyle);

    isMapCreated.value = true;

    setCurrentLocation();
    // Mise à jour du texte du champ de recherche
    await rxSearchPlaceController.getPlaceNameFromLatLng(
      currentCameraIdleLatLng.value.latitude,
      currentCameraIdleLatLng.value.longitude,
    );
  }

  // Cette fonction gère la sélection d'un lieu à partir de la recherche.
  void handlePlaceSelection(
    String placeId, // Identifiant du lieu sélectionné.
    Map<String, dynamic>
        prediction, // Prédiction contenant les détails du lieu sélectionné.
  ) async {
    // Récupère les détails du lieu à partir de son identifiant 'place_id'.
    rxSearchPlaceController.getPlaceDetails(prediction['place_id']);

    // Met à jour le texte du champ de recherche avec la description du lieu sélectionné.
    rxSearchPlaceController.placeName.value = prediction['description'];

    // Récupère les détails du lieu stockés dans 'placeDetails'.
    final place = rxSearchPlaceController.placeDetails.value;

    // Si les détails du lieu sont disponibles.
    if (place != null) {
      // Déplace la caméra de la carte vers les coordonnées du lieu sélectionné (latitude et longitude).
      rxMapController.moveCamera(
        place['geometry']['location']['lat'],
        place['geometry']['location']['lng'],
      );

      // Place un marqueur sur la carte aux coordonnées du lieu sélectionné.
      rxMapController.addMarker(
        LatLng(
          place['geometry']['location']['lat'],
          place['geometry']['location']['lng'],
        ),
        'place_selection', // Identifiant du marqueur.
        "pin", // Type d'icône du marqueur (ici, un pin).
      );

      // Retourne à l'écran précédent après la sélection.
      Get.back();
    }
  }

  Future<void> activateDefaultMode() async {
    isPickerMode.value = false; //Picker mode
    isRouteMode.value = false; //Route mode
    displayCurrentPositionBtnCircular.value = true; //Current position button
    displayCurrentPositionBtnLg.value = false; //Current position button
    displaySearchLocationBar.value = true; //Search location bar
    displayIconPickerHouse.value = false; //Icon picker house
    displayValidatePositionBtnLg.value = false; //Validate position button
    displayFilterPanel.value = true; //Filter panel
    displayDrawerBtn.value = true; //Drawer button
    displayPublishBtn.value = true; //Publish button
    rxHouseController.startHousesStream(); //  Start listening to houses stream
    clearPolylines(); //Clear polylines
  }

  void activatePickerMode() {
    isPickerMode.value = true; //Picker mode
    isRouteMode.value = false; //Route mode
    displayCurrentPositionBtnCircular.value = false; //Current position button
    displayCurrentPositionBtnLg.value = true; //Current position button
    displaySearchLocationBar.value = true; //Search location bar
    displayIconPickerHouse.value = true; //Icon picker house
    displayValidatePositionBtnLg.value = true; //Validate position button
    displayFilterPanel.value = false; //Filter panel
    displayDrawerBtn.value = false; //Drawer button
    displayPublishBtn.value = false; //Publish button
    rxHouseController.stopHousesStream();
    clearMarkersExcept(['current_position']);
    clearPolylines();
  }

  Future<void> activateRouteMode() async {
    clearPolylines();
    clearMarkersExcept(
        ['current_position', rxHouseController.currentHouse.value.id!]);

    isPickerMode.value = false; //Picker mode
    isRouteMode.value = true; //Route mode
    displayCurrentPositionBtnCircular.value = false; //Current position button
    displayCurrentPositionBtnLg.value = false; //Current position button
    displaySearchLocationBar.value = false; //Search location bar
    displayIconPickerHouse.value = false; //Icon picker house
    displayValidatePositionBtnLg.value = false; //Validate position button
    displayFilterPanel.value = false; //Filter panel
    displayDrawerBtn.value = false; //Drawer button
    displayPublishBtn.value = false; //Publish button

    final currentHouseCoords = rxHouseController.currentHouse.value.coords!;

    await setCurrentLocation();
    // Dessiner la route et ajouter les marqueurs
    await drawRoute(
        currentUserLatLng.value.latitude,
        currentUserLatLng.value.longitude,
        currentHouseCoords.latitude,
        currentHouseCoords.longitude);

    // Calculer la distance entre les points
    calculateDistanceBetweenPoints(
        currentUserLatLng.value.latitude,
        currentUserLatLng.value.longitude,
        currentHouseCoords.latitude,
        currentHouseCoords.longitude);
    Get.back();
  }

// OK --------------------------------------------------------

  Future<void> drawRoute(double originLat, double originLng,
      double destinationLat, double destinationLng) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$originLat,$originLng&destination=$destinationLat,$destinationLng&key=$googleMapApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        List<PointLatLng> points = PolylinePoints()
            .decodePolyline(data['routes'][0]['overview_polyline']['points']);

        List<LatLng> latLngPoints = points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        polylines.add(
          Polyline(
            polylineId: PolylineId('route'),
            points: latLngPoints,
            color: primaryColor,
            width: 5,
          ),
        );
      } else {
        throw Exception('Failed to load route: ${data['status']}');
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
  }

// OK --------------------------------------------------------
  void calculateDistanceBetweenPoints(
      double lat1, double lon1, double lat2, double lon2) {
    double distance = Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
    distanceInMeters.value = distance;
  }

  // OK --------------------------------------------------------
  Future<void> openMap(double originLat, double originLong,
      double destinationLat, double destinationLong) async {
    if (GetPlatform.isAndroid) {
      String googleUrl =
          'https://www.google.com/maps/dir/?api=1&origin=&destination=$destinationLat,$destinationLong&travelmode=driving&dir_action=navigate';

      if (await canLaunch(googleUrl)) {
        await launch(googleUrl);
      } else {
        throw 'Could not launch $googleUrl';
      }
    }
  }
}
