import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:plant_tracker/models/plant.dart';

final firestoreAddPlantProvider =
    FutureProvider.autoDispose.family<String, Plant>((ref, plant) async {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  final user = auth.currentUser;

  if (user == null) {
    throw Exception('User not logged in');
  }

  final batch = firestore.batch();

  final userDoc = firestore.collection('users').doc(user.uid);
  final plantDoc = userDoc.collection('plants').doc();

  batch.set(plantDoc, plant.toMap());
  batch.set(userDoc, {'total_plants': FieldValue.increment(1)}, SetOptions(merge : true));

  try {
    await batch.commit();
    return plantDoc.id;
  } catch (e) {
    rethrow;
  }
});
