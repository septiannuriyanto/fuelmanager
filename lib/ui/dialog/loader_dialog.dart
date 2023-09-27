import 'package:flutter/material.dart';
import 'package:fuelmanager/constant/theme.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';

class LoaderDialog {
  static showLoadingDialog(String message) async {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Dialog(
              backgroundColor: Theme.of(context).cardColor.withOpacity(0.5),
              child: LoadingWidget(context, message),
            ),
          );
        });
  }
}

Widget LoadingWidget(BuildContext context, String message) {
  return SizedBox(
    width: 200,
    height: 200,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: LoadingBouncingGrid.square(
              size: 50, backgroundColor: kPrimaryColor),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text(message),
          ),
        ),
      ],
    ),
  );
}
