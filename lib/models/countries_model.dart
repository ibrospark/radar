class CountryModel {
  String? name;
  String? callingCode;
  String? region;
  String? flag;

  CountryModel({
    this.name,
    this.callingCode,
    this.region,
    this.flag,
  });

  // Méthode fromJson pour créer une instance à partir des données JSON
  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: json['name']?['common'] ??
          'Unknown', // Vérification des champs potentiellement nulls
      callingCode: (json['idd']?['root'] ?? '') +
          ((json['idd']?['suffixes'] != null &&
                  json['idd']['suffixes'].isNotEmpty)
              ? json['idd']['suffixes'][0]
              : ''),
      region: json['region'] ?? 'Unknown', // Valeur par défaut si null
      flag: json['flags']?['png'] ??
          '', // URL du drapeau ou chaîne vide si absente
    );
  }

  // Méthode toJson pour convertir une instance en JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'callingCode': callingCode,
      'region': region,
      'flag': flag,
    };
  }
}
