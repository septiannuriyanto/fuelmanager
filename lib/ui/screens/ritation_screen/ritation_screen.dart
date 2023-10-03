import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fuelmanager/constant/constant.dart';
import 'package:fuelmanager/functions/functions.dart';
import 'package:fuelmanager/functions/secrets.dart';
import 'package:fuelmanager/models/tera_ft.dart';
import 'package:fuelmanager/models/user_model.dart';
import 'package:fuelmanager/ui/dialog/choice_dialog.dart';
import 'package:fuelmanager/ui/dialog/loader_dialog.dart';
import 'package:fuelmanager/ui/screens/loading_screen.dart';
import 'package:fuelmanager/ui/screens/ritation_screen/tera_helper.dart';
import 'package:fuelmanager/utils/datetime_handler.dart';
import 'package:fuelmanager/utils/styler.dart';
import 'package:fuelmanager/widgets/custom_snackbar.dart';
import 'package:fuelmanager/widgets/custom_textfield.dart';
import 'package:fuelmanager/widgets/sequence_circle.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'global_var.dart' as global;

class RitationScreen extends StatefulWidget {
  RitationScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<RitationScreen> createState() => _RitationScreenState();
}

class _RitationScreenState extends State<RitationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Tera> teraFT = [];
  String pickedFT = "Pilih FT";
  late Size size;
  String _date = DateFormat("dd").format(DateTime.now());
  String DO_date = formattedTodayTwoStringRev;
  final sondingDepanAwal_c = TextEditingController();
  final sondingBelakangAwal_c = TextEditingController();
  final sondingDepanAkhir_c = TextEditingController();
  final sondingBelakangAkhir_c = TextEditingController();
  final fuelman_c = TextEditingController();
  final opt_c = TextEditingController();
  final qty_fm_c = TextEditingController();
  final qty_additive_c = TextEditingController();
  String lookupKey = "",
      sondingDepanAwal = "",
      sondingDepanAkhir = "",
      sondingBelakangAwal = "",
      sondingBelakangAkhir = "",
      sondingAvgAwal = "",
      sondingAvgAkhir = "";
  String qtyDepanAwal = "",
      qtyDepanAkhir = "",
      qtyByTera = "",
      qtyFM = "",
      qtyAdditive = "",
      fuelman = "",
      qtyBelakangAwal = "",
      qtyBelakangAkhir = "",
      qtyAvgAwal = "",
      qtyAvgAkhir = "";

  String shift = "1";

  bool finishedLoading = false;

  int urutan = 0;

  AppUserData? appUserData;
  SharedPreferences? prefs;
  List<String> FuelmanList = [];
  List<String> OperatorList = [];
  Map<String, String> FTMap = {};

  @override
  void initState() {
    super.initState();
    asyncProcedures();
  }

  @override
  void dispose() {
    super.dispose();
    sondingDepanAwal_c.dispose();
    sondingBelakangAwal_c.dispose();
    sondingDepanAkhir_c.dispose();
    sondingBelakangAkhir_c.dispose();
    opt_c.dispose();
    fuelman_c.dispose();
    qty_fm_c.dispose();
    qty_additive_c.dispose();
  }

  void asyncProcedures() async {
    prefs = await SharedPreferences.getInstance();
    teraFT = await checkIfTeraAvailable('tera_ft', 'Tera FT Pama', 0, 8);
    appUserData = AppUserData.fromSharedPreferences(prefs!);

    if (appUserData!.role == 'fuelman') {
      fuelman_c.text = appUserData!.name!;
    }
    urutan = await getQueueNumber();
    await getMasterData();
    finishedLoading = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Visibility(
      visible: finishedLoading,
      replacement: LoadingScreen(),
      child: SafeArea(
        child: Scaffold(
            // backgroundColor: Colors.transparent,
            body: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          child: Column(
            children: [
              Expanded(
                flex: 0,
                child: Container(
                  width: double.maxFinite,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: const Center(
                    child: Text(
                      'Tambahkan Ritasi Fuel Truck',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                const Icon(
                                  Icons.calendar_month,
                                  color: Colors.grey,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(_date)
                              ],
                            ),
                            Column(
                              children: [
                                shift == "1"
                                    ? const Icon(
                                        Icons.sunny,
                                        color: Colors.orangeAccent,
                                      )
                                    : Icon(
                                        Icons.nights_stay,
                                        color: Colors.grey.shade800,
                                      ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(shift),
                              ],
                            ),
                            Column(
                              children: [
                                const Icon(
                                  Icons.flag,
                                  color: Colors.grey,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(urutan.toString()),
                              ],
                            )
                          ],
                        ),
                        //==================================================================
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Center(
                              child: pickedFT == "Pilih FT"
                                  ? const Text(
                                      "Pilih FT untuk generate nomor DO",
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  : Text(
                                      'DO : $DO_date${shift}${urutan}$pickedFT  ',
                                      style:
                                          const TextStyle(color: Colors.grey))),
                        ),
                        //==================================================================
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                height: 40,
                                width: size.width / 2,
                                decoration: BoxDecoration(
                                    color: Colors.amber.shade200,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(33))),
                                child: Center(
                                  child: DropdownButton<String>(
                                      underline: SizedBox(),
                                      hint: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Center(
                                              child: Text(
                                            pickedFT,
                                          )),
                                        ),
                                      ),
                                      items: FTMap.keys.map((String val) {
                                        return DropdownMenuItem<String>(
                                            value: val, child: Text(val));
                                      }).toList(),
                                      onChanged: (String? newVal) {
                                        setState(() {
                                          pickedFT = newVal!;
                                          var i = unitFT.indexOf(pickedFT);
                                          lookupKey = '${allWH[i]}$pickedFT';
                                          print(lookupKey);
                                        });
                                      }),
                                ),
                              ),
                              sequenceCircle(1),
                            ],
                          ),
                        ),
                        //==================================================================
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            sequenceCircle(2),
                            Text(
                              "Sonding awal (Satuan cm)",
                              style: sfb(),
                            ),
                          ],
                        ),
                        //==================================================================
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CustomTextField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) =>
                                    value!.isEmpty ? 'Harus diisi' : null,
                                textEditingController: sondingDepanAwal_c,
                                textCapitalization: TextCapitalization.words,
                                textInputType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                hint: "Depan",
                              ),
                            ),
                            Expanded(
                              child: CustomTextField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) =>
                                    value!.isEmpty ? 'Harus diisi' : null,
                                textEditingController: sondingBelakangAwal_c,
                                textCapitalization: TextCapitalization.words,
                                textInputType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                hint: "Belakang",
                              ),
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Center(
                                  child:
                                      Text('Rata-rata : $sondingAvgAwal cm')),
                            ),
                            Expanded(
                              flex: 1,
                              child:
                                  Center(child: Text('Qty : $qtyAvgAwal litr')),
                            )
                          ],
                        ),
                        Divider(),
                        //==================================================================
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            sequenceCircle(3),
                            Text(
                              "Sonding akhir (Satuan cm)",
                              style: sfb(),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CustomTextField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) =>
                                    value!.isEmpty ? 'Harus diisi' : null,
                                textEditingController: sondingDepanAkhir_c,
                                textCapitalization: TextCapitalization.words,
                                textInputType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                hint: "Depan",
                              ),
                            ),
                            Expanded(
                              child: CustomTextField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) =>
                                    value!.isEmpty ? 'Harus diisi' : null,
                                textEditingController: sondingBelakangAkhir_c,
                                textCapitalization: TextCapitalization.words,
                                textInputType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                hint: "Belakang",
                              ),
                            ),

                            //==================================================================
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Center(
                                  child:
                                      Text('Rata-rata : $sondingAvgAkhir cm')),
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(
                                  child: Text('Qty : $qtyAvgAkhir litr')),
                            )
                          ],
                        ),
                        //==================================================================
                        const SizedBox(
                          height: 20,
                        ),
                        //==================================================================
                        Row(children: <Widget>[
                          const Expanded(
                              child: Divider(
                            thickness: 2,
                          )),
                          Stack(
                            children: [
                              Material(
                                child: Ink(
                                  height: 30,
                                  width: size.width * 0.75,
                                  decoration: BoxDecoration(
                                      color: Colors.orangeAccent.shade100,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(24))),
                                  child: InkWell(
                                    splashColor: Colors.white,
                                    onTap: () {
                                      //==============================================Validasi
                                      final validate = validasiSondingInput();
                                      if (validate != "valid") {
                                        return customErrorMessage("Error",
                                            "Perhatikan isian $validate");
                                      }

                                      //==============================================Process Sonding Awal

                                      sondingDepanAwal =
                                          sondingDepanAwal_c.text;
                                      sondingDepanAkhir =
                                          sondingDepanAkhir_c.text;
                                      sondingBelakangAwal =
                                          sondingBelakangAwal_c.text;
                                      sondingBelakangAkhir =
                                          sondingBelakangAkhir_c.text;

                                      sondingAvgAwal = ((double.parse(
                                                      sondingDepanAwal) +
                                                  double.parse(
                                                      sondingBelakangAwal)) /
                                              2)
                                          .toString();

                                      sondingAvgAkhir = ((double.parse(
                                                      sondingDepanAkhir) +
                                                  double.parse(
                                                      sondingBelakangAkhir)) /
                                              2)
                                          .toString();

                                      double resultLiter = 0,
                                          resultLiterAkhir = 0;

                                      print('$lookupKey$sondingAvgAwal');
                                      print('$lookupKey$sondingAvgAkhir');
                                      resultLiter = convertToLiterFT(
                                          sondingAvgAwal, teraFT, lookupKey);
                                      resultLiterAkhir = convertToLiterFT(
                                          sondingAvgAkhir, teraFT, lookupKey);
                                      setState(() {
                                        qtyAvgAwal =
                                            resultLiter.toStringAsFixed(0);
                                        qtyAvgAkhir =
                                            resultLiterAkhir.toStringAsFixed(0);
                                        qtyByTera =
                                            (resultLiterAkhir - resultLiter)
                                                .toStringAsFixed(0);
                                      });

                                      //==============================================Process Sonding Akhir
                                    },
                                    child: Center(
                                        child: qtyByTera == ""
                                            ? const Text("Tap Untuk Hitung Qty")
                                            : Text.rich(TextSpan(children: [
                                                TextSpan(
                                                    text:
                                                        'Fuel out by Tera : '),
                                                TextSpan(
                                                    text: '$qtyByTera',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .blue.shade700,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(text: ' liter'),
                                              ]))),
                                  ),
                                ),
                              ),
                              sequenceCircle(4)
                            ],
                          ),
                          const Expanded(child: Divider(thickness: 2)),
                        ]),

                        //==================================================================

                        //==================================================================
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              CustomTextField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) =>
                                    value!.isEmpty ? 'Harus diisi' : null,
                                textEditingController: qty_fm_c,
                                textCapitalization: TextCapitalization.words,
                                textInputType: TextInputType.number,
                                hint:
                                    "Qty by Flowmeter (Kalau tidak FM ada diisi 0)",
                                onFieldChanged: (p0) {
                                  setState(() {
                                    qtyFM = p0!;
                                  });
                                },
                              ),
                              sequenceCircle(5)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              CustomTextField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) =>
                                    value!.isEmpty ? 'Harus diisi' : null,
                                textEditingController: qty_additive_c,
                                textCapitalization: TextCapitalization.words,
                                textInputType: TextInputType.number,
                                hint: "Additive Qty (liter)",
                                onFieldChanged: (p0) {
                                  setState(() {
                                    qtyAdditive = p0!;
                                  });
                                },
                              ),
                              sequenceCircle(6)
                            ],
                          ),
                        ),
                        //==================================================================
                        //==================================================================
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Stack(
                            children: [
                              CustomTextField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) =>
                                      value!.isEmpty ? 'Harus diisi' : null,
                                  textEditingController: fuelman_c,
                                  hint: "Fuelman Name",
                                  textCapitalization: TextCapitalization.words,
                                  textInputType: TextInputType.name,
                                  readonly: true,
                                  prefIcon: Visibility(
                                    visible: appUserData == null
                                        ? false
                                        : appUserData!.role != "fuelman",
                                    child: IconButton(
                                        onPressed: () async {
                                          final data = await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return ChoiceDialog(
                                                dataGroup: FuelmanList,
                                              );
                                            },
                                          );
                                          if (data != null) {
                                            fuelman_c.text = data;
                                          }
                                        },
                                        icon: Icon(Icons.search)),
                                  ),
                                  suffixIcon: Icon(Icons.lock_outlined)),
                              appUserData == null
                                  ? sequenceCircle(7)
                                  : appUserData!.role != "fuelman"
                                      ? sequenceCircle(7)
                                      : Container()
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Stack(
                            children: [
                              CustomTextField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) =>
                                      value!.isEmpty ? 'Harus diisi' : null,
                                  textEditingController: opt_c,
                                  hint: "Operator Name",
                                  readonly: true,
                                  prefIcon: IconButton(
                                      onPressed: () async {
                                        final data = await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return ChoiceDialog(
                                              dataGroup: OperatorList,
                                            );
                                          },
                                        );
                                        if (data != null) {
                                          opt_c.text = data;
                                        }
                                      },
                                      icon: Icon(Icons.search)),
                                  textCapitalization: TextCapitalization.words,
                                  textInputType: TextInputType.name,
                                  // readonly: true,
                                  suffixIcon: Icon(Icons.lock_outlined)),
                              appUserData == null
                                  ? sequenceCircle(7)
                                  : appUserData!.role != "fuelman"
                                      ? sequenceCircle(8)
                                      : sequenceCircle(7)
                            ],
                          ),
                        ),

                        //==================================================================
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Stack(
                            children: [
                              Material(
                                  child: Ink(
                                width: size.width / 2,
                                height: 40,
                                decoration: const BoxDecoration(
                                    color: Colors.orangeAccent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(24))),
                                child: InkWell(
                                  splashColor: Colors.white,
                                  onTap: (() async {
                                    final validated = validation();
                                    if (validated != "ok") {
                                      customErrorMessage("Error", validated);
                                      return;
                                    }
                                    final conf =
                                        await sendForm("Tambahkan Data?");
                                    if (conf == true) addNewFT();
                                  }),
                                  child: const Center(
                                    child: Text("Tambah"),
                                  ),
                                ),
                              )),
                              appUserData == null
                                  ? sequenceCircle(8)
                                  : appUserData!.role != "fuelman"
                                      ? sequenceCircle(9)
                                      : sequenceCircle(8)
                            ],
                          ),
                        )
                        //==================================================================
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  String validasiSondingInput() {
    if (pickedFT == "Pilih FT") return "FT";
    if (sondingDepanAwal_c.text.isEmpty || sondingBelakangAwal_c.text.isEmpty)
      return "Sonding Awal";
    if (sondingDepanAkhir_c.text.isEmpty || sondingBelakangAkhir_c.text.isEmpty)
      return "Sonding Akhir";
    return "valid";
  }

  String validation() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      if (pickedFT == "Pilih FT") return "FT belum diisi";
      if (qtyByTera == "") return "Qty tera masih kosong";
      if (double.parse(qtyByTera) < 0) return "Qty tera invalid";
      return "ok";
    }
    return "Input tidak Lengkap";
  }

  void addNewFT() async {
    LoaderDialog.showLoadingDialog("Sending Data");
    String _jam = DateFormat("hh:mm:ss").format(DateTime.now());
    FuelTruck newFT = FuelTruck(
      ID: 'GM$DO_date${shift}${urutan}',
      shift: shift,
      tgl: formattedSlashDate(DateTime.now()),
      urutan: urutan,
      ftNumber: pickedFT,
      whCode: FTMap[pickedFT]!,
      fuelman: fuelman_c.text,
      sondBefore: double.parse(sondingAvgAwal),
      sondAfter: double.parse(sondingAvgAkhir),
      noDO: 'GM$DO_date${shift}${urutan}',
      qtyByTera: qtyByTera,
      qtyBefore: qtyAvgAwal,
      qtyAfter: qtyAvgAkhir,
      qtyFM: qtyFM,
      jam: _jam,
      operator: opt_c.text,
      PONO: "Unassigned",
      isReceived: "no",
      receiveDate: "Outstanding",
      sondingAwalDepan: double.parse(sondingDepanAwal),
      sondingAwalBelakang: double.parse(sondingBelakangAwal),
      sondingAkhirDepan: double.parse(sondingDepanAkhir),
      sondingAkhirBelakang: double.parse(sondingBelakangAkhir),
      pelapor: appUserData!.name,
      additive: int.parse(qtyAdditive),
    );

    //---------------------------
    var sheet = await getWorksheet(fuelManagerSheet, 'Monitoring Receiving');
    final dst = await sheet.values.allRows(fromRow: 7);
    int lastRow = dst.length;
    await sheet.values.insertRow(lastRow + 7, FuelTruck.toGoogleMaps(newFT));
    //---------------------------

    // resetForm();
    Navigator.pop(context);
    Navigator.pop(context);

    customSuccessMessage("Success", 'Penambahan Data Fueltruck Berhasil !');
  }

  Future<int> getQueueNumber() async {
    var sheet = await getWorksheet(fuelManagerSheet, 'Monitoring Receiving');
    String date = await sheet.values.value(column: 16, row: 3);
    var epoch = new DateTime(1899, 12, 30);
    var lastdate = epoch.add(new Duration(days: int.parse(date)));
    String strlastdate = DateFormat("ddMMyy").format(lastdate);
    if (strlastdate == formattedTodayTwoStringRev) {
      String lastQueue = await sheet.values.value(column: 17, row: 3);
      return int.parse(lastQueue) + 1;
    }
    return 1;
  }

  Future<Worksheet> getWorksheet(String workbookID, String sheetName) async {
    final gsheets = GSheets(credentials);
    final ss = await gsheets.spreadsheet(workbookID);
    return await ss.worksheetByTitle(sheetName)!;
  }

  Future getMasterData() async {
    var sheet = await getWorksheet(fuelManagerSheet, "Master data");
    final dataFM =
        await sheet.values.allRows(fromRow: 2, fromColumn: 1, length: 1);
    final dataOpt =
        await sheet.values.allRows(fromRow: 2, fromColumn: 3, length: 1);
    final dataFT =
        await sheet.values.allRows(fromRow: 2, fromColumn: 5, length: 2);

    for (var item in dataFM) {
      FuelmanList.add(item[0]);
    }

    for (var item in dataOpt) {
      OperatorList.add(item[0]);
    }
    for (var item in dataFT) {
      final entries = {item[0]: item[1]};
      FTMap.addAll(entries);
    }
  }

  void resetForm() {
    pickedFT = "Pilih FT";
    sondingDepanAwal_c.clear();
    sondingDepanAkhir_c.clear();
    sondingBelakangAwal_c.clear();
    sondingBelakangAkhir_c.clear();
    qty_fm_c.clear();
    opt_c.clear();
    qtyAvgAwal = "0";
    qtyAvgAkhir = "0";
    qtyByTera = "0";
    setState(() {});
  }

  double convertToLiterFT(String depth, List<Tera> TeraTable, String prefix) {
    double resultLiter = 0;
    int x1, x2;
    double y, y1, y2;
    double sonding;
    int index = 0;
    List<String> col1 = [];
    List<String> col2 = [];
    String sondingX1 = "", sondingX2 = "";
    sonding = double.parse(depth);

    //====================check apakah melebihi max depth
    String FTNum = prefix.substring(4);
    int FTindex = unitFT.indexOf(FTNum);
    if (double.parse(depth) > maxDepth[FTindex]) {
      resultLiter = 0;
    }
    //==========================================
    else {
      if (sonding % 1 == 0) {
        print('genap');
        x1 = sonding.floor();
        x2 = sonding.ceil();
        sondingX1 = '$prefix${x1.toString()}';
        sondingX2 = '$prefix${x2.toString()}';

        for (int i = 0; i < TeraTable.length; i++) {
          col1.add(TeraTable[i].depth);
          col2.add(TeraTable[i].qty);
        }
        index = col1.indexWhere((element) => element == sondingX1);
        y1 = double.parse(col2[index]);
        resultLiter = y1;
      } else {
        print('ganjil');
        x1 = sonding.floor();
        x2 = sonding.ceil();
        sondingX1 = '$prefix${x1.toString()}';
        sondingX2 = '$prefix${x2.toString()}';

        for (int i = 0; i < TeraTable.length; i++) {
          col1.add(TeraTable[i].depth);
          col2.add(TeraTable[i].qty);
        }

        index = col1.indexWhere((element) => element == sondingX1);
        y1 = double.parse(col2[index]);
        index = col1.indexWhere((element) => element == sondingX2);
        y2 = double.parse(col2[index]);

        y = y1 + (sonding - x1) * ((y2 - y1) / (x2 - x1));
        resultLiter = y;
      }
    }

    return resultLiter;
  }
}
