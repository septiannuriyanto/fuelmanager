import 'package:flutter/material.dart';
import 'package:fuelmanager/utils/styler.dart';
import 'package:fuelmanager/widgets/custom_button.dart';
import 'package:get/get.dart';

import '../constant/theme.dart';

class CustomUserApprovalForm extends StatelessWidget {
  String type;
  String nama;
  String email;
  String uid;
  String company;
  String role;
  void Function()? onFirstTap;
  void Function()? onSecondTap;

  CustomUserApprovalForm({
    Key? key,
    required this.type,
    required this.nama,
    required this.email,
    required this.uid,
    required this.company,
    required this.role,
    this.onFirstTap,
    this.onSecondTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
            borderRadius: rads(12), border: Border.all(color: kPrimaryColor)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(flex: 1, child: Text("Nama")),
                  Expanded(flex: 2, child: Text(nama)),
                ],
              ),
              Row(
                children: [
                  Expanded(flex: 1, child: Text("Perusahaan")),
                  Expanded(flex: 2, child: Text(company)),
                ],
              ),
              Row(
                children: [
                  Expanded(flex: 1, child: Text("NRP")),
                  Expanded(flex: 2, child: Text(uid)),
                ],
              ),
              Row(
                children: [
                  Expanded(flex: 1, child: Text("Email")),
                  Expanded(flex: 2, child: Text(email)),
                ],
              ),
              Row(
                children: [
                  Expanded(flex: 1, child: Text("Role")),
                  Expanded(flex: 2, child: Text(role)),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              type == "new"
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomRRButton(
                            borderRadius: 12,
                            color: Colors.greenAccent,
                            title: "Approve",
                            width: Get.width * 0.4,
                            onTap: onFirstTap),
                        CustomRRButton(
                            borderRadius: 12,
                            color: Colors.redAccent,
                            title: "Reject",
                            width: Get.width * 0.4,
                            onTap: onSecondTap)
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: Get.width * 0.4,
                          child: Center(
                            child: Text(
                              "Registered",
                              style: TextStyle(color: Colors.green.shade700),
                            ),
                          ),
                        ),
                        CustomRRButton(
                            borderRadius: 12,
                            color: Colors.redAccent,
                            title: "Delete",
                            width: Get.width * 0.4,
                            onTap: onSecondTap)
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
