import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    test('User should create plant document for themselves.', () async {
      final plantId = 'plant1';
      final uid = auth.currentUser!.uid;

      expect(
          () => firestore.doc('users/$uid/plants/$plantId').set(storeablePlantData(plantId)), returnsNormally);
    });

    test('User should not create plant document for others.', () async {
      final plantId = 'plant1';
      final uid = auth.currentUser!.uid;

      expect(() => firestore.doc('users/abcdef/plants/$plantId').set(storeablePlantData(plantId)),
          throwsException);
    });
  });
}
