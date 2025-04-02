import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityZone {
  final String id;
  final String name;
  final GeoPoint? coords; // Champ non requis, peut être nul
  final String idUser;

  ActivityZone({
    String? id,
    required this.name,
    this.coords,
    required this.idUser,
  }) : id = id ??
            FirebaseFirestore.instance.collection('activityZones').doc().id;

  factory ActivityZone.fromJson(Map<String, dynamic> json) {
    return ActivityZone(
      id: json['id'],
      name: json['name'],
      coords: json['coords'],
      idUser: json['idUser'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'coords': coords,
      'idUser': idUser,
    };
  }
}
