import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class PhotoZoom extends StatelessWidget {
  ImageProvider imageProvider;
  PhotoZoom({required this.imageProvider});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: Get.width,
        width: Get.width,
        child: PhotoView(imageProvider: imageProvider),
      ),
    );
  }
}
