import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:radar/utils/constants.dart';

class SearchPlaceController extends GetxController {
  RxList<dynamic> predictions = <dynamic>[].obs;
  Rx<Map<String, dynamic>?> placeDetails = Rx<Map<String, dynamic>?>(null);
  Rx<String> placeName = ''.obs;

  void autoCompleteSearch(String value) async {
    if (value.isNotEmpty) {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$value&components=country:SN&key=$googleMapApiKey',
      );

      try {
        var response = await http.get(url);
        if (response.statusCode == 200) {
          var result = json.decode(response.body);
          predictions.value = result['predictions'] ?? [];
        } else {
          print("Error: ${response.statusCode} - ${response.body}");
        }
      } catch (e) {
        print("Error during autocomplete request: $e");
        Get.snackbar('Erreur', 'Une erreur est survenue lors de la recherche.');
      }
    } else {
      predictions.clear();
    }
  }

  void getPlaceDetails(String placeId) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleMapApiKey',
    );

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        placeDetails.value = result['result'];
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        Get.snackbar('Erreur', 'Impossible de récupérer les détails du lieu.');
      }
    } catch (e) {
      print("Error during place details request: $e");
      Get.snackbar('Erreur',
          'Une erreur est survenue lors de la récupération des détails.');
    }
  }

  // Fonction pour obtenir le nom du lieu à partir des coordonnées
  Future<Rx<String>> getPlaceNameFromLatLng(
      double latitude, double longitude) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$googleMapApiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          // Récupérer le nom du lieu (formatted_address)
          placeName.value = data['results'][0]['formatted_address'];
          return placeName;
        } else {
          print('Erreur de l\'API: ${data['status']}');
        }
      } else {
        print('Erreur HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la requête: $e');
    }
    // Return an empty string if an error occurs
    placeName.value = '';
    return placeName;
  }
}
