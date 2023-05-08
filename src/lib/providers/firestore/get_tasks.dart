import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:plant_tracker/models/task.dart';

final firestoreGetTasksProvider =
    StreamProvider.autoDispose.family<List<TaskData>, String>((ref, plantId) {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  final user = auth.currentUser;

  if (user == null) {
    throw Exception('User not authenticated');
  }

  final userDoc = firestore.collection('users').doc(user.uid);
  final plantDoc = userDoc.collection('plants').doc(plantId);
  final tasksCollection = plantDoc.collection('tasks').withConverter<TaskData>(
        fromFirestore: (snapshot, _) => TaskData.fromFirestore(snapshot),
        toFirestore: (task, _) => task.toMap(),
      );

  return tasksCollection.snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
      );
});
