import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:plant_tracker/models/plant.dart';

final firestoreEditPlantProvider =
    FutureProvider.autoDispose.family<void, Plant>((ref, plant) async {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  final user = auth.currentUser;

  if (user == null) {
    throw Exception('User not logged in');
  }

  final plantCollection =
      firestore.collection('users').doc(user.uid).collection('plants');

  plantCollection
      .doc(plant.id)
      .update(plant.toMap())
      .then((_) => {})
      .catchError((error) {
    throw error;
  });
});
