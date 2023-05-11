import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

enum Humidity { low, medium, high }

enum Temperature { cool, medium, warm }

enum LightLevel { low, medium, high }

enum PlantType { bonsai, succulent, herb, tree, flower, cactus, fern, seed_plant, other }

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
      formData['id'] as String,
      formData['name'] as String,
      formData['species_name'] as String,
      PlantType.values.firstWhere((e) => describeEnum(e) == formData['type']),
      formData['location'] as String,
      Humidity.values
          .firstWhere((e) => describeEnum(e) == formData['humidity']),
      Temperature.values
          .firstWhere((e) => describeEnum(e) == formData['temperature']),
      LightLevel.values
          .firstWhere((e) => describeEnum(e) == formData['light_levels']),
      formData['photo_url'] as String,
      (formData['created'] as String).isNotEmpty
          ? DateTime.parse(formData['created'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFormData() {
    return {
      'id': id,
      'name': name,
      'species_name': speciesName,
      'type': describeEnum(type),
      'location': location,
      'humidity': describeEnum(humidity),
      'temperature': describeEnum(temperature),
      'light_levels': describeEnum(lightLevels),
      'photo_url': photoUrl,
      'created': created.toIso8601String(),
    };
  }

  factory Plant.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Plant(
      doc.id,
      data['name'],
      data['species_name'],
      PlantType.values
          .firstWhere((e) => e.toString().replaceAll('_', ' ') == 'PlantType.${data['type']}'),
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
      'type': describeEnum(type).replaceAll('_', ' '),
      'location': location,
      'humidity': describeEnum(humidity),
      'temperature': describeEnum(temperature),
      'light_levels': describeEnum(lightLevels),
      'photo_url': photoUrl,
      'created': created,
    };
  }
}
