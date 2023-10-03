import 'package:flutter/material.dart';
import 'package:fuelmanager/models/versions_model.dart';
import 'package:fuelmanager/utils/styler.dart';
import 'package:get/get.dart';

class UpdateVersionDialog extends StatelessWidget {
  UpdateVersionDialog({required this.ver, super.key});

  final Versions ver;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: rads(12)),
        height: Get.width * 0.8,
        width: Get.width * 0.75,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Center(
                  child: Text(
                    "Mohon update ke versi terbaru (${ver.major}.${ver.minor}.${ver.patch})\n",
                  ),
                ),
                Center(
                  child: Text(
                    'Changelog : ',
                    style: sfb(),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: ver!.changelog.map((e) {
                    return Text('• $e');
                  }).toList(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
