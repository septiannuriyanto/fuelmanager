import 'package:flutter/material.dart';

class MenuModel {
  Image? img;
  String? desc;
  VoidCallback? ontap;
  dynamic parameter;

  MenuModel({
    this.parameter,
    this.img,
    this.desc,
    this.ontap,
  });
}
