import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final imageProvider = StateNotifierProvider((_) => ImageProvider());

class ImageProvider extends StateNotifier<File?> {
  ImageProvider() : super(null);

  final _picker = ImagePicker();

  Future<void> pickImage(BuildContext context) async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        state = File(pickedFile.path);
      }
    } on PlatformException catch (e) {
      state = null;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text("Failed to pick image: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String?> uploadImage(BuildContext context) async {
    await pickImage(context);

    if (state == null) {
      return null;
    }

    const uuid = Uuid();
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User not logged in."),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }

    final fileName = basename(state!.path);

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      state!.path,
      '${state!.parent.path}/compressed_${uuid.v4()}$fileName',
      quality: 50,
    );

    final compressedFileName = basename(compressedFile!.path);

    final storageRef = FirebaseStorage.instance
        .ref()
        .child("users/${user.uid}/$compressedFileName");

    try {
      final uploadTask = storageRef.putFile(compressedFile);
      await uploadTask.whenComplete(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Image uploaded successfully."),
            backgroundColor: Colors.green,
          ),
        );
      });
      final url = await storageRef.getDownloadURL();
      return url;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to upload image: $e"),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }
}
