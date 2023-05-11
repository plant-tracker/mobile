import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_tracker/models/user_data.dart';

final userDataProvider = StreamProvider.autoDispose<UserData>((ref) async* {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  final user = auth.currentUser;

  if (user == null) {
    throw Exception('User not authenticated');
  }

  final userDoc =
      firestore.collection('users').doc(user.uid).withConverter<UserData>(
            fromFirestore: (snapshot, _) => UserData.fromFirestore(snapshot),
            toFirestore: (userData, _) => userData.toMap(),
          );

  final doc = await userDoc.get();

  if (!doc.exists) {
    userDoc.set(UserData.defaultData());
  }

  yield* userDoc.snapshots().map((snapshot) => snapshot.data()!);
});
