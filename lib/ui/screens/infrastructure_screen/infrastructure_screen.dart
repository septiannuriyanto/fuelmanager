import 'package:flutter/material.dart';
import 'package:fuelmanager/functions/functions.dart';
import 'package:fuelmanager/models/infrastructure_findings.dart';
import 'package:fuelmanager/models/infrastructure_items.dart';
import 'package:fuelmanager/models/user_model.dart';
import 'package:fuelmanager/ui/dialog/choice_dialog.dart';
import 'package:fuelmanager/ui/dialog/loader_dialog.dart';
import 'package:fuelmanager/ui/screens/infrastructure_screen/infras_finding_dialog.dart';
import 'package:fuelmanager/ui/screens/infrastructure_screen/infras_followup.dart';
import 'package:fuelmanager/ui/screens/loading_screen.dart';
import 'package:fuelmanager/utils/styler.dart';
import 'package:fuelmanager/widgets/custom_button.dart';
import 'package:fuelmanager/widgets/custom_datepicker.dart';
import 'package:fuelmanager/widgets/custom_snackbar.dart';
import 'package:fuelmanager/widgets/custom_textfield.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:gsheets/gsheets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../functions/secrets.dart';

class InfrastructureScreen extends StatefulWidget {
  InfrastructureScreen({super.key});

  @override
  State<InfrastructureScreen> createState() => _InfrastructureScreenState();
}

class _InfrastructureScreenState extends State<InfrastructureScreen> {
  DateTime? dt;

  List<InfrastructureFindings> infrasFindings = [];
  List<Infrastructures> infrastructures = [];
  List<InfrastructureItem> infrastructureItems = [];

  int infrasIndex = 0;

  final periode_c = TextEditingController();
  final unit_c = TextEditingController();
  bool filterSubstandard = false;
  bool showAll = true;
  AppUserData? appUserData;
  SharedPreferences? prefs;

  bool itemsLoaded = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCredentials();
    loadAllData();
  }

  getCredentials() async {
    prefs = await SharedPreferences.getInstance();
    appUserData = await AppUserData.fromSharedPreferences(prefs!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Visibility(
      visible: itemsLoaded,
      replacement: LoadingScreen(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("Inspeksi Infrastructure"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomDatePicker(
                  chosenDate: DateTime.now(), callbackFunction: () {}),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTextField(
                        textEditingController: periode_c,
                        hint: "Periode",
                        readonly: true,
                        showSuffixIcon: true,
                        prefIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () async {
                            List<String> period = ["P1", "P2"];
                            final choice = await showDialog(
                                context: context,
                                builder: (context) {
                                  return ChoiceDialog(dataGroup: period);
                                });
                            if (choice != null) periode_c.text = choice;
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: CustomTextField(
                      textEditingController: unit_c,
                      readonly: true,
                      hint: "Pilih Unit",
                      prefIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () async {
                          final choice = await showDialog(
                              context: context,
                              builder: (context) {
                                return ChoiceDialog(
                                    dataGroup: infrastructures.map((e) {
                                  return e.unit;
                                }).toList());
                              });
                          if (choice != null) {
                            unit_c.text = choice;
                            infrasIndex = infrastructures
                                .indexWhere((val) => val.unit == choice);
                            print(infrastructures[infrasIndex]
                                .infrasFindings
                                .length);
                            setState(() {});
                          }
                        },
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          unit_c.clear();
                          setState(() {});
                        },
                        icon: Icon(Icons.clear_rounded),
                        iconSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Checkbox(
                            activeColor: Colors.green,
                            value: showAll,
                            onChanged: (val) {
                              showAll = val!;
                              setState(() {});
                            }),
                        Text('Show All ?'),
                      ],
                    ),
                    Column(
                      children: [
                        Checkbox(
                            activeColor: Colors.green,
                            value: filterSubstandard,
                            onChanged: (val) {
                              filterSubstandard = val!;
                              setState(() {});
                            }),
                        Text('Filter substandard item ?'),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Visibility(
                visible: unit_c.text.isNotEmpty,
                child: infrastructures.isEmpty
                    ? Container()
                    : GroupedListView(
                        elements: unit_c.text.isEmpty
                            ? infrastructures[infrasIndex].infrasItem
                            : infrastructures[infrasIndex]
                                .infrasItem
                                .where((element) {
                                if (filterSubstandard) {
                                  return element.classItem.substring(0, 2) ==
                                          getClassType(unit_c.text) &&
                                      element.actual == 0;
                                } else
                                  return element.classItem.substring(0, 2) ==
                                      getClassType(unit_c.text);
                              }).toList(),

                        //
                        //     ? infrastructureItems
                        //     : infrastructureItems.where((element) {
                        //         if (filterSubstandard) {
                        //           return element.classItem.substring(0, 2) ==
                        //                   getClassType(unit_c.text) &&
                        //               element.actual == 0;
                        //         } else
                        //           return element.classItem.substring(0, 2) ==
                        //               getClassType(unit_c.text);
                        //       }).toList(),

                        ///
                        groupBy: (infrastructures) => infrastructures.component,
                        itemComparator: (element1, element2) => element1.id,
                        groupHeaderBuilder: (element) => Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text('${element.component}'),
                            ),
                          ),
                          width: size.width,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.2),
                          ),
                        ),
                        itemBuilder: (context, element) {
                          return Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: rads(12),
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .primaryColor)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(element.itemCheck),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                width: 50,
                                height: 50,
                                decoration: barr(context, 12),
                                child: Center(
                                    child: Text(element.actual.toString())),
                              )),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        color: element.actual == 0
                                            ? Colors.redAccent.shade200
                                            : Colors.greenAccent.shade200,
                                        borderRadius: rads(12),
                                        border: Border.all(
                                            color: element.actual == 0
                                                ? Colors.redAccent.shade700
                                                : Colors.greenAccent.shade700)),
                                    child: Checkbox(
                                        activeColor:
                                            Colors.greenAccent.shade700,
                                        value: element.actual == element.weight,
                                        onChanged: (val) async {
                                          if (val == false) {
                                            final data = await Get.to(
                                                () => InfrasFindingDialog(
                                                      unit: unit_c.text,
                                                      id: element.id.toString(),
                                                    ));

                                            if (data != null) {
                                              element.actual = 0;
                                              infrasFindings.clear();
                                              infrastructures.clear();
                                              infrastructureItems.clear();
                                              loadAllData();
                                            }
                                          } else {
                                            final finding =
                                                infrastructures[infrasIndex]
                                                    .infrasFindings
                                                    .where((fin) =>
                                                        fin.key ==
                                                        '${fin.unit}${fin.id}')
                                                    .first;
                                            final data = await Get.to(
                                                () => InfrasFollowup(
                                                      infrasFindings:
                                                          infrasFindings,
                                                      findingKey: finding,
                                                    ));

                                            if (data != null) {
                                              element.actual = element.weight;
                                            }
                                          }
                                          // val == true
                                          //     ? element.actual = element.weight
                                          //     : element.actual = 0;
                                          setState(() {});
                                        }),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                        order: GroupedListOrder.ASC,
                      ),
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomRRButton(
                    color: Theme.of(context).primaryColor,
                    contentColor: Colors.white,
                    borderRadius: 12,
                    title: "Send Report",
                    width: size.width * 0.5,
                    onTap: () async {
                      final conf = await sendForm("Kirim report ?");
                      if (conf != null) {
                        final val = validateInfraReport();
                        if (val == "ok") {
                          print("Sending data");
                          LoaderDialog.showLoadingDialog("Uploading data...");
                          await sendInfraReport(infrastructures);
                          Get.back();
                          customSuccessMessage(
                              "Success", "Success sending data");
                        } else {
                          customErrorMessage("Error", val);
                        }
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> downloadSheetContents(String sheetName) async {
    final gsheets = GSheets(credentials);
    final ss = await gsheets.spreadsheet(confisSheet);
    var sheet = ss.worksheetByTitle(sheetName);

    final sheetData = await sheet!.values
        .allRows(fromRow: 2, fromColumn: 1); //.allRows(fromRow: 2);

    return sheetData;
  }

  void loadAllData() async {
    itemsLoaded = false;
    //download population data
    List<List<dynamic>> datas = await downloadSheetContents('Population');
    if (datas.isNotEmpty) {
      for (var item in datas) {
        infrastructures.add(Infrastructures.fromJSON(item));
      }
    }

    //download elements data
    datas = await downloadSheetContents('Elements');
    if (datas.isNotEmpty) {
      for (var item in datas) {
        infrastructureItems.add(InfrastructureItem.fromJson(item));
      }
    }

    //download findings data
    datas = await downloadSheetContents('Findings');
    if (datas.isNotEmpty) {
      for (var item in datas) {
        if (item[8] == "OPEN")
          infrasFindings.add(InfrastructureFindings.fromJson(item));
      }
    }

    await infrasCreation();
  }

  infrasCreation() async {
    //build infrastructure items
    for (var infra in infrastructures) {
      for (var item in infrastructureItems) {
        if (infra.storageType == item.classItem) {
          infra.infrasItem.add(InfrastructureItem(
            id: item.id,
            key: item.key,
            classItem: item.classItem,
            index: item.index,
            component: item.component,
            itemCheck: item.itemCheck,
            weight: item.weight,
            actual: item.actual,
          ));
        }
      }

      print('++++${infrasFindings.length}+++++');

      //build infrastructure findings
      for (var finding in infrasFindings) {
        print('---${finding.key}---');
        if (infra.unit == finding.unit) {
          // print('${infra.unit}${finding.id}');
          infra.infrasFindings.add(finding);
        }
      }
    }

    //reconcile actual achievement vs finding
    //if finding is present then actual achievement = 0

    ///////////////////////////////////////////////////////////////
    for (var infra in infrastructures) {
      if (infra.infrasFindings.isNotEmpty) {
        for (var finding in infra.infrasFindings) {
          var index = infra.infrasItem
              .indexWhere((element) => element.id == finding.id);
          infra.infrasItem[index].actual = 0;
        }
      }
    }

    ///////////////////////////////////////////////////////////////

    print("Done Loading");
    itemsLoaded = true;
    setState(() {});
  }

  Future sendInfraReport(List<Infrastructures> infrastructures) async {
    //Submit data to GoogleSheet
    final gsheets = GSheets(credentials);
    final ss = await gsheets.spreadsheet(confisSheet);
    var sheet = ss.worksheetByTitle('LOG_TRANS');
    final dst = await sheet!.values.allRows(fromRow: 1);
    int lastRow = dst.length;

    List<List<dynamic>> data = [];

    for (var infras in infrastructures) {
      for (var infrasItem in infras.infrasItem) {
        data.add(InfrastructureItem.toGooglesheet(infrasItem, DateTime.now(),
            periode_c.text, infras.unit, appUserData!.name!));
      }
    }

    await sheet.values.insertRows(lastRow + 1, data);
  }

  String validateInfraReport() {
    if (periode_c.text.isEmpty) return "Mohon isi periode";
    if (unit_c.text.isEmpty) return "Mohon isi unit";
    return "ok";
  }
}

String getClassType(String text) {
  if (text.substring(0, 2) == "FT") {
    return "FT";
  } else if (text.substring(0, 2) == "MT") {
    return "PS";
  } else if (text.substring(0, 2) == "OS") {
    return "OS";
  } else {
    return "NA";
  }
}
