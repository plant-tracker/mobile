import 'package:cloud_firestore/cloud_firestore.dart';

class Plant {
  final String name;
  final String speciesName;
  final String type;
  final String location;
  final String humidity;
  final String temperature;
  final String lightLevels;
  final String photoUrl;
  final DateTime created;

  Plant(this.name, this.speciesName, this.type, this.location, this.humidity,
      this.temperature, this.lightLevels, this.photoUrl, this.created);

  factory Plant.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Plant(
      data['name'],
      data['species_name'],
      data['type'],
      data['location'],
      data['humidity'],
      data['temperature'],
      data['light_levels'],
      data['photo_url'],
      data['created'].toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'species_name': speciesName,
      'type': type,
      'location': location,
      'humidity': humidity,
      'temperature': temperature,
      'light_levels': lightLevels,
      'photo_url': photoUrl,
      'created': created,
    };
  }
}
