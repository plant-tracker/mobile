import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDataProvider =
    StreamProvider<DocumentSnapshot<Map<String, dynamic>>>((ref) {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  return auth.authStateChanges().asyncMap((user) async {
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final userDoc = firestore.collection('users').doc(user.uid);

    final snapshot = await userDoc.get();

    if (!snapshot.exists) {
      await userDoc.set({}, SetOptions(merge: true));
      return await userDoc.get();
    }

    return snapshot;
  });
});
