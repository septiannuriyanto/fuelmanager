import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuelmanager/constant/theme.dart';
import '/widgets/photo_container/photo_container.dart';
import 'package:get/get.dart';
import 'custom_textfield.dart';

class CustomRecorder extends StatelessWidget {
  void Function(String?)? onFieldSaved;
  void Function(String?)? onFieldChanged;
  ImageProvider? contentImage;
  int? urutan;
  TextEditingController? controller;
  VoidCallback? onImageTap;
  CustomRecorder({
    this.contentImage,
    this.controller,
    this.urutan,
    this.onImageTap,
    this.onFieldSaved,
    this.onFieldChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: kPrimaryColor)),
                  height: Get.width * 0.75,
                  width: Get.width * 0.45,
                  child: contentImage == null
                      ? IconButton(
                          icon: Icon(Icons.add_a_photo),
                          onPressed: onImageTap,
                        )
                      : PhotoContainer(
                          imageProvider: contentImage!,
                          height: Get.width * 0.75)),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(urutan.toString()),
                ),
              ),
              Container(
                color: Colors.transparent,
                width: Get.width * 0.45,
                child: CustomTextField(
                  inputFormatter: [FilteringTextInputFormatter.deny(',')],
                  enabled: true,
                  onFieldSaved: onFieldSaved,
                  onFieldChanged: onFieldChanged,
                  textEditingController: controller,
                  textInputType: TextInputType.number,
                  hint: "Depth (cm)",
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
