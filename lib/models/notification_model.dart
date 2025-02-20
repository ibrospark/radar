class NotificationModel {
  final String title;
  final String body;
  final DateTime timestamp;
  bool isRead;

  NotificationModel(
      {required this.title,
      required this.body,
      required this.timestamp,
      this.isRead = false});

  // Convertir un JSON en modèle
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'],
      body: json['body'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
    );
  }

  // Convertir le modèle en JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }
}
