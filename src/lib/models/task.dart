import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum TaskFrequency { daily, weekly, monthly }

class Task {
  final String id;
  final String description;
  final DateTime dueDate;
  final TaskFrequency frequency;

  Task({
    required this.id,
    required this.description,
    required this.dueDate,
    required this.frequency,
    this.completed = false,
  });

  static Task fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data();
    return Task(
      id: snapshot.id,
      description: data['description'],
      dueDate: data['due_date'].toDate(),
      frequency: TaskFrequency.values[data['frequency'] ?? 0],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'due_date': dueDate,
      'frequency': frequency.index,
    };
  }
}
