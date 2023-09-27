import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fuelmanager/constant/theme.dart';
import 'package:fuelmanager/models/fuel_request_model.dart';
import 'package:fuelmanager/models/user_model.dart';
import 'package:fuelmanager/services/firebase_db.dart';
import 'package:fuelmanager/services/image_uploader.dart';
import 'package:fuelmanager/ui/dialog/sign_dialog.dart';
import 'package:fuelmanager/widgets/custom_appbar.dart';
import 'package:fuelmanager/widgets/custom_button.dart';
import 'package:fuelmanager/widgets/custom_datepicker.dart';
import 'package:fuelmanager/widgets/custom_loading.dart';
import 'package:fuelmanager/widgets/custom_snackbar.dart';
import 'package:fuelmanager/widgets/custom_textfield.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;
import '../../../utils/datetime_handler.dart';
import '../../../utils/image_handler.dart';
import '../../../widgets/photo_container/photo_container.dart';
import '../../dialog/loader_dialog.dart';

class ExternalRequestScreen extends StatefulWidget {
  AppUserData appUserData;

  ExternalRequestScreen({Key? key, required this.appUserData})
      : super(key: key);
  @override
  State<ExternalRequestScreen> createState() => _ExternalRequestScreenState();
}

class _ExternalRequestScreenState extends State<ExternalRequestScreen> {
  DateTime chosenDate = DateTime.now();
  final company_con = TextEditingController();
  final codenumber_con = TextEditingController();
  final loc_con = TextEditingController();
  final requestor_con = TextEditingController();
  final receiver_con = TextEditingController();
  final qty_con = TextEditingController();
  final fuelman_con = TextEditingController();
  final fueltruck_con = TextEditingController();

  ImageProvider? evidenceImg;
  File? evidenceFile;
  bool isCreated = false;
  String? signature;
  SharedPreferences? prefs;
  AppUserData? userData;
  bool requestMode = false;
  String? companyCode, requestNumber, requestCodeCheck;
  int? requestCount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chosenDate = DateTime.now();
    asyncProcedures();
    company_con.text =
        TextEditingController().text = widget.appUserData.company!;
    requestor_con.text =
        TextEditingController().text = widget.appUserData.name!;
  }

  asyncProcedures() async {
    companyCode = await FirebaseDB.fetchCompanyID(widget.appUserData.company!);
    requestCodeCheck = '$companyCode${formattedDate(chosenDate)}';
    requestCount = await FirebaseDB.fetchRequestCount(requestCodeCheck!);
    requestNumber = '$requestCodeCheck${requestCount! + 1}';
  }

  callbackFunction(dateReturn) async {
    setState(() {
      chosenDate = dateReturn;
    });
  }

  @override
  void dispose() {
    super.dispose();
    company_con.dispose();
    codenumber_con.dispose();
    loc_con.dispose();
    requestor_con.dispose();
    receiver_con.dispose();
    qty_con.dispose();
    fuelman_con.dispose();
    fueltruck_con.dispose();
  }

  Future<int> getRequestCount() async {
    return await FirebaseDB.fetchRequestCount(requestCodeCheck!);
  }

  Future<String> getReportnumber() async {
    int reqCount = await FirebaseDB.fetchRequestCount(requestCodeCheck!);
    return '$requestCodeCheck${reqCount + 1}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: "Request Fuel External Pama"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomRRButton(
                borderRadius: 12,
                color: kSecondaryColor,
                title:
                    requestMode == false ? "Request Fuel" : "Request History",
                width: Get.width * 0.4,
                onTap: () {
                  setState(() {
                    requestMode = !requestMode;
                  });
                }),
          ),
          requestMode == false
              ? Expanded(
                  child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.white,
                  ),
                ))
              : Expanded(
                  child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Column(
                      children: [
                        CustomDatePicker(
                            chosenDate: chosenDate,
                            callbackFunction: callbackFunction),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text(
                            "Form Permohonan Pengisian Fuel PT. Pama",
                            style: defaultBold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          enabled: false,
                          textEditingController: company_con,
                          hint: "Perusahaan",
                        ),
                        CustomTextField(
                          enabled: false,
                          textEditingController: requestor_con,
                          hint: "Nama Pemohon",
                        ),
                        CustomTextField(
                          textEditingController: codenumber_con,
                          hint: "Nomor Unit Request",
                        ),
                        CustomTextField(
                          textEditingController: loc_con,
                          hint: "Detail Lokasi",
                        ),
                        CustomTextField(
                          textEditingController: qty_con,
                          hint: "Qty (liter)",
                        ),
                        CustomTextField(
                          textEditingController: fuelman_con,
                          hint: "Nama Fuelman",
                        ),
                        CustomTextField(
                          textEditingController: fueltruck_con,
                          hint: "FT Number",
                        ),
                        CustomTextField(
                          textEditingController: receiver_con,
                          hint: "Penerima Fuel",
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: evidenceImg != null
                              ? PhotoContainer(
                                  imageProvider: evidenceImg!,
                                  height: Get.width * 0.5)
                              : GestureDetector(
                                  child: Container(
                                    width: Get.width * 0.5,
                                    height: Get.width * 0.5,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        color: kSecondaryColor),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_a_photo,
                                          color: kPrimaryColor,
                                          size: Get.width * 0.15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Bukti Pengisian",
                                            style: defaultBold.copyWith(
                                                color: kPrimaryColor),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () async {
                                    final repNum = await getReportnumber();
                                    //======================================================
                                    requestNumber =
                                        '$companyCode${formattedDate(chosenDate)}';
                                    File? file = await selectImage(context);
                                    if (file != null) {
                                      String dir = p.dirname(file.path);
                                      String newPath =
                                          p.join(dir, '${repNum}_evd');
                                      print(newPath);
                                      evidenceFile = await file.copy(newPath);
                                      evidenceFile!.renameSync(newPath);
                                      evidenceImg =
                                          MemoryImage(file.readAsBytesSync());
                                      file.delete();
                                      setState(() {});
                                    }
                                    //======================================================
                                  },
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(kDefaultPadding),
                          child: CustomRRButton(
                              enabled: !isCreated,
                              outlineColor: kPrimaryColor,
                              borderRadius: 12,
                              color: kPrimaryColor,
                              contentColor: kSecondaryColor,
                              title: "Buat Permintaan",
                              width: Get.width * 0.4,
                              onTap: () async {
                                //on success
                                await Get.defaultDialog(
                                  cancelTextColor: kPrimaryColor,
                                  confirmTextColor: kPrimaryColor,
                                  backgroundColor: kThirdColor,
                                  buttonColor: kSecondaryColor,
                                  title: "Process?",
                                  middleText:
                                      "Dengan menandatangani transaksi ini, anda menyatakan bahwa transaksi berikut valid dan tidak memerlukan tanda tangan secara fisik.\nSerta laporan yang di-generate oleh aplikasi ini dapat digunakan sebagai tanda bukti transaksi yang sah",
                                  onConfirm: () async {
                                    Get.back();
                                    final sign = await Get.dialog(SignDialog(
                                        nrp: widget.appUserData.ID!,
                                        yesCommand: "Setuju",
                                        name: widget.appUserData.name!,
                                        message:
                                            "Tanda tangan anda akan diubah ke biometric code dan dinyatakan sebagai otentikasi yang sah atas dokumen berikut"));
                                    if (sign == null) {
                                      return;
                                    }
                                    final repNum = await getReportnumber();
                                    // print(repNum);
                                    // return;

                                    //------------------------------------------
                                    //create object
                                    FuelRequestModel newRequest =
                                        FuelRequestModel(
                                      requestor: requestor_con.text,
                                      codeNumber: codenumber_con.text,
                                      company: widget.appUserData.company,
                                      date_delivered: DateTime.now(),
                                      isDelivered: true,
                                      evidence_url: 'none',
                                      fuelman: fuelman_con.text,
                                      qty: int.parse(qty_con.text),
                                      receiver: receiver_con.text,
                                      ft_name: fueltruck_con.text,
                                    );
                                    //Upload Data-------------------------------
                                    LoaderDialog.showLoadingDialog(
                                        "Submitting Request");
                                    String result =
                                        await FirebaseDB.insertExternalUsage(
                                            repNum, newRequest);
                                    Get.back();
                                    Get.back();

                                    if (result != 'success') {
                                      customErrorMessage(
                                          "Error Add Ext Usage", result);
                                      return;
                                    }

                                    //Upload Image & update URL-----------------
                                    await ImageUploader.uploadEvidence(
                                        evidenceFile,
                                        companyCode!,
                                        repNum,
                                        'evidence_url');

                                    //Clear all components----------------------
                                    customSuccessMessage("Sukses",
                                        "Sukses Mengirim Request Fuel");
                                    setState(() {
                                      isCreated = true;
                                      Get.back();
                                      // fueltruck_con.clear();
                                      // codenumber_con.clear();
                                      // loc_con.clear();
                                      // receiver_con.clear();
                                      // qty_con.clear();
                                      // fuelman_con.clear();
                                      // evidenceImg = null;
                                    });
                                  },
                                  onCancel: () {},
                                );
                              }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Visibility(
                          visible: isCreated,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Report Anda Telah Dibuat, Klik Tombol Di Bawah Untuk Download / Share",
                                style: TextStyle(color: kPrimaryColor),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.download,
                                        color: kPrimaryColor,
                                        size: 30,
                                      )),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.share,
                                        color: kPrimaryColor,
                                        size: 30,
                                      )),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ))
        ],
      ),
    );
  }
}

class UserDataGet {
  static SharedPreferences? _prefs;
  static const _keyUsername = 'username';
  static const _keyCompany = 'company';

  static Future init() async => _prefs = await SharedPreferences.getInstance();
  static Future getUsername() async => _prefs!.getString(_keyUsername);
  static Future getCompany() async => _prefs!.getString(_keyUsername);
}
