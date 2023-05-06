import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDataProvider = FutureProvider<DocumentSnapshot<Map<String, dynamic>>>((ref) async {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  final user = auth.currentUser;

  if (user == null) {
    throw Exception('User not authenticated');
  }

  final userDoc = firestore.collection('users').doc(user.uid);

  final snapshot = await userDoc.get();
  return snapshot;
});
