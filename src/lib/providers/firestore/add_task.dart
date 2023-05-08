import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:plant_tracker/models/task.dart';

final firestoreAddTaskProvider = FutureProvider.autoDispose
    .family<String, TaskData>((ref, TaskData data) async {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  final user = auth.currentUser;

  if (user == null) {
    throw Exception('User not authenticated');
  }

  final batch = firestore.batch();

  final userDoc = firestore.collection('users').doc(user.uid);
  final plantDoc = userDoc.collection('plants').doc(data.plantId);
  final taskDoc = plantDoc.collection('tasks').doc();

  batch.set(taskDoc, data.toMap());
  batch.set(userDoc, {'total_tasks': FieldValue.increment(1)},
      SetOptions(merge: true));

  try {
    await batch.commit();
    return taskDoc.id;
  } catch (e) {
    rethrow;
  }
});
