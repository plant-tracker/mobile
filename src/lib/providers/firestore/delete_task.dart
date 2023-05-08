import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreDeleteTaskProvider = FutureProvider.autoDispose
    .family<void, Map<String, String>>((ref, data) async {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  final user = auth.currentUser;

  if (user == null) {
    throw Exception('User not authenticated');
  }

  final userDoc = firestore.collection('users').doc(user.uid);
  final plantDoc = userDoc.collection('plants').doc(data['plantId']);
  final taskDoc = plantDoc.collection('tasks').doc(data['taskId']);

  final batch = firestore.batch();

  batch.delete(taskDoc);
  batch.set(userDoc, {'total_tasks': FieldValue.increment(-1)},
      SetOptions(merge: true));

  try {
    await batch.commit();
  } catch (e) {
    rethrow;
  }
});
