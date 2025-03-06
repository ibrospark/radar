import 'package:cloud_firestore/cloud_firestore.dart';

class OfferSubscription {
  String? id;
  final String? idUser;
  String? name;
  int? price;
  int? numberOfPublication;
  int? numberOfDay;
  bool? isActive;
  DateTime? startedAt;
  DateTime? expiredAt;

  OfferSubscription({
    required this.id,
    required this.idUser,
    this.name = 'Offre Starter',
    this.price = 0,
    this.numberOfPublication = 5,
    this.numberOfDay = 90,
    this.isActive = false,
    DateTime? startedAt,
    DateTime? expiredAt,
  })  : startedAt = startedAt ?? DateTime.now(),
        expiredAt = (expiredAt ?? DateTime.now())
            .add(Duration(days: numberOfDay ?? 30));

  // Méthode pour créer un objet depuis un Map
  factory OfferSubscription.fromMap(Map<String, dynamic> map) {
    return OfferSubscription(
      id: map['id'],
      idUser: map['idUser'],
      name: map['name'],
      price: map['price'],
      numberOfPublication: map['numberOfPublication'],
      numberOfDay: map['numberOfDay'],
      isActive: map['isActive'],
      // Convert Firestore Timestamp to DateTime
      startedAt: map['startedAt'] is Timestamp
          ? (map['startedAt'] as Timestamp).toDate()
          : null,
      expiredAt: map['expiredAt'] is Timestamp
          ? (map['expiredAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Méthode pour convertir l'objet en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idUser': idUser,
      'name': name,
      'price': price,
      'numberOfPublication': numberOfPublication,
      'numberOfDay': numberOfDay,
      'isActive': isActive,
      // Convert DateTime to ISO 8601 String or use Timestamp for Firestore
      'startedAt': startedAt,
      'expiredAt': expiredAt,
    };
  }
}
