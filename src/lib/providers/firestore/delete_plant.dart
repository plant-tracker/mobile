import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreDeletePlantProvider =
    FutureProvider.autoDispose.family<void, String>((ref, plantId) async {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  final user = auth.currentUser;

  if (user == null) {
    throw Exception('User not logged in');
  }

  final plantDoc = firestore
      .collection('users')
      .doc(user.uid)
      .collection('plants')
      .doc(plantId);

  try {
    await plantDoc.delete();
  } catch (e) {
    rethrow;
  }
});
