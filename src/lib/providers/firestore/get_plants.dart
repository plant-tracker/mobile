import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:plant_tracker/models/plant.dart';

final firestoreGetPlantsProvider =
    StreamProvider.autoDispose<List<Plant>>((ref) {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  final user = auth.currentUser;

  if (user == null) {
    return Stream.value([]);
  }

  final plantsCollection = firestore
      .collection('users')
      .doc(user.uid)
      .collection('plants')
      .withConverter<Plant>(
        fromFirestore: (snapshot, _) => Plant.fromFirestore(snapshot),
        toFirestore: (plant, _) => plant.toMap(),
      );

  return plantsCollection.orderBy('created', descending: true).snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
      );
});
