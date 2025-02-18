import 'package:cloud_firestore/cloud_firestore.dart';

class House {
  final String? id; // Champ non requis, peut être nul
  final String? idUser; // Champ non requis, peut être nul
  final String? title; // Champ non requis, peut être nul
  final String? description; // Champ non requis, peut être nul
  final String? category; // Champ non requis, peut être nul
  final String? region; // Champ non requis, peut être nul
  final String? neighborhood; // Champ non requis, peut être nul
  final String? transactionType; // Champ non requis, peut être nul
  final double? price; // Champ non requis, peut être nul
  final String? currency; // Champ non requis, peut être nul
  final int? numberOfRooms; // Champ non requis, peut être nul
  final int? numberOfBedrooms; // Champ non requis, peut être nul
  final int? numberOfLivingRooms; // Champ non requis, peut être nul
  final int? numberOfBathrooms; // Champ non requis, peut être nul
  final int? numberOfFloors; // Champ non requis, peut être nul
  final List<String>? imageLinks; // Liste d'images non obligatoire
  final double? area; // Champ non requis, peut être nul
  final List<String>? options; // Liste d'options non obligatoire
  final String? rentalDuration; // Champ non requis, peut être nul
  final String? address; // Champ non requis, peut être nul
  final GeoPoint? coords; // Champ non requis, peut être nul
  final DateTime? createdAt; // Champ non requis, peut être nul
  final String? status; // Champ non requis, peut être nul

  House({
    this.id,
    this.idUser,
    this.title,
    this.description,
    this.category,
    this.region,
    this.neighborhood,
    this.transactionType,
    this.price,
    this.currency,
    this.numberOfRooms,
    this.numberOfBedrooms,
    this.numberOfLivingRooms,
    this.numberOfBathrooms,
    this.numberOfFloors,
    this.imageLinks,
    this.area,
    this.options,
    this.rentalDuration,
    this.address,
    this.coords,
    this.createdAt,
    this.status,
  });

  // fromMap pour transformer un Map<String, dynamic> en objet House
  factory House.fromMap(Map<String, dynamic> map, String docId) {
    return House(
      id: docId,
      idUser: map['Id User'], // Peut être nul
      title: map['Titre'], // Peut être nul
      description: map['Description'], // Peut être nul
      category: map['Catégorie'], // Peut être nul
      region: map['Région'], // Peut être nul
      neighborhood: map['Quartier'], // Peut être nul
      transactionType: map['Type de transaction'], // Peut être nul
      price: (map['Prix'] as num?)?.toDouble(), // Peut être nul
      currency: map['Devise'], // Peut être nul
      numberOfRooms: (map['Nombre de pièces'] as int?), // Peut être nul
      numberOfBedrooms: (map['Nombre de chambres'] as int?), // Peut être nul
      numberOfLivingRooms: (map['Nombre de salons'] as int?), // Peut être nul
      numberOfBathrooms:
          (map['Nombre de salles de bain'] as int?), // Peut être nul
      numberOfFloors: (map['Nombre d\'étages'] as int?), // Peut être nul
      imageLinks: (map['Lien Image'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(), // Peut être nul
      area: (map['Superficie'] as num?)?.toDouble(), // Peut être nul
      options: (map['Options'] as String?)
          ?.split(',')
          .map((e) => e.trim())
          .toList(), // Peut être nul
      rentalDuration: map['Durée locative'], // Peut être nul
      address: map['Adresse'], // Peut être nul
      coords: map['coords'], // Peut être nul
      createdAt:
          (map['Date de publication'] as Timestamp?)?.toDate(), // Peut être nul
      status: map['Statut'], // Peut être nul
    );
  }

  // toMap pour transformer un objet House en Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'Id User': idUser,
      'Titre': title,
      'Description': description,
      'Catégorie': category,
      'Région': region,
      'Quartier': neighborhood,
      'Type de transaction': transactionType,
      'Prix': price,
      'Devise': currency,
      'Nombre de pièces': numberOfRooms,
      'Nombre de chambres': numberOfBedrooms,
      'Nombre de salons': numberOfLivingRooms,
      'Nombre de salles de bain': numberOfBathrooms,
      'Nombre d\'étages': numberOfFloors,
      'Lien Image': imageLinks,
      'Superficie': area,
      'Options': options,
      'Durée locative': rentalDuration,
      'Adresse': address,
      'coords': coords,
      'Date de publication':
          createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'Statut': status,
    };
  }

  // fromJson pour convertir un JSON (souvent utilisé pour des interactions avec Firestore)
  factory House.fromJson(Map<String, dynamic> json) {
    return House.fromMap(json, json['id']);
  }

  // toJson pour transformer un objet House en JSON (souvent utilisé pour des interactions avec Firestore)
  Map<String, dynamic> toJson() {
    return toMap();
  }
}
