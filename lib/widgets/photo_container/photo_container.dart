import '/widgets/photo_container/photo_zoom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhotoContainer extends StatelessWidget {
  ImageProvider imageProvider;
  double height;

  PhotoContainer({required this.imageProvider, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: height,
      color: Colors.black,
      child: InkWell(
        child: Image(image: imageProvider),
        onTap: () => Get.to(() => PhotoZoom(imageProvider: imageProvider)),
      ),
    );
  }
}
