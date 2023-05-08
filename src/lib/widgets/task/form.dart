import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:plant_tracker/models/task.dart';
import 'package:plant_tracker/providers/firestore.dart';
import 'package:plant_tracker/widgets/image_uploader.dart';

class TaskForm extends ConsumerStatefulWidget {
  final String plantId;

  const TaskForm({Key? key, required this.plantId}) : super(key: key);

  @override
  ConsumerState<TaskForm> createState() {
    return _TaskFormState();
  }
}

class _TaskFormState extends ConsumerState<TaskForm> {
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _nameHasError = true;
  bool _descriptionHasError = true;

  var plantTaskTypeOptions = [
    'Water',
    'Fertilize',
    'Prune',
    'Repot',
    'Mist',
    'Rotate',
    'Other'
  ];

  void _addTask(BuildContext context) async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      try {
        final formData = _formKey.currentState?.value;
        if (formData == null) {
          throw Exception('Invalid data.');
        }

        final task = TaskData.fromFormData(formData);

        ref.read(firestoreAddTaskProvider(task));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task added successfully'),
            backgroundColor: Colors.green,
          ),
        );
        final plantId = task.plantId;
        context.go("/plants/$plantId");
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding task: $error'),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          FormBuilder(
            key: _formKey,
            onChanged: () {
              _formKey.currentState!.save();
            },
            autovalidateMode: AutovalidateMode.disabled,
            initialValue: {
              'plant_id': widget.plantId,
              'name': 'Water',
            },
            skipDisabled: true,
            child: Column(
              children: <Widget>[
                FormBuilderDropdown<String>(
                  name: 'name',
                  decoration: InputDecoration(
                    labelText: 'Name',
                    suffix: _nameHasError
                        ? const Icon(Icons.error)
                        : const Icon(Icons.check),
                    hintText: 'Select Task Type',
                  ),
                  validator: FormBuilderValidators.compose(
                      [FormBuilderValidators.required()]),
                  items: plantTaskTypeOptions
                      .map((taskType) => DropdownMenuItem(
                            alignment: AlignmentDirectional.center,
                            value: taskType,
                            child: Text(taskType),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _nameHasError =
                          !(_formKey.currentState?.fields['name']?.validate() ??
                              false);
                    });
                  },
                  valueTransformer: (val) => val?.toString(),
                ),
                FormBuilderTextField(
                  autovalidateMode: AutovalidateMode.always,
                  name: 'description',
                  decoration: InputDecoration(
                    labelText: 'Description',
                    suffixIcon: _descriptionHasError
                        ? const Icon(Icons.error, color: Colors.red)
                        : const Icon(Icons.check, color: Colors.green),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _descriptionHasError = !(_formKey
                              .currentState?.fields['description']
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
                  name: 'frequency',
                  decoration: InputDecoration(
                    labelText: 'Frequency in Days',
                  ),
                  initialValue: '1',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                  keyboardType: TextInputType.number,
                ),
                FormBuilderDateTimePicker(
                  autovalidateMode: AutovalidateMode.always,
                  decoration: InputDecoration(
                    labelText: 'Time',
                  ),
                  name: 'time',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                  inputType: InputType.time,
                ),
                FormBuilderField(
                  name: 'plant_id',
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
                  _addTask(context);
                },
              )),
              const SizedBox(width: 20),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    final plantId = widget.plantId;
                    context.go("/plants/$plantId");
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
