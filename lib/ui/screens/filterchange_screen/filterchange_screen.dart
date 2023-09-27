import 'package:flutter/material.dart';
import 'package:fuelmanager/constant/constant.dart';
import 'package:fuelmanager/functions/functions.dart';
import 'package:fuelmanager/functions/secrets.dart';
import 'package:fuelmanager/models/filterchange_model.dart';
import 'package:fuelmanager/models/user_model.dart';
import 'package:fuelmanager/ui/dialog/choice_dialog.dart';
import 'package:fuelmanager/ui/dialog/loader_dialog.dart';
import 'package:fuelmanager/ui/screens/loading_screen.dart';
import 'package:fuelmanager/utils/datetime_handler.dart';
import 'package:fuelmanager/utils/formatter.dart';
import 'package:fuelmanager/widgets/custom_appbar.dart';
import 'package:fuelmanager/widgets/custom_button.dart';
import 'package:fuelmanager/widgets/custom_snackbar.dart';
import 'package:fuelmanager/widgets/custom_textfield.dart';
import 'package:get/get.dart';
import 'package:gsheets/gsheets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constant/theme.dart';

class FilterChangeScreen extends StatefulWidget {
  FilterChangeScreen({super.key});

  @override
  State<FilterChangeScreen> createState() => _FilterChangeScreenState();
}

class _FilterChangeScreenState extends State<FilterChangeScreen> {
  bool isnewFlowmeter = false;
  final unit_c = TextEditingController();
  final totaliser_c = TextEditingController();
  final reason_c = TextEditingController();
  final remark_c = TextEditingController();
  final pic_c = TextEditingController();
  final oldTotaliser_c = TextEditingController();

  List<FilterPopulation>? filterPopulation;
  int? indexChosen;
  double fuelpass = 0;
  double fuelpassold = 0;
  double fuelpassTotal = 0;
  double filterCostActual = 0;
  SharedPreferences? prefs;
  AppUserData? appUserData;

  @override
  void initState() {
    super.initState();
    loadFilterPopulation();
    getCredentials();
  }

  getCredentials() async {
    prefs = await SharedPreferences.getInstance();
    appUserData = await AppUserData.fromSharedPreferences(prefs!);
    Future.delayed(const Duration(seconds: 2)).then((value) {
      setState(() {
        pic_c.text = appUserData!.name!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      replacement: LoadingScreen(),
      visible: filterPopulation != null,
      child: Scaffold(
        body: Column(
          children: [
            CustomAppBar(title: "Record Penggantian Filter"),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  CustomTextField(
                    textEditingController: pic_c,
                    hint: "Pelapor",
                    readonly: true,
                    suffixIcon: SizedBox(),
                    prefIcon: Icon(Icons.verified_user),
                  ),
                  CustomTextField(
                    readonly: true,
                    textEditingController: unit_c,
                    hint: "Unit",
                    prefIcon: IconButton(
                      onPressed: () async {
                        final res = await Get.dialog(
                          ChoiceDialog(
                            dataGroup: filterPopulation!
                                .map((e) => e.location)
                                .toList(),
                            choiceReturnType: ChoiceReturnType.returnIndex,
                          ),
                        );
                        if (res != null) {
                          indexChosen = res;
                          unit_c.text = filterPopulation![res].location;
                          setState(() {});
                        }
                      },
                      icon: Icon(Icons.search),
                    ),
                  ),
                  CustomTextField(
                      textEditingController: reason_c,
                      readonly: true,
                      hint: "Alasan Penggantian",
                      prefIcon: IconButton(
                        onPressed: () async {
                          final res = await Get.dialog(ChoiceDialog(
                              dataGroup: reasonReplace.keys.toList()));
                          if (res != null) {
                            reason_c.text = res;
                          }
                        },
                        icon: Icon(Icons.search),
                      )),
                  CustomTextField(
                    textEditingController: remark_c,
                    hint: "Keterangan",
                  ),
                  CustomTextField(
                    textEditingController: totaliser_c,
                    hint: "Totaliser Flowmeter",
                    textInputType: TextInputType.number,
                    inputFormatter: [numberOnly],
                    onFieldChanged: (p0) {
                      setState(() {
                        if (isnewFlowmeter) {
                          if (p0!.isEmpty || oldTotaliser_c.text.isEmpty) {
                            filterCostActual = 0;
                            fuelpass = 0;
                            fuelpassTotal = 0;
                            return;
                          } else {
                            fuelpass = double.parse(p0);
                            fuelpassold = double.parse(oldTotaliser_c.text) -
                                filterPopulation![indexChosen!].totaliser;
                            fuelpassTotal = fuelpass + fuelpassold;
                            filterCostActual =
                                filterPopulation![indexChosen!].price /
                                    fuelpassTotal;
                          }
                        } else {
                          if (p0!.isEmpty) {
                            filterCostActual = 0;
                            fuelpass = 0;
                            fuelpassTotal = 0;
                            return;
                          } else {
                            fuelpass = double.parse(p0) -
                                filterPopulation![indexChosen!].totaliser;
                            fuelpassTotal = fuelpass;
                            filterCostActual =
                                filterPopulation![indexChosen!].price /
                                    fuelpassTotal;
                          }
                        }
                      });
                    },
                  ),
                  Visibility(
                    visible: isnewFlowmeter,
                    child: CustomTextField(
                      textEditingController: oldTotaliser_c,
                      hint: "Masukkan Totaliser Flowmeter Lama",
                      textInputType: TextInputType.number,
                      inputFormatter: [numberOnly],
                      onFieldChanged: (p0) {
                        if (p0!.isEmpty || totaliser_c.text.isEmpty) {
                          fuelpass = 0;
                          fuelpassold = 0;
                          return;
                        } else {
                          fuelpassold = double.parse(p0) -
                              filterPopulation![indexChosen!].totaliser;
                          fuelpass = double.parse(totaliser_c.text);
                          fuelpassTotal = fuelpass + fuelpassold;
                          filterCostActual =
                              filterPopulation![indexChosen!].price /
                                  fuelpassTotal;
                        }
                        setState(() {});
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Flowmeter baru ?"),
                      Checkbox.adaptive(
                          value: isnewFlowmeter,
                          onChanged: (val) {
                            isnewFlowmeter = val!;
                            if (isnewFlowmeter == true) {
                              oldTotaliser_c.clear();
                              fuelpassold = 0;
                              if (oldTotaliser_c.text.isEmpty ||
                                  totaliser_c.text.isEmpty) {
                                filterCostActual = 0;
                                fuelpass = 0;
                                fuelpassTotal = 0;
                                fuelpassold = 0;
                              } else {
                                fuelpassold =
                                    double.parse(oldTotaliser_c.text) -
                                        filterPopulation![indexChosen!]
                                            .totaliser;
                                fuelpass = double.parse(totaliser_c.text);
                                fuelpassTotal = fuelpass + fuelpassold;
                                filterCostActual =
                                    filterPopulation![indexChosen!].price /
                                        fuelpassTotal;
                              }
                            } else {
                              if (oldTotaliser_c.text.isEmpty ||
                                  totaliser_c.text.isEmpty) {
                                filterCostActual = 0;
                                fuelpass = 0;
                                fuelpassTotal = 0;
                                fuelpassold = 0;
                              } else {
                                fuelpassold = 0;
                                fuelpass = double.parse(totaliser_c.text) -
                                    filterPopulation![indexChosen!].totaliser;
                                fuelpassTotal = fuelpass + fuelpassold;
                                filterCostActual =
                                    filterPopulation![indexChosen!].price /
                                        fuelpassTotal;
                              }
                            }
                            setState(() {});
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Visibility(
                    visible: indexChosen != null,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Last Totaliser : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                Expanded(
                                    child: indexChosen == null
                                        ? Text("0")
                                        : Text(filterPopulation![indexChosen!]
                                            .totaliser
                                            .toStringAsFixed(0))),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Totaliser Now : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                Expanded(
                                    child: totaliser_c.text.isEmpty
                                        ? Text("0")
                                        : Text(totaliser_c.text)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Fuel Pass : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                Expanded(
                                    child: Text(fuelpass.toStringAsFixed(0))),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: isnewFlowmeter,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        "Fuel Pass Old Flowmeter : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  Expanded(
                                      child:
                                          Text(fuelpassold.toStringAsFixed(0))),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: isnewFlowmeter,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        "Fuel Pass Total : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  Expanded(
                                      child: Text(
                                          fuelpassTotal.toStringAsFixed(0))),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Filter Cost Actual (Rp/Liter): ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                Expanded(
                                    child: Text(
                                        filterCostActual.toStringAsFixed(5))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  CustomRRButton(
                      title: "Kirim",
                      width: 40,
                      borderRadius: 12,
                      color: kPrimaryColor,
                      contentColor: Colors.white,
                      onTap: () async {
                        final res = await sendForm(null);
                        if (res == true) {
                          final validate = validateInput();
                          if (validate != "ok") {
                            customErrorMessage("Invalid", validate);
                            return;
                          }
                          await submitData();
                          Get.back();
                          customSuccessMessage(
                              "Success", "Sukses menambahkan record filter");
                        }
                      })
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  void loadFilterPopulation() async {
    dynamic conf = await downloadMasterConfig();
    filterPopulation = await getFilterPopulation(conf);
    setState(() {});
  }

  Future<List<FilterPopulation>> getFilterPopulation(
      List<List<dynamic>> tera) async {
    List<FilterPopulation> filterPops = [];
    int startColNum = 0;
    for (int i = 0; i < tera.length; i++) {
      if (tera[i].toString().trim().isNotEmpty) {
        filterPops.add(FilterPopulation(
          whCode: tera[i][startColNum],
          location: tera[i][startColNum + 1],
          sc: tera[i][startColNum + 2],
          pn: tera[i][startColNum + 3],
          mnemonic: tera[i][startColNum + 4],
          price: double.parse(
            tera[i][startColNum + 5].toString(),
          ),
          totaliser: double.parse(
            tera[i][startColNum + 6].toString(),
          ),
        ));
      }
    }
    return filterPops;
  }

  Future<dynamic> downloadMasterConfig() async {
    final gsheets = GSheets(credentials);
    final ss = await gsheets.spreadsheet(fuelManagerSheet);
    var sheet = ss.worksheetByTitle('Master data');

    final tera = await sheet!.values
        .allRows(fromRow: 2, fromColumn: 8); //.allRows(fromRow: 2);

    return tera;
  }

  String validateInput() {
    String msg = "ok";
    if (unit_c.text.isEmpty) return "Mohon isi Unit";
    if (reason_c.text.isEmpty) return "Mohon isi Reason";
    if (pic_c.text.isEmpty) return "Mohon isi Nama Pelapor";
    if (totaliser_c.text.isEmpty) return "Mohon isi Totaliser";
    if (isnewFlowmeter == true && oldTotaliser_c.text.isEmpty)
      return "Mohon isi Totaliser Flowmeter Lama";
    if (fuelpassTotal < 0) return "Cek Kembali Angka Totaliser";

    return msg;
  }

  Future<void> submitData() async {
    LoaderDialog.showLoadingDialog("Submitting Data");
    FilterChange filterChange = FilterChange(
        period: formattedPeriod,
        tgl: convertToIndShortDate(formattedToday),
        qty: 1,
        filterPopulation: FilterPopulation(
          whCode: filterPopulation![indexChosen!].whCode,
          location: filterPopulation![indexChosen!].location,
          sc: filterPopulation![indexChosen!].sc,
          pn: filterPopulation![indexChosen!].whCode,
          mnemonic: filterPopulation![indexChosen!].mnemonic,
          price: filterPopulation![indexChosen!].price,
          totaliser: filterPopulation![indexChosen!].totaliser,
        ),
        reason: reason_c.text,
        remark: remark_c.text,
        totaliser: double.parse(totaliser_c.text),
        fuelPass: fuelpassTotal,
        filterCostActual: filterCostActual,
        pelapor: appUserData!.name!);

    final gsheets = GSheets(credentials);
    final ss = await gsheets.spreadsheet(fuelManagerSheet);
    var sheet = ss.worksheetByTitle('Filter Usage');
    final dst = await sheet!.values.allRows(fromRow: 1);
    int lastRow = dst.length;
    await sheet.values
        .insertRow(lastRow + 1, FilterChange.toGoogleSheet(filterChange));

    //Update Latest Totaliser
    final configSheet = ss.worksheetByTitle('Master data');
    await configSheet!.values
        .insertValue(totaliser_c.text, column: 14, row: indexChosen! + 2);
    filterPopulation = null;

    Get.back();
  }
}
