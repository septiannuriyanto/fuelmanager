import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PassObscurerController extends GetxController {
  final hidePassword = true.obs;
  var suffixIcon = Icon(Icons.visibility).obs;

  obscureTextSwitch() {
    hidePassword(!hidePassword.value);

    if (hidePassword == true) {
      suffixIcon.value = Icon(Icons.visibility);
    } else {
      suffixIcon.value = Icon(Icons.visibility_off);
    }
  }
}
