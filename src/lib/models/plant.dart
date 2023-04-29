import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';


enum Humidity { low, medium, high }

enum Temperature { cold, moderate, warm }

enum LightLevel { low, medium, high }

class Plant {
  final String id;
  final String name;
  final String speciesName;
  final String type;
  final String location;
  final Humidity humidity;
  final Temperature temperature;
  final LightLevel lightLevels;
  final String photoUrl;
  final DateTime created;

  Plant(@required this.id,
   @required this.name, 
   @required this.speciesName, 
   @required this.type, 
   @required this.location, 
   @required this.humidity,
   @required this.temperature,
   @required this.lightLevels, 
   @required this.photoUrl, 
   @required this.created);

  factory Plant.fromFirestore(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;
    return Plant(
      doc.id,
      data['name'],
      data['species_name'],
      data['type'],
      data['location'],
      Humidity.values.firstWhere((e) => e.toString() == 'Humidity.${data['humidity']}'),
      Temperature.values.firstWhere((e) => e.toString() == 'Temperature.${data['temperature']}'),
      LightLevel.values.firstWhere((e) => e.toString() == 'LightLevel.${data['light_levels']}'),
      data['photo_url'],
      data['created'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'species_name': speciesName,
      'type': type,
      'location': location,
      'humidity': describeEnum(humidity),
      'temperature': describeEnum(temperature),
      'light_levels': describeEnum(lightLevels),
      'photo_url': photoUrl,
      'created': created,
    };
  }
}
