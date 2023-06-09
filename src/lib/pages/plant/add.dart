import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:plant_tracker/widgets/plant/form.dart';

class PlantAddPage extends ConsumerWidget {
  const PlantAddPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: PlantForm(),
    );
  }
}
