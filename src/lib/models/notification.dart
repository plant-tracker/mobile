import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationData {
  final String id;
  final String title;
  final String body;
  final Timestamp createdAt;

  NotificationData({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  factory NotificationData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return NotificationData(
      id: doc.id,
      title: data['title'],
      body: data['body'],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'createdAt': createdAt,
    };
  }
}
