class Conversation {
  String? id; // Identifiant Firestore optionnel
  final String senderId;
  final String receiverId;
  final String lastMessage;
  final DateTime timestamp;

  Conversation({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.lastMessage,
    required this.timestamp,
  });

  // Méthode pour convertir une Conversation en Map
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'lastMessage': lastMessage,
      'timestamp': timestamp.toIso8601String(), // Format date ISO
    };
  }

  // Méthode pour créer une Conversation à partir d'une Map
  factory Conversation.fromMap(Map<String, dynamic> map, {String? id}) {
    return Conversation(
      id: id,
      senderId: map['senderId'] ?? '', // Valeur par défaut si absent
      receiverId: map['receiverId'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(), // Valeur par défaut si absent
    );
  }
}
