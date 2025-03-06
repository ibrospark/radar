class Message {
  String? id; // Identifiant Firestore optionnel
  final String senderId;
  final String content;
  final DateTime timestamp;

  Message({
    this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
  });

  // Méthode pour convertir un Message en Map
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'content': content,
      'timestamp': timestamp.toIso8601String(), // Format date ISO
    };
  }

  // Méthode pour créer un Message à partir d'une Map
  factory Message.fromMap(Map<String, dynamic> map, {String? id}) {
    return Message(
      id: id,
      senderId: map['senderId'] ?? '', // Valeur par défaut si absent
      content: map['content'] ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(), // Valeur par défaut si absent
    );
  }
}
