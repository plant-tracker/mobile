import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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

  final plantCollection =
      firestore.collection('users').doc(user.uid).collection('plants');

  final newPlantDoc = plantCollection.doc();

  try {
    await newPlantDoc.set(plant.toMap());
    return newPlantDoc.id;
  } catch (e) {
    throw e;
  }
});
