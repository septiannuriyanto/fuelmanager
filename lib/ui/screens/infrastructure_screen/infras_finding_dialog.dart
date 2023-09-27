import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fuelmanager/constant/theme.dart';
import 'package:fuelmanager/models/user_model.dart';
import 'package:fuelmanager/services/image_uploader.dart';
import 'package:fuelmanager/utils/datetime_handler.dart';
import 'package:fuelmanager/utils/image_handler.dart';
import 'package:fuelmanager/utils/styler.dart';
import 'package:fuelmanager/widgets/custom_button.dart';
import 'package:fuelmanager/widgets/custom_snackbar.dart';
import 'package:fuelmanager/widgets/custom_textfield.dart';
import 'package:fuelmanager/widgets/photo_container/photo_container.dart';
import 'package:get/get.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../functions/functions.dart';
import '../../../functions/secrets.dart';
import '../../dialog/loader_dialog.dart';
import 'package:path/path.dart' as p;

class InfrasFindingDialog extends StatefulWidget {
  InfrasFindingDialog({required this.id, required this.unit, super.key});

  String unit, id;

  @override
  State<InfrasFindingDialog> createState() => _InfrasFindingDialogState();
}

class _InfrasFindingDialogState extends State<InfrasFindingDialog> {
  String? imgUrl;
  ImageProvider? finding_img;
  File? finding_file;
  final desc_c = TextEditingController();
  final root_c = TextEditingController();
  final action_c = TextEditingController();
  final duedate_c = TextEditingController();
  AppUserData? appUserData;
  SharedPreferences? prefs;
  DateTime chosenDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    getCredentials();
  }

  getCredentials() async {
    prefs = await SharedPreferences.getInstance();
    appUserData = await AppUserData.fromSharedPreferences(prefs!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            height: size.height * 0.75,
            width: size.width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Input Temuan Baru",
                      style: sfbs(20),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text("Unit"),
                                  ),
                                  Expanded(
                                    child: Text(": ${widget.unit}"),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text("Component ID"),
                                  ),
                                  Expanded(
                                    child: Text(": ${widget.id}"),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text("Tanggal temuan"),
                                  ),
                                  Expanded(
                                    child: Text(": ${formattedTodayIndDate()}"),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text("PIC"),
                                  ),
                                  Expanded(
                                    child: appUserData == null
                                        ? Text("Loading...")
                                        : Text(": Septian Nuriyanto"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: size.width * 0.2,
                              width: size.width * 0.2,
                              decoration: barr(context, 12),
                              child: finding_img == null
                                  ? Center(
                                      child: IconButton(
                                          onPressed: () async {
                                            File? file =
                                                await selectImage(context);
                                            if (file != null) {
                                              String dir = p.dirname(file.path);
                                              String newPath = p.join(dir,
                                                  '$formattedToday-${widget.unit}${widget.id}-finding.jpg');
                                              //print(newPath);
                                              finding_file =
                                                  await file.copy(newPath);
                                              finding_file!.renameSync(newPath);
                                              // final fileString = Utility.base64string(
                                              //     file.readAsBytesSync());
                                              // await getStore.write('awal1_img', fileString);
                                              finding_img = MemoryImage(
                                                  file.readAsBytesSync());
                                              file.delete();
                                              setState(() {});
                                            }
                                          },
                                          icon: Icon(
                                            Icons.add_a_photo_outlined,
                                            color:
                                                Theme.of(context).primaryColor,
                                          )),
                                    )
                                  : ClipRRect(
                                      borderRadius: rads(12),
                                      child: PhotoContainer(
                                          imageProvider: finding_img!,
                                          height: size.width * 0.2),
                                    )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                      textEditingController: desc_c,
                      hint: "Deskripsi Temuan",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                      textEditingController: root_c,
                      hint: "Akar Penyebab",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                      textEditingController: action_c,
                      hint: "Action",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                      readonly: true,
                      textEditingController: duedate_c,
                      hint: "Due Date",
                      prefIcon: IconButton(
                          onPressed: () async {
                            final newDate = await showDatePicker(
                              context: context,
                              initialDate: chosenDate,
                              firstDate: chosenDate,
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                        primary:
                                            kSecondaryColor, // <-- SEE HERE
                                        onPrimary:
                                            kPrimaryColor, // <-- SEE HERE
                                        onSurface: kPrimaryColor // <-- SEE HERE
                                        ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                          foregroundColor:
                                              kPrimaryColor // button text color
                                          ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );

                            if (newDate != null) {
                              chosenDate = newDate;
                              duedate_c.text = formattedSlashDate(chosenDate);
                            }
                          },
                          icon: Icon(Icons.calendar_month_outlined)),
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomRRButton(
                        color: Theme.of(context).primaryColor,
                        contentColor: Colors.white,
                        borderRadius: 12,
                        title: "Submit",
                        width: size.width * 0.3,
                        onTap: () async {
                          final res = await sendForm(null);
                          if (res == true) {
                            String valid = _validate();
                            if (valid == "ok") {
                              final res = await submitFindings();
                              if (res == 0) Navigator.pop(context, "ok");
                            } else {
                              customErrorMessage("Invalid Input", valid);
                            }
                          }
                        }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _validate() {
    if (desc_c.text.isEmpty) return "Mohon isi deskripsi";
    if (root_c.text.isEmpty) return "Mohon isi akar penyebab";
    if (action_c.text.isEmpty) return "Mohon isi action";
    if (duedate_c.text.isEmpty) return "Mohon isi due date";
    if (finding_img == null) return "Mohon tambahkan foto evidence";
    return "ok";
  }

  Future<int> submitFindings() async {
    LoaderDialog.showLoadingDialog("Submitting Data");

    imgUrl = await ImageUploader.uploadFinding(
      finding_file,
      formattedToday,
      widget.unit,
    );

    //Submit data to GoogleSheet
    final gsheets = GSheets(credentials);
    final ss = await gsheets.spreadsheet(confisSheet);
    var sheet = ss.worksheetByTitle('Findings');
    final dst = await sheet!.values.allRows(fromRow: 1);
    int lastRow = dst.length;

    final data = [
      '${widget.unit}${widget.id}',
      widget.id,
      widget.unit,
      desc_c.text,
      root_c.text,
      action_c.text,
      duedate_c.text,
      appUserData!.name,
      "OPEN",
      DateFormat('dd/MM/yyyy').format(DateTime.now()),
      imgUrl,
    ];
    await sheet.values.insertRow(lastRow + 1, data);
    Get.back();
    return 0;
  }
}
