import 'package:flutter/material.dart';
import 'package:fuelmanager/constant/theme.dart';
import 'package:fuelmanager/ui/dialog/choice_dialog.dart';
import 'package:fuelmanager/utils/datetime_handler.dart';
import 'package:fuelmanager/widgets/custom_button.dart';
import 'package:fuelmanager/widgets/custom_textfield.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddModifyLegalDialog extends StatefulWidget {
  AddModifyLegalDialog({super.key});

  @override
  State<AddModifyLegalDialog> createState() => _AddModifyLegalDialogState();
}

class _AddModifyLegalDialogState extends State<AddModifyLegalDialog> {
  final idController = TextEditingController();

  final nameController = TextEditingController();

  final typeController = TextEditingController();

  final catController = TextEditingController();

  final dateController = TextEditingController();

  DateTime? dt;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.width * 1.1,
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  textEditingController: typeController,
                  readonly: true,
                  prefIcon: IconButton(
                      onPressed: () async {
                        final data = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ChoiceDialog(dataGroup: ["SID", "SKO"]);
                            });
                        if (data != null) {
                          typeController.text = data;
                        }
                      },
                      icon: Icon(
                        Icons.search,
                        color: kPrimaryColor,
                      )),
                  hint: "Type",
                )),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  textEditingController: catController,
                  readonly: true,
                  prefIcon: IconButton(
                      onPressed: () async {
                        final data = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ChoiceDialog(
                                  dataGroup: ["UNIT", "MENPOWER"]);
                            });
                        if (data != null) {
                          catController.text = data;
                        }
                      },
                      icon: Icon(
                        Icons.search,
                        color: kPrimaryColor,
                      )),
                  hint: "Category",
                )),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  textEditingController: idController,
                  readonly: false,
                  hint: "ID",
                )),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  textEditingController: nameController,
                  readonly: false,
                  hint: "Name",
                )),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  textEditingController: dateController,
                  readonly: true,
                  prefIcon: IconButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 400)));
                        if (date != null) {
                          dt = date;

                          dateController.text = convertToIndDate(
                              DateFormat('yyyyMMdd').format(dt!));
                        }
                      },
                      icon: Icon(
                        Icons.calendar_month_outlined,
                        color: kPrimaryColor,
                      )),
                  hint: "Valid Until",
                )),
            SizedBox(
              height: 20,
            ),
            CustomRRButton(
              borderRadius: 12,
              color: kPrimaryColor,
              contentColor: Colors.white,
              title: "Submit",
              width: Get.width * 0.3,
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
