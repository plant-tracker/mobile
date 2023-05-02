import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:plant_tracker/models/plant.dart';

final firestoreGetPlantProvider =
    StreamProvider.family<Plant?, String>((ref, plantId) {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  final user = auth.currentUser;

  if (user == null) {
    return Stream.value(null);
  }

  final plantDoc = firestore
      .collection('users')
      .doc(user.uid)
      .collection('plants')
      .doc(plantId)
      .withConverter<Plant?>(
        fromFirestore: (snapshot, _) => Plant.fromFirestore(snapshot),
        toFirestore: (plant, _) => plant?.toMap() ?? {},
      );

  return plantDoc.snapshots().map((snapshot) => snapshot.data());
});
