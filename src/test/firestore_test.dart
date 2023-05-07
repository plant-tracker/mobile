import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

late FakeFirebaseFirestore firestore;
final auth = MockFirebaseAuth();

Map<String, dynamic> storeablePlantData(String plantId) {
  return {
    'name': 'Plant $plantId',
    'species_name': 'Species of $plantId',
    'type': "fern",
    'location': "Location of $plantId",
    'humidity': "low",
    'temperature': "low",
    'light_levels': "low",
    'photo_url': "https://example.com/images/photo-$plantId.jpg",
    'created': DateTime.now(),
  };
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  String? firestoreRules;

  setUpAll(() async {
    final currentDir = Directory.current;
    final configDir = Directory(path.join(currentDir.path, 'firebase-config'));
    final file = File(path.join(configDir.path, 'firestore.rules'));

    firestoreRules = await file.readAsString();

    auth.createUserWithEmailAndPassword(
      email: "mock@example.com",
      password: "Mock-1234!test"
    );
  });
  
  group('firestore', () {
    setUp(() async {
      firestore = FakeFirebaseFirestore(
        securityRules: firestoreRules,
        authObject: auth.authForFakeFirestore
      );
      
      await auth.signInWithEmailAndPassword(
        email: "mock@example.com",
        password: "Mock-1234!test"
      );
    });

    tearDown(() async {
      await auth.signOut();
    });

    test('User can create his own document.', () async {
      final uid = auth.currentUser!.uid;
      expect(() => firestore.doc('users/$uid').set({}), returnsNormally);
    });

    test('User should create plant document for themselves and increment totals in batch, then delete.', () async {
      final plantId = 'plant1';
      final uid = auth.currentUser!.uid;

      final batch = firestore.batch();

      final userDoc = firestore.collection('users').doc(uid);
      final newPlantDoc = userDoc.collection('plants').doc();

      batch.set(newPlantDoc, storeablePlantData(plantId));
      batch.set(userDoc, {'total_plants': FieldValue.increment(1)}, SetOptions(merge : true));

      expect(() => batch.commit(), returnsNormally);

      final batchDelete = firestore.batch();
      
      batchDelete.delete(newPlantDoc);
      batchDelete.set(userDoc, {'total_plants': FieldValue.increment(-1)}, SetOptions(merge : true));

      expect(() => batchDelete.commit(), returnsNormally);
    });

    test('User should not create plant document for others.', () async {
      final plantId = 'plant1';
      final uid = auth.currentUser!.uid;

      expect(() => firestore.doc('users/abcdef/plants/$plantId').set(storeablePlantData(plantId)),
          throwsException);
    });
  });
}
