import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:plant_tracker/models/plant.dart';

class PlantForm extends StatefulWidget {
  const PlantForm({Key? key}) : super(key: key);

  @override
  State<PlantForm> createState() {
    return _PlantFormState();
  }
}

class _PlantFormState extends State<PlantForm> {
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _nameHasError = false;
  bool _speciesNameHasError = false;
  bool _locationHasError = false;
  bool _plantTypeHasError = false;

  var plantTypeOptions = PlantType.values.map((c) => c.toString().split('.').last).toList();

  
  void _onChanged(dynamic val) => debugPrint(val.toString());

  @override
  Widget build(BuildContext context) {
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
                  debugPrint(_formKey.currentState!.value.toString());
                },
                autovalidateMode: AutovalidateMode.disabled,
                initialValue: const {
                  'type': 'fern',
                },
                skipDisabled: true,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 15),
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
                          _nameHasError = !(_formKey.currentState?.fields['name']
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
                          _speciesNameHasError = !(_formKey.currentState?.fields['species_name']
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
                          _locationHasError = !(_formKey.currentState?.fields['location']
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
                          labelText:
                              'Temperature preference:'),
                      name: 'temperature',
                      initialValue: 'medium',
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
                      onChanged: _onChanged,
                    ),
                    FormBuilderChoiceChip<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                          labelText:
                              'Humidity preference:'),
                      name: 'humidity',
                      initialValue: 'medium',
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
                      onChanged: _onChanged,
                    ),
                    FormBuilderChoiceChip<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                          labelText:
                              'Light preference:'),
                      name: 'light_levels',
                      initialValue: 'medium',
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
                      onChanged: _onChanged,
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          debugPrint(_formKey.currentState?.value.toString());
                        } else {
                          debugPrint(_formKey.currentState?.value.toString());
                          debugPrint('validation failed');
                        }
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
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
