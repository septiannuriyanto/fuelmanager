import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

final getStore = GetStorage();

class Utils {
  Utils._();
}

class Utility {
  static const String IMG_KEY = 'IMAGE_KEY';
  static void saveImageStringToPreferences(String value) {
    getStore.write(IMG_KEY, value);
  }

  static void deleteImageStringFromPreferences() {
    getStore.remove(IMG_KEY);
  }

  static String getImageStringFromPreferences() {
    return getStore.read(IMG_KEY);
  }

  static MemoryImage imageFromBase64String(String base64String) {
    return MemoryImage(base64Decode(base64String));
  }

  static String base64string(Uint8List data) {
    return base64Encode(data);
  }
}

String getImageByte(File img) {
  return Utility.base64string(img.readAsBytesSync());
}

Future<File?> selectImage(BuildContext context) async {
  // Show a bottom sheet with options to select an image from the
  // device's photo gallery or take a new picture with the camera
  final ImageSource? source;

  source = await showModalBottomSheet<ImageSource>(
    context: context,
    builder: (context) => BottomSheet(
      onClosing: () {},
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.photo_library),
            title: const Text('Foto gallery'),
            onTap: () {
              Navigator.pop(context, ImageSource.gallery);
            },
          ),
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: const Text('Foto Kamera'),
            onTap: () {
              Navigator.pop(context, ImageSource.camera);
            },
          ),
        ],
      ),
    ),
  );

  if (source == null) {
    return null;
  }

  XFile? image;

  image = await ImagePicker()
      .pickImage(source: source, maxHeight: 1000, imageQuality: 85);
  if (image != null) {
    // Use the `ImageCropper` to crop the image
    final CroppedFile? croppedImage;

    croppedImage = await ImageCropper.platform
        .cropImage(sourcePath: image.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original
    ], uiSettings: [
      AndroidUiSettings(
        toolbarColor: Colors.deepOrange,
        toolbarTitle: 'Crop Image',
        statusBarColor: Colors.deepOrange.shade700,
        backgroundColor: Colors.white,
      ),
    ]
            // uiSettings: PlatformUiSettings(
            //     toolbarColor: Colors.deepOrange,
            //     toolbarTitle: 'Crop Image',
            //     statusBarColor: Colors.deepOrange.shade700,
            //     backgroundColor: Colors.white,
            //   ),
            );

    // If the user successfully cropped the image, set it as the
    // current image
    if (croppedImage == null) {
      return null;
    } else {
      return File(croppedImage.path);
    }
  }
}
