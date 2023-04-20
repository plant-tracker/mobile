import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:plant_tracker/models/plant.dart';

class PlantService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> createPlant(Plant plant) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('plants')
        .add(plant.toFirestore());
  }

  Future<void> updatePlant(
      String plantId, Map<String, dynamic> updatedPlantData) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('plants')
        .doc(plantId)
        .update(updatedPlantData);
  }

  Future<void> deletePlant(String plantId) async {
    await this.getPlant(plantId);
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('plants')
        .doc(plantId)
        .delete();
  }

  Future<List<Plant>> getAllPlants() async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('plants')
        .orderBy('created', descending: true)
        .get();
    return querySnapshot.docs.map((doc) => Plant.fromFirestore(doc)).toList();
  }

  Future<Plant> getPlant(String plantId) async {
    final docSnapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('plants')
        .doc(plantId)
        .get();

    if (!docSnapshot.exists) {
      throw Exception('plantDoesNotExists');
    }

    return Plant.fromFirestore(docSnapshot);
  }
}
