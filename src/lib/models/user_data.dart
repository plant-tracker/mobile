import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserData {
  final int plantTotals;
  final int taskTotals;

  UserData({
    required this.plantTotals,
    required this.taskTotals,
  });

  static UserData defaultData() {
    return UserData(
      plantTotals: 0,
      taskTotals: 0,
    );
  }

  factory UserData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserData(
      plantTotals: data['total_plants'] as int? ?? 0,
      taskTotals: data['total_tasks'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total_plants': plantTotals,
      'total_tasks': taskTotals,
    };
  }
}
