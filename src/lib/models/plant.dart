import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum Humidity { low, medium, high }

enum Temperature { cold, medium, warm }

enum LightLevel { low, medium, high }

enum PlantType { bonsai, succulent, cactus, fern, other }

class Plant {
  final String id;
  final String name;
  final String speciesName;
  final PlantType type;
  final String location;
  final Humidity humidity;
  final Temperature temperature;
  final LightLevel lightLevels;
  final String photoUrl;
  final DateTime created;

  Plant(
      this.id,
      this.name,
      this.speciesName,
      this.type,
      this.location,
      this.humidity,
      this.temperature,
      this.lightLevels,
      this.photoUrl,
      this.created);

  factory Plant.fromFormData(Map<String, dynamic> formData) {
    return Plant(
      '',
      formData['name'] as String,
      formData['species_name'] as String,
      PlantType.values
          .firstWhere((e) => e.toString() == 'PlantType.${formData['type']}'),
      formData['location'] as String,
      Humidity.values.firstWhere(
          (e) => e.toString() == 'Humidity.${formData['humidity']}'),
      Temperature.values.firstWhere(
          (e) => e.toString() == 'Temperature.${formData['temperature']}'),
      LightLevel.values.firstWhere(
          (e) => e.toString() == 'LightLevel.${formData['light_levels']}'),
      formData['photo_url'],
      DateTime.now(),
    );
  }

  factory Plant.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Plant(
      doc.id,
      data['name'],
      data['species_name'],
      PlantType.values
          .firstWhere((e) => e.toString() == 'PlantType.${data['type']}'),
      data['location'],
      Humidity.values
          .firstWhere((e) => e.toString() == 'Humidity.${data['humidity']}'),
      Temperature.values.firstWhere(
          (e) => e.toString() == 'Temperature.${data['temperature']}'),
      LightLevel.values.firstWhere(
          (e) => e.toString() == 'LightLevel.${data['light_levels']}'),
      data['photo_url'],
      data['created'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'species_name': speciesName,
      'type': describeEnum(type),
      'location': location,
      'humidity': describeEnum(humidity),
      'temperature': describeEnum(temperature),
      'light_levels': describeEnum(lightLevels),
      'photo_url': photoUrl,
      'created': created,
    };
  }
}
