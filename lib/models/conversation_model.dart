class Conversation {
  String? id; // Identifiant Firestore optionnel
  final String user1Id;
  final String user2Id;
  final String lastMessage;
  final DateTime timestamp;

  Conversation({
    this.id,
    required this.user1Id,
    required this.user2Id,
    required this.lastMessage,
    required this.timestamp,
  });

  // Méthode pour convertir une Conversation en Map
  Map<String, dynamic> toMap() {
    return {
      'user1Id': user1Id,
      'user2Id': user2Id,
      'lastMessage': lastMessage,
      'timestamp': timestamp.toIso8601String(), // Format date ISO
    };
  }

  // Méthode pour créer une Conversation à partir d'une Map
  factory Conversation.fromMap(Map<String, dynamic> map, {String? id}) {
    return Conversation(
      id: id,
      user1Id: map['user1Id'] ?? '', // Valeur par défaut si absent
      user2Id: map['user2Id'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(), // Valeur par défaut si absent
    );
  }
}
