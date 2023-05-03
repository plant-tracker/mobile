import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:plant_tracker/models/plant.dart';
import 'package:plant_tracker/providers/firestore.dart';
import 'package:plant_tracker/widgets/image_uploader.dart';

class PlantForm extends ConsumerStatefulWidget {
  final Plant? editedPlant;

  const PlantForm({Key? key, this.editedPlant}) : super(key: key);

  @override
  ConsumerState<PlantForm> createState() {
    return _PlantFormState();
  }
}

class _PlantFormState extends ConsumerState<PlantForm> {
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _nameHasError = true;
  bool _speciesNameHasError = true;
  bool _locationHasError = true;
  bool _plantTypeHasError = false;

  var plantTypeOptions =
      PlantType.values.map((c) => c.toString().split('.').last).toList();

  void _addPlant(BuildContext context) async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      try {
        final formData = _formKey.currentState?.value;
        if (formData == null) {
          throw Exception('Invalid data.');
        }

        final plant = Plant.fromFormData(formData);

        ref.read(firestoreAddPlantProvider(plant));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Plant added successfully'),
            backgroundColor: Colors.green,
          ),
        );
        context.go("/plants");
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding plant: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Validation failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _editPlant(BuildContext context) async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      try {
        final formData = _formKey.currentState?.value;
        if (formData == null) {
          throw Exception('Invalid data.');
        }

        final plant = Plant.fromFormData(formData);
        ref.read(firestoreEditPlantProvider(plant));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Plant edited successfully'),
            backgroundColor: Colors.green,
          ),
        );

        context.go("/plants");
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error editing plant: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Validation failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.editedPlant != null) {
      _nameHasError = false;
      _speciesNameHasError = false;
      _locationHasError = false;
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FormBuilder(
                key: _formKey,
                onChanged: () {
                  _formKey.currentState!.save();
                },
                autovalidateMode: AutovalidateMode.disabled,
                initialValue: widget.editedPlant?.toFormData() ??
                    {
                      'id': "",
                      'type': 'fern',
                      'photo_url': "",
                      'created': "",
                    },
                skipDisabled: true,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 15),
                    FormBuilderField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'photo_url',
                      builder: (FormFieldState<String?> field) {
                        return HookBuilder(
                          builder: (context) => ImageUploader(
                              initialValue: widget.editedPlant?.photoUrl ?? "",
                              onChanged: field.didChange),
                        );
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'name',
                      decoration: InputDecoration(
                        labelText: 'Name',
                        suffixIcon: _nameHasError
                            ? const Icon(Icons.error, color: Colors.red)
                            : const Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _nameHasError = !(_formKey
                                  .currentState?.fields['name']
                                  ?.validate() ??
                              false);
                        });
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                      textInputAction: TextInputAction.next,
                    ),
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'species_name',
                      decoration: InputDecoration(
                        labelText: 'Species',
                        suffixIcon: _speciesNameHasError
                            ? const Icon(Icons.error, color: Colors.red)
                            : const Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _speciesNameHasError = !(_formKey
                                  .currentState?.fields['species_name']
                                  ?.validate() ??
                              false);
                        });
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                      textInputAction: TextInputAction.next,
                    ),
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'location',
                      decoration: InputDecoration(
                        labelText: 'Location',
                        suffixIcon: _locationHasError
                            ? const Icon(Icons.error, color: Colors.red)
                            : const Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _locationHasError = !(_formKey
                                  .currentState?.fields['location']
                                  ?.validate() ??
                              false);
                        });
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                      textInputAction: TextInputAction.next,
                    ),
                    FormBuilderDropdown<String>(
                      name: 'type',
                      decoration: InputDecoration(
                        labelText: 'Type',
                        suffix: _plantTypeHasError
                            ? const Icon(Icons.error)
                            : const Icon(Icons.check),
                        hintText: 'Select Type',
                      ),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      items: plantTypeOptions
                          .map((plantType) => DropdownMenuItem(
                                alignment: AlignmentDirectional.center,
                                value: plantType,
                                child: Text(plantType),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _plantTypeHasError = !(_formKey
                                  .currentState?.fields['type']
                                  ?.validate() ??
                              false);
                        });
                      },
                      valueTransformer: (val) => val?.toString(),
                    ),
                    FormBuilderChoiceChip<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                          labelText: 'Temperature preference:'),
                      name: 'temperature',
                      initialValue: widget.editedPlant?.temperature != null
                          ? describeEnum(widget.editedPlant!.temperature)
                          : 'medium',
                      options: const [
                        FormBuilderChipOption(
                          value: 'cold',
                        ),
                        FormBuilderChipOption(
                          value: 'medium',
                        ),
                        FormBuilderChipOption(
                          value: 'warm',
                        ),
                      ],
                    ),
                    FormBuilderChoiceChip<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                          labelText: 'Humidity preference:'),
                      name: 'humidity',
                      initialValue: widget.editedPlant?.humidity != null
                          ? describeEnum(widget.editedPlant!.humidity)
                          : 'medium',
                      options: const [
                        FormBuilderChipOption(
                          value: 'low',
                        ),
                        FormBuilderChipOption(
                          value: 'medium',
                        ),
                        FormBuilderChipOption(
                          value: 'high',
                        ),
                      ],
                    ),
                    FormBuilderChoiceChip<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration:
                          const InputDecoration(labelText: 'Light preference:'),
                      name: 'light_levels',
                      initialValue: widget.editedPlant?.lightLevels != null
                          ? describeEnum(widget.editedPlant!.lightLevels)
                          : 'medium',
                      options: const [
                        FormBuilderChipOption(
                          value: 'low',
                        ),
                        FormBuilderChipOption(
                          value: 'medium',
                        ),
                        FormBuilderChipOption(
                          value: 'high',
                        ),
                      ],
                    ),
                    FormBuilderField(
                      name: 'id',
                      builder: (FormFieldState<dynamic> field) {
                        return const SizedBox.shrink();
                      },
                    ),
                    FormBuilderField(
                      name: 'created',
                      builder: (FormFieldState<dynamic> field) {
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: ElevatedButton(
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (widget.editedPlant == null) {
                        _addPlant(context);
                      } else {
                        _editPlant(context);
                      }
                    },
                  )),
                  const SizedBox(width: 20),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _formKey.currentState?.reset();
                      },
                      child: Text(
                        'Reset',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
