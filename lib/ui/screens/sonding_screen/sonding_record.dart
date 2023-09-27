import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fuelmanager/models/report_model.dart';
import 'package:fuelmanager/services/google_sheet_report.dart';
import 'package:fuelmanager/services/image_uploader.dart';
import 'package:fuelmanager/services/terra_getter.dart';
import 'package:fuelmanager/ui/screens/sonding_screen/sonding_history.dart';
import 'package:fuelmanager/constant/theme.dart';
import 'package:fuelmanager/utils/datetime_handler.dart';
import 'package:fuelmanager/utils/image_handler.dart';
import 'package:fuelmanager/utils/styler.dart';
import 'package:fuelmanager/widgets/custom_appbar.dart';
import 'package:fuelmanager/widgets/custom_button.dart';
import 'package:fuelmanager/widgets/custom_datepicker.dart';
import 'package:fuelmanager/widgets/custom_snackbar.dart';
import 'package:fuelmanager/widgets/recorder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/user_model.dart';
import '../../dialog/loader_dialog.dart';

class SondingRecord extends StatefulWidget {
  @override
  State<SondingRecord> createState() => _SondingRecordState();
}

class _SondingRecordState extends State<SondingRecord> {
  SharedPreferences? prefs;
  AppUserData? appUserData;
  final awal1_con = TextEditingController();
  final awal2_con = TextEditingController();
  final awal3_con = TextEditingController();
  final akhir1_con = TextEditingController();
  final akhir2_con = TextEditingController();
  final akhir3_con = TextEditingController();

  ImageProvider? awal1_img;
  ImageProvider? awal2_img;
  ImageProvider? awal3_img;
  ImageProvider? akhir1_img;
  ImageProvider? akhir2_img;
  ImageProvider? akhir3_img;
  bool isLoaded = false;

  File? awal1_file;
  File? awal2_file;
  File? awal3_file;
  File? akhir1_file;
  File? akhir2_file;
  File? akhir3_file;

  double? avgAwal;
  double? avgAkhir;
  double? awalQty;
  double? akhirQty;
  double? usageQty;

  DateTime chosenDate = DateTime.now();
  List<Tera>? TeraBC;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    asyncFunction();
    getCredentials();
    setState(() {
      avgAwal = 0;
      avgAkhir = 0;
      awalQty = 0;
      akhirQty = 0;
      isLoaded = true;
    });
  }

  getCredentials() async {
    prefs = await SharedPreferences.getInstance();
    appUserData = await AppUserData.fromSharedPreferences(prefs!);
    Future.delayed(const Duration(seconds: 2)).then((value) {
      setState(() {});
    });
  }

  callback(varReturnedDate) {
    setState(() {
      chosenDate = varReturnedDate;
    });
  }

  asyncFunction() async {
    final awal1_string = await getStore.read('awal1_img');
    final awal2_string = await getStore.read('awal2_img');
    final awal3_string = await getStore.read('awal3_img');
    final akhir1_string = await getStore.read('akhir1_img');
    final akhir2_string = await getStore.read('akhir2_img');
    final akhir3_string = await getStore.read('akhir3_img');

    if (awal1_string.toString() != 'null') {
      awal1_img = Utility.imageFromBase64String(awal1_string);
      setState(() {});
    }
    if (awal2_string != null) {
      setState(() {
        awal2_img = Utility.imageFromBase64String(awal2_string);
      });
    }
    if (awal3_string != null) {
      setState(() {
        awal3_img = Utility.imageFromBase64String(awal3_string);
      });
    }
    if (akhir1_string != null) {
      setState(() {
        akhir1_img = Utility.imageFromBase64String(akhir1_string);
      });
    }
    if (akhir2_string != null) {
      setState(() {
        akhir2_img = Utility.imageFromBase64String(akhir2_string);
      });
    }
    if (akhir3_string != null) {
      setState(() {
        akhir3_img = Utility.imageFromBase64String(akhir3_string);
      });
    }

    LoaderDialog.showLoadingDialog("Downloading Terra Table");
    TeraBC = await getTera();
    Get.back();
    customSuccessMessage("Success", "Terra table is present");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isLoaded,
      replacement: const CircularProgressIndicator(),
      child: Scaffold(
        body: Column(
          children: [
            CustomAppBar(
                title: "Sonding Record",
                trailingButton: IconButton(
                    onPressed: () {
                      Get.to(() => SondingHistory());
                    },
                    icon: const Icon(Icons.my_library_books_outlined))),
            const SizedBox(
              height: 40,
            ),
            appUserData != null
                ? Text('Sonding By : ${appUserData!.name}')
                : Text(''),
            CustomDatePicker(
              callbackFunction: callback,
              chosenDate: chosenDate,
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    color: kSecondaryColor,
                    height: 40,
                    width: Get.width,
                    child: Center(
                      child: Text(
                        "Awal Shift",
                        style: txt16.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Get.width,
                    height: Get.width,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomRecorder(
                            contentImage: awal1_img,
                            controller: awal1_con,
                            urutan: 1,
                            onImageTap: () async {
                              //======================================================
                              File? file = await selectImage(context);
                              if (file != null) {
                                String dir = p.dirname(file.path);
                                String newPath = p.join(dir,
                                    '${formattedDate(chosenDate)}_awal1.jpg');
                                //print(newPath);
                                awal1_file = await file.copy(newPath);
                                awal1_file!.renameSync(newPath);
                                final fileString = Utility.base64string(
                                    file.readAsBytesSync());
                                await getStore.write('awal1_img', fileString);
                                awal1_img = MemoryImage(file.readAsBytesSync());
                                file.delete();
                                setState(() {});
                              }
                              //======================================================
                            },
                            onFieldChanged: (p0) {
                              int count = 0;
                              final value2, value3;
                              if (p0!.isEmpty) {
                                return;
                              }

                              if (double.parse(p0) > 717) {
                                return;
                              }

                              if (awal1_con.text.isNotEmpty) {
                                count = count + 1;
                              }
                              if (awal2_con.text.isNotEmpty) {
                                count = count + 1;
                              }
                              if (awal3_con.text.isNotEmpty) {
                                count = count + 1;
                              }
                              if (awal2_con.text.isEmpty) {
                                value2 = '0';
                              } else {
                                value2 = awal2_con.text;
                              }
                              if (awal3_con.text.isEmpty) {
                                value3 = '0';
                              } else {
                                value3 = awal3_con.text;
                              }
                              avgAwal = (double.parse(p0) +
                                      double.parse(value2) +
                                      double.parse(value3)) /
                                  count;
                              awalQty =
                                  convertToLiter(avgAwal.toString(), TeraBC!);
                              setState(() {});
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomRecorder(
                            contentImage: awal2_img,
                            controller: awal2_con,
                            urutan: 2,
                            onImageTap: () async {
                              //======================================================
                              File? file = await selectImage(context);
                              if (file != null) {
                                String dir = p.dirname(file.path);
                                String newPath = p.join(dir,
                                    '${formattedDate(chosenDate)}_awal2.jpg');
                                //print(newPath);
                                awal2_file = await file.copy(newPath);
                                awal2_file!.renameSync(newPath);
                                final fileString = Utility.base64string(
                                    file.readAsBytesSync());
                                await getStore.write('awal2_img', fileString);
                                awal2_img = MemoryImage(file.readAsBytesSync());
                                file.delete();
                                setState(() {});
                              }
                              //======================================================
                            },
                            onFieldChanged: (p0) {
                              int count = 0;
                              final value2, value3;
                              if (p0!.isEmpty) {
                                return;
                              }
                              if (double.parse(p0) > 717) {
                                return;
                              }

                              if (awal1_con.text.isNotEmpty) {
                                count = count + 1;
                              }
                              if (awal2_con.text.isNotEmpty) {
                                count = count + 1;
                              }
                              if (awal3_con.text.isNotEmpty) {
                                count = count + 1;
                              }
                              if (awal1_con.text.isEmpty) {
                                value2 = '0';
                              } else {
                                value2 = awal1_con.text;
                              }
                              if (awal3_con.text.isEmpty) {
                                value3 = '0';
                              } else {
                                value3 = awal3_con.text;
                              }
                              avgAwal = (double.parse(p0) +
                                      double.parse(value2) +
                                      double.parse(value3)) /
                                  count;
                              awalQty =
                                  convertToLiter(avgAwal.toString(), TeraBC!);
                              setState(() {});
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomRecorder(
                            contentImage: awal3_img,
                            controller: awal3_con,
                            urutan: 3,
                            onImageTap: () async {
                              //======================================================
                              File? file = await selectImage(context);
                              if (file != null) {
                                String dir = p.dirname(file.path);
                                String newPath = p.join(dir,
                                    '${formattedDate(chosenDate)}_awal3.jpg');
                                //print(newPath);
                                awal3_file = await file.copy(newPath);
                                awal3_file!.renameSync(newPath);
                                final fileString = Utility.base64string(
                                    file.readAsBytesSync());
                                await getStore.write('awal3_img', fileString);
                                awal3_img = MemoryImage(file.readAsBytesSync());
                                file.delete();
                                setState(() {});
                              }
                              //======================================================
                            },
                            onFieldChanged: (p0) {
                              int count = 0;
                              final value2, value3;
                              if (p0!.isEmpty) {
                                return;
                              }
                              if (double.parse(p0) > 717) {
                                return;
                              }

                              if (awal1_con.text.isNotEmpty) {
                                count = count + 1;
                              }
                              if (awal2_con.text.isNotEmpty) {
                                count = count + 1;
                              }
                              if (awal3_con.text.isNotEmpty) {
                                count = count + 1;
                              }
                              if (awal1_con.text.isEmpty) {
                                value2 = '0';
                              } else {
                                value2 = awal1_con.text;
                              }
                              if (awal2_con.text.isEmpty) {
                                value3 = '0';
                              } else {
                                value3 = awal2_con.text;
                              }
                              avgAwal = (double.parse(p0) +
                                      double.parse(value2) +
                                      double.parse(value3)) /
                                  count;
                              awalQty =
                                  convertToLiter(avgAwal.toString(), TeraBC!);
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  //calculations
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 50,
                      width: Get.width,
                      decoration: BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: rads(12),
                          border: Border.all()),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Average Depth (cm)"),
                                  Text(
                                    avgAwal!.toStringAsFixed(2),
                                    style: txt16.copyWith(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                            ),
                          ),
                          const VerticalDivider(
                            color: Colors.black,
                          ),
                          Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Qty Awal (Liter)"),
                                    Text(
                                      awalQty!.toStringAsFixed(2),
                                      style: txt16.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )),
                              ))
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomRRButton(
                      borderRadius: 12,
                      contentColor: Colors.white,
                      color: kPrimaryColor,
                      title: "Kirim",
                      width: Get.width * 0.5,
                      onTap: () async {
                        if (awal1_con.text.isEmpty ||
                            awal2_con.text.isEmpty ||
                            awal2_con.text.isEmpty) {
                          customErrorMessage(
                              "Error", "Mohon Lengkapi Semua Data!");
                          return;
                        }

                        if (awal1_img == null ||
                            awal2_img == null ||
                            awal3_img == null) {
                          customErrorMessage(
                              "Error", "Mohon Lengkapi Semua Foto!");
                        }

                        //count average
                        int count = 0;
                        String value1, value2, value3;
                        if (awal1_con.text.isNotEmpty) {
                          count = count + 1;
                        }
                        if (awal2_con.text.isNotEmpty) {
                          count = count + 1;
                        }
                        if (awal3_con.text.isNotEmpty) {
                          count = count + 1;
                        }

                        awal1_con.text.isEmpty
                            ? value1 = '0'
                            : value1 = awal1_con.text;
                        awal2_con.text.isEmpty
                            ? value2 = '0'
                            : value2 = awal2_con.text;
                        awal3_con.text.isEmpty
                            ? value3 = '0'
                            : value3 = awal3_con.text;

                        avgAwal = (double.parse(value1) +
                                double.parse(value2) +
                                double.parse(value3)) /
                            count;

                        awalQty = convertToLiter(avgAwal.toString(), TeraBC!);

                        LoaderDialog.showLoadingDialog(
                            "Uploading Sonding Data");
                        final newDataAwalShit = ReportAwalShift();
                        newDataAwalShit.awal1_depth = awal1_con.text;
                        newDataAwalShit.awal2_depth = awal2_con.text;
                        newDataAwalShit.awal3_depth = awal3_con.text;
                        newDataAwalShit.closed = false;
                        newDataAwalShit.stockTaker = appUserData!.name;
                        newDataAwalShit.awalavg_depth =
                            avgAwal!.toStringAsFixed(2);
                        newDataAwalShit.qtyAwal = awalQty!.ceilToDouble();

                        await updateDataAwalShift(
                            newDataAwalShit, formattedDate(chosenDate));

                        await ImageUploader.uploadFile(
                            awal1_file, formattedDate(chosenDate), 'awal1_img');
                        await ImageUploader.uploadFile(
                            awal2_file, formattedDate(chosenDate), 'awal2_img');
                        await ImageUploader.uploadFile(
                            awal3_file, formattedDate(chosenDate), 'awal3_img');

                        Get.back();
                        customSuccessMessage(
                            "Sukses", "Sonding Awal Shift Berhasil diupload");

                        //reset
                        // awal1_img = null;
                        // awal2_img = null;
                        // awal3_img = null;
                        // akhir1_img = null;
                        // akhir2_img = null;
                        // akhir3_img = null;
                        // awal1_con.text = "";
                        // awal2_con.text = "";
                        // awal3_con.text = "";
                        // akhir1_con.text = "";
                        // akhir2_con.text = "";
                        // akhir3_con.text = "";
                        // avgAwal = 0;
                        // avgAkhir = 0;
                        // setState(() {});
                        //getStore.erase();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    color: Colors.grey.shade500,
                    height: 40,
                    width: Get.width,
                    child: Center(
                      child: Text(
                        "Akhir Shift",
                        style: txt16.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Get.width,
                    height: Get.width,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomRecorder(
                            contentImage: akhir1_img,
                            controller: akhir1_con,
                            urutan: 1,
                            onImageTap: () async {
                              //======================================================
                              File? file = await selectImage(context);
                              if (file != null) {
                                String dir = p.dirname(file.path);
                                String newPath = p.join(dir,
                                    '${formattedDate(chosenDate)}_akhir1.jpg');
                                //print(newPath);
                                akhir1_file = await file.copy(newPath);
                                akhir1_file!.renameSync(newPath);
                                final fileString = Utility.base64string(
                                    file.readAsBytesSync());
                                await getStore.write('akhir1_img', fileString);
                                akhir1_img =
                                    MemoryImage(file.readAsBytesSync());
                                file.delete();
                                setState(() {});
                              }
                              //======================================================
                            },
                            onFieldChanged: (p0) async {
                              int count = 0;
                              final value2, value3;
                              if (p0!.isEmpty) {
                                return;
                              }
                              if (double.parse(p0) > 717) {
                                return;
                              }

                              if (akhir1_con.text.isNotEmpty) {
                                count = count + 1;
                              }
                              if (akhir2_con.text.isNotEmpty) {
                                count = count + 1;
                              }
                              if (akhir3_con.text.isNotEmpty) {
                                count = count + 1;
                              }
                              if (akhir2_con.text.isEmpty) {
                                value2 = '0';
                              } else {
                                value2 = akhir2_con.text;
                              }
                              if (akhir3_con.text.isEmpty) {
                                value3 = '0';
                              } else {
                                value3 = akhir3_con.text;
                              }
                              avgAkhir = (double.parse(p0) +
                                      double.parse(value2) +
                                      double.parse(value3)) /
                                  count;
                              akhirQty =
                                  convertToLiter(avgAkhir.toString(), TeraBC!);

                              if (awalQty == 0) {
                                awalQty = await getFirstQty(
                                    formattedDate(chosenDate));
                              } else {
                                awalQty = awalQty;
                              }
                              usageQty = (awalQty! - akhirQty!).ceilToDouble();

                              setState(() {});
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomRecorder(
                            contentImage: akhir2_img,
                            controller: akhir2_con,
                            urutan: 2,
                            onImageTap: () async {
                              //======================================================
                              File? file = await selectImage(context);
                              if (file != null) {
                                String dir = p.dirname(file.path);
                                String newPath = p.join(dir,
                                    '${formattedDate(chosenDate)}_akhir2.jpg');
                                //print(newPath);
                                akhir2_file = await file.copy(newPath);
                                akhir2_file!.renameSync(newPath);
                                final fileString = Utility.base64string(
                                    file.readAsBytesSync());
                                await getStore.write('akhir2_img', fileString);
                                akhir2_img =
                                    MemoryImage(file.readAsBytesSync());
                                file.delete();
                                setState(() {});
                              }
                              //======================================================
                            },
                            onFieldChanged: (p0) async {
                              int count = 0;
                              final value2, value3;
                              if (p0!.isEmpty) {
                                return;
                              }
                              if (double.parse(p0) > 717) {
                                return;
                              }

                              if (akhir1_con.text.isNotEmpty) {
                                count = count + 1;
                              }
                              if (akhir2_con.text.isNotEmpty) {
                                count = count + 1;
                              }
                              if (akhir3_con.text.isNotEmpty) {
                                count = count + 1;
                              }

                              if (akhir1_con.text.isEmpty) {
                                value2 = '0';
                              } else {
                                value2 = akhir1_con.text;
                              }
                              if (akhir3_con.text.isEmpty) {
                                value3 = '0';
                              } else {
                                value3 = akhir3_con.text;
                              }
                              avgAkhir = (double.parse(p0) +
                                      double.parse(value2) +
                                      double.parse(value3)) /
                                  count;
                              akhirQty =
                                  convertToLiter(avgAkhir.toString(), TeraBC!);
                              if (awalQty == 0) {
                                awalQty = await getFirstQty(
                                    formattedDate(chosenDate));
                              } else {
                                awalQty = awalQty;
                              }
                              usageQty = (awalQty! - akhirQty!).ceilToDouble();
                              setState(() {});
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomRecorder(
                            contentImage: akhir3_img,
                            controller: akhir3_con,
                            urutan: 3,
                            onImageTap: () async {
                              //======================================================
                              File? file = await selectImage(context);
                              if (file != null) {
                                String dir = p.dirname(file.path);
                                String newPath = p.join(dir,
                                    '${formattedDate(chosenDate)}_akhir3.jpg');
                                //print(newPath);
                                akhir3_file = await file.copy(newPath);
                                akhir3_file!.renameSync(newPath);
                                final fileString = Utility.base64string(
                                    file.readAsBytesSync());
                                await getStore.write('akhir3_img', fileString);
                                akhir3_img =
                                    MemoryImage(file.readAsBytesSync());
                                file.delete();
                                setState(() {});
                              }
                              //======================================================
                            },
                            onFieldChanged: (p0) async {
                              int count = 0;
                              final value2, value3;
                              if (p0!.isEmpty) {
                                return;
                              }
                              if (double.parse(p0) > 717) {
                                return;
                              }

                              if (akhir1_con.text.isNotEmpty) {
                                count = count + 1;
                              }
                              if (akhir2_con.text.isNotEmpty) {
                                count = count + 1;
                              }
                              if (akhir3_con.text.isNotEmpty) {
                                count = count + 1;
                              }

                              if (akhir1_con.text.isEmpty) {
                                value2 = '0';
                              } else {
                                value2 = akhir1_con.text;
                              }
                              if (akhir2_con.text.isEmpty) {
                                value3 = '0';
                              } else {
                                value3 = akhir2_con.text;
                              }
                              avgAkhir = (double.parse(p0) +
                                      double.parse(value2) +
                                      double.parse(value3)) /
                                  count;
                              akhirQty =
                                  convertToLiter(avgAkhir.toString(), TeraBC!);
                              if (awalQty == 0) {
                                awalQty = await getFirstQty(
                                    formattedDate(chosenDate));
                              } else {
                                awalQty = awalQty;
                              }
                              usageQty = (awalQty! - akhirQty!).ceilToDouble();
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  //calculations
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 50,
                      width: Get.width,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: rads(12),
                          border: Border.all()),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Average Depth (cm)"),
                                  Text(
                                    avgAkhir!.toStringAsFixed(2),
                                    style: txt16.copyWith(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                            ),
                          ),
                          const VerticalDivider(
                            color: Colors.black,
                          ),
                          Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Qty Akhir (Liter)"),
                                    Text(
                                      akhirQty!.toStringAsFixed(2),
                                      style: txt16.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )),
                              ))
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(
                      ' Qty Usage : $usageQty',
                      style: txt17.copyWith(fontWeight: FontWeight.bold),
                    )),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomRRButton(
                        borderRadius: 12,
                        contentColor: Colors.white,
                        color: kPrimaryColor,
                        title: "Kirim",
                        width: Get.width * 0.5,
                        onTap: () async {
                          if (akhir1_con.text.isEmpty ||
                              akhir2_con.text.isEmpty ||
                              akhir3_con.text.isEmpty) {
                            customErrorMessage(
                                "Error", "Mohon Lengkapi Semua Data!");
                            return;
                          }

                          if (akhir1_img == null ||
                              akhir2_img == null ||
                              akhir3_img == null) {
                            customErrorMessage(
                                "Error", "Mohon Lengkapi Semua Foto!");
                          }

                          LoaderDialog.showLoadingDialog(
                              "Uploading Sonding Data");
                          final newDataAkhirShift = ReportAkhirShift();
                          newDataAkhirShift.akhir1_depth = akhir1_con.text;
                          newDataAkhirShift.akhir2_depth = akhir2_con.text;
                          newDataAkhirShift.akhir3_depth = akhir3_con.text;
                          newDataAkhirShift.qtyAkhir = akhirQty!.ceilToDouble();
                          newDataAkhirShift.closed = true;
                          newDataAkhirShift.stockTaker = appUserData!.name;
                          newDataAkhirShift.akhiravg_depth =
                              avgAkhir!.toStringAsFixed(2);
                          final firstQty =
                              await getFirstQty(formattedDate(chosenDate));
                          newDataAkhirShift.usageQty =
                              (firstQty - akhirQty!).ceilToDouble();

                          await updateDataAkhirShift(
                              newDataAkhirShift, formattedDate(chosenDate));
                          await ImageUploader.uploadFile(akhir1_file,
                              formattedDate(chosenDate), 'akhir1_img');
                          await ImageUploader.uploadFile(akhir2_file,
                              formattedDate(chosenDate), 'akhir2_img');
                          await ImageUploader.uploadFile(akhir3_file,
                              formattedDate(chosenDate), 'akhir3_img');

                          googleReportSend(formattedDate(chosenDate));

                          Get.back();
                          customSuccessMessage("Sukses",
                              "Sonding Akhir Shift Berhasil diupload");

                          //reset
                          awal1_img = null;
                          awal2_img = null;
                          awal3_img = null;
                          akhir1_img = null;
                          akhir2_img = null;
                          akhir3_img = null;
                          awal1_con.text = "";
                          awal2_con.text = "";
                          awal3_con.text = "";
                          akhir1_con.text = "";
                          akhir2_con.text = "";
                          akhir3_con.text = "";
                          avgAwal = 0;
                          avgAkhir = 0;
                          setState(() {});
                          getStore.erase();
                        }),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateDataAwalShift(
      ReportAwalShift reportModel, String docName) async {
    await FirebaseFirestore.instance
        .collection('images')
        .doc(docName)
        .set(ReportAwalShift.toMap(reportModel));
  }

  Future<void> updateDataAkhirShift(
      ReportAkhirShift reportModel, String docName) async {
    await FirebaseFirestore.instance
        .collection('images')
        .doc(docName)
        .set(ReportAkhirShift.toMap(reportModel), SetOptions(merge: true));
  }

  Future<double> getFirstQty(String docName) {
    return FirebaseFirestore.instance
        .collection('images')
        .doc(docName)
        .snapshots()
        .first
        .then((value) => value.get('qty_awal'));
  }
}
