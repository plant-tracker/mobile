import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreDeletePlantProvider =
    FutureProvider.autoDispose.family<void, String>((ref, plantId) async {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  final user = auth.currentUser;

  if (user == null) {
    throw Exception('User not authenticated');
  }

  final userDoc = firestore.collection('users').doc(user.uid);
  final plantDoc = userDoc.collection('plants').doc(plantId);

  final batch = firestore.batch();

  batch.delete(plantDoc);
  batch.set(userDoc, {'total_plants': FieldValue.increment(-1)},
      SetOptions(merge: true));

  try {
    await batch.commit();
  } catch (e) {
    rethrow;
  }
});
