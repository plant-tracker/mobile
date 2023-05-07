import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class PlantTypeCard extends StatefulWidget {
  const PlantTypeCard({
    Key? key,
    required this.plantType,
  }) : super(key: key);

  final String plantType;

  @override
  _PlantTypeCardState createState() => _PlantTypeCardState();
}

class _PlantTypeCardState extends State<PlantTypeCard> {
  Map<String, dynamic> _plantTypes = {};

  @override
  void initState() {
    super.initState();
    _loadPlantTypes();
  }

  Future<void> _loadPlantTypes() async {
    String jsonString = await rootBundle.loadString('assets/plant_types.json');
    setState(() {
      _plantTypes = json.decode(jsonString);
    });
  }

  @override
  Widget build(BuildContext context) {
    String name = _plantTypes['PlantType'][widget.plantType]['name'] ?? '';
    String description =
        _plantTypes['PlantType'][widget.plantType]['description'] ?? '';

    if (name.isNotEmpty && description.isNotEmpty) {
      return Card(
        margin: const EdgeInsets.all(0),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/icons/logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
