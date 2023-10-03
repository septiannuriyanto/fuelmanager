import '/widgets/photo_container/photo_zoom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhotoContainer extends StatelessWidget {
  final ImageProvider imageProvider;
  final double height;
  final double? width;

  PhotoContainer({
    required this.imageProvider,
    required this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? Get.width,
      height: height,
      color: Colors.black,
      child: InkWell(
        child: Image(image: imageProvider),
        onTap: () => Get.to(() => PhotoZoom(imageProvider: imageProvider)),
      ),
    );
  }
}
