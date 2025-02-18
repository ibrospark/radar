import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String? avatar;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? address;
  final String? phoneNumber;
  final String accountType;
  final DateTime registrationDate;
  final String? fcmToken;
  final int status;
  final bool profileComplete;

  UserModel({
    required this.id,
    this.avatar,
    this.email,
    this.firstName,
    this.lastName,
    this.gender,
    this.address,
    this.phoneNumber,
    this.accountType = 'Starter',
    DateTime? registrationDate,
    this.fcmToken,
    this.status = 0,
    this.profileComplete = false,
  }) : registrationDate = registrationDate ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'Avatar': avatar,
      'E-mail': email,
      'Nom': firstName,
      'Prenom': lastName,
      'Sexe': gender,
      'Adresse': address,
      'Tel': phoneNumber,
      'Type de compte': accountType,
      'Date inscription': registrationDate.toIso8601String(),
      'fcmToken': fcmToken,
      'Statut': status,
      'profileComplete': profileComplete,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> data) {
    // Traiter le champ 'Date inscription' qui peut être de type Timestamp
    var registrationDateValue = data['Date inscription'];
    DateTime registrationDate;

    // Si 'Date inscription' est un Timestamp, on le convertit en DateTime
    if (registrationDateValue is Timestamp) {
      registrationDate =
          registrationDateValue.toDate(); // Convertir Timestamp en DateTime
    } else {
      // Si 'Date inscription' est absent ou mal formaté, on utilise DateTime.now()
      registrationDate = DateTime.now();
    }

    return UserModel(
      id: data['Id'] ?? '',
      avatar: data['Avatar'],
      email: data['E-mail'],
      firstName: data['Nom'],
      lastName: data['Prenom'],
      gender: data['Sexe'],
      address: data['Adresse'],
      phoneNumber: data['Tel'],
      accountType: data['Type de compte'] ?? 'Starter',
      registrationDate: registrationDate,
      fcmToken: data['fcmToken'],
      status: data['Statut'] ?? 0,
      profileComplete: data['profileComplete'] ?? false,
    );
  }
}
