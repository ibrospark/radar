class Offer {
  String? id;
  String? name;
  int? price;
  int? numberOfPublication;
  int? numberOfDay;

  Offer({
    this.id,
    this.name,
    this.price,
    this.numberOfPublication,
    this.numberOfDay,
  });

  factory Offer.fromMap(Map<String, dynamic> map) {
    return Offer(
      id: map['id'] as String?,
      name: map['name'] as String?,
      price: map['price'] as int?,
      numberOfPublication: map['numberOfPublication'] as int?,
      numberOfDay: map['numberOfDay'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'numberOfPublication': numberOfPublication,
      'numberOfDay': numberOfDay,
    };
  }
}
