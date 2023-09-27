import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/custom_button.dart';

Future<bool?> sendForm(String? title) async {
  bool? res = await Get.defaultDialog(
    title: "Confirmation",
    content:
        title == null ? Text("Anda yakin untuk memprosesnya?") : Text(title),
    textConfirm: "Ya",
    textCancel: "Tidak",
    barrierDismissible: true,
    confirm: CustomRRButton(
      borderRadius: 12,
      title: "Ya",
      width: Get.width * 0.25,
      onTap: () {
        print("Ya");
        Get.back(result: true);
      },
      color: Colors.greenAccent,
    ),
    cancel: CustomRRButton(
      borderRadius: 12,
      title: "Tidak",
      width: Get.width * 0.25,
      onTap: () {
        print("Tidak");
        Get.back(result: false);
      },
      color: Colors.redAccent,
    ),
  );

  return res;
}
