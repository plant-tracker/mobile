import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:plant_tracker/providers/image_upload.dart';

class ImageUploader extends HookConsumerWidget {
  final String? initialValue;
  final void Function(String?) onChanged;

  const ImageUploader({Key? key, this.initialValue, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(imageProvider.notifier).state;
    final photoUrlController = useTextEditingController(text: initialValue);

    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            final url =
                await ref.read(imageProvider.notifier).uploadImage(context);
            if (url != null) {
              photoUrlController.text = url;
              onChanged(url);
            }
          },
          child: Container(
            width: 200,
            height: 200,
            child: imageState != null && !photoUrlController.text.isEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/plant_placeholder.png',
                      image: photoUrlController.text,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2.0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, color: Colors.green, size: 50),
                        SizedBox(height: 8),
                        Text(
                          'Upload Image',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
