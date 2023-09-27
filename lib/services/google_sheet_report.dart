import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fuelmanager/models/report_model.dart';
import 'package:fuelmanager/services/google_sheet.dart';
import 'package:fuelmanager/widgets/custom_snackbar.dart';
import 'package:gsheets/gsheets.dart';

import '../functions/secrets.dart';

Future<void> googleReportSend(String dateCode) async {
  String spreadSheetID = "1cDwraoGt_x_2y53LGYZKB-fsx26Eg0H90QJhkbzfTfA";
  GSheetReportModel? gSheetReportModel;
  DocumentSnapshot? ds;
  final gsheets = GSheets(credentials);
  final ss = await gsheets.spreadsheet(spreadSheetID);
  var sheet = ss.worksheetByTitle('RECONCILE');
  int row = 3;

  ds = await FirebaseFirestore.instance
      .collection('images')
      .doc(dateCode)
      .snapshots()
      .first
      .then((value) {
    if (value.exists) {
      return value;
    } else {
      return null;
    }
  });

  if (ds == null) {
    customErrorMessage("Data Not Exist", "Data Snapshot Not Found ");
    return;
  }

  gSheetReportModel = GSheetReportModel.fromDocumentSnapshot(ds);

  var allRows = await sheet!.values.allRows(fromRow: 3, fromColumn: 19);

  for (int i = 0; i < allRows.length; i++) {
    row = i;
    if (allRows[i][0] == dateCode) {
      print(i);
      break;
    }
  }
  row = row + 3;

  final data = [
    gSheetReportModel.awalShift!.awalavg_depth,
    gSheetReportModel.akhirShift!.akhiravg_depth,
    gSheetReportModel.awalShift!.qtyAwal,
    gSheetReportModel.akhirShift!.qtyAkhir,
    gSheetReportModel.akhirShift!.usageQty,
    gSheetReportModel.akhirShift!.closed,
    gSheetReportModel.awalShift!.awal1_depth,
    gSheetReportModel.awalShift!.awal2_depth,
    gSheetReportModel.awalShift!.awal3_depth,
    gSheetReportModel.akhirShift!.akhir1_depth,
    gSheetReportModel.akhirShift!.akhir2_depth,
    gSheetReportModel.akhirShift!.akhir3_depth,
    gSheetReportModel.awal1_url,
    gSheetReportModel.awal2_url,
    gSheetReportModel.awal3_url,
    gSheetReportModel.akhir1_url,
    gSheetReportModel.akhir2_url,
    gSheetReportModel.akhir3_url,
  ];

  await sheet.values.insertRow(row, data, fromColumn: 20);
}
