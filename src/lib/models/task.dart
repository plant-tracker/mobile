import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class TaskData {
  final String id;
  final String plantId;
  final String name;
  final String description;
  final int frequencyInDays;
  final TimeOfDay time;

  TaskData({
    required this.id,
    required this.plantId,
    required this.name,
    required this.description,
    required this.frequencyInDays,
    required this.time,
  });

  factory TaskData.fromFormData(Map<String, dynamic> formData) {
    final time = formData['time'] != null
        ? TimeOfDay.fromDateTime(formData['time'])
        : TimeOfDay(hour: 0, minute: 0);
    return TaskData(
      id: "",
      plantId: formData['plant_id'] ?? '',
      name: formData['name'] ?? '',
      description: formData['description'] ?? '',
      frequencyInDays: int.parse(formData['frequency'] ?? 0),
      time: time,
    );
  }

  factory TaskData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final timeString = data['time'] ?? '0:0';
    final timeParts = timeString.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final time = TimeOfDay(hour: hour, minute: minute);
    return TaskData(
      id: doc.id,
      plantId: data['plant_id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      frequencyInDays: data['frequency'] ?? 0,
      time: time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'plant_id': plantId ?? '',
      'name': name ?? '',
      'description': description ?? '',
      'frequency': frequencyInDays ?? 0,
      'time': '${time.hour}:${time.minute}',
    };
  }
}
