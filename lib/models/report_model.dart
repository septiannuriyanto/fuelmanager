import 'package:cloud_firestore/cloud_firestore.dart';

class ReportAwalShift {
  DateTime? date;
  String? awal1_depth;
  String? awal2_depth;
  String? awal3_depth;
  String? awalavg_depth;
  bool? closed;
  String? stockTaker;
  double? qtyAwal;

  ReportAwalShift({
    this.awal1_depth,
    this.awal2_depth,
    this.awal3_depth,
    this.closed,
    this.stockTaker,
    this.qtyAwal,
    this.awalavg_depth,
  });

  static Map<String, dynamic> toMap(ReportAwalShift reportAwalShift) => {
        'awal1_depth': reportAwalShift.awal1_depth,
        'awal2_depth': reportAwalShift.awal2_depth,
        'awal3_depth': reportAwalShift.awal3_depth,
        'awalavg_depth': reportAwalShift.awalavg_depth,
        'closed': reportAwalShift.closed,
        'stocktaker': reportAwalShift.stockTaker,
        'qty_awal': reportAwalShift.qtyAwal,
      };
}

class ReportAkhirShift {
  DateTime? date;
  String? akhir1_depth;
  String? akhir2_depth;
  String? akhir3_depth;
  String? akhiravg_depth;
  bool? closed;
  String? stockTaker;
  double? qtyAkhir;
  double? usageQty;

  ReportAkhirShift({
    this.akhir1_depth,
    this.akhir2_depth,
    this.akhir3_depth,
    this.closed,
    this.stockTaker,
    this.akhiravg_depth,
  });

  static Map<String, dynamic> toMap(ReportAkhirShift reportAkhirShift) => {
        'akhir1_depth': reportAkhirShift.akhir1_depth,
        'akhir2_depth': reportAkhirShift.akhir2_depth,
        'akhir3_depth': reportAkhirShift.akhir3_depth,
        'akhiravg_depth': reportAkhirShift.akhiravg_depth,
        'closed': reportAkhirShift.closed,
        'stocktaker': reportAkhirShift.stockTaker,
        'qty_akhir': reportAkhirShift.qtyAkhir,
        'qty_usage': reportAkhirShift.usageQty
      };
}

class GSheetReportModel {
  ReportAwalShift? awalShift;
  ReportAkhirShift? akhirShift;
  String? awal1_url;
  String? awal2_url;
  String? awal3_url;
  String? akhir1_url;
  String? akhir2_url;
  String? akhir3_url;
  String? date;

  GSheetReportModel({
    this.awalShift,
    this.akhirShift,
    this.awal1_url,
    this.awal2_url,
    this.awal3_url,
    this.akhir1_url,
    this.akhir2_url,
    this.akhir3_url,
    this.date,
  });

  GSheetReportModel.fromDocumentSnapshot(DocumentSnapshot ds) {
    awalShift = ReportAwalShift();
    akhirShift = ReportAkhirShift();

    awalShift!.awal1_depth =
        ds.get('awal1_depth').toString().replaceAll('.', ',');
    awalShift!.awal2_depth =
        ds.get('awal2_depth').toString().replaceAll('.', ',');
    awalShift!.awal3_depth =
        ds.get('awal3_depth').toString().replaceAll('.', ',');
    awalShift!.awalavg_depth =
        ds.get('awalavg_depth').toString().replaceAll('.', ',');
    awalShift!.qtyAwal = ds.get('qty_awal');
    akhirShift!.akhir1_depth =
        ds.get('akhir1_depth').toString().replaceAll('.', ',');
    akhirShift!.akhir2_depth =
        ds.get('akhir2_depth').toString().replaceAll('.', ',');
    akhirShift!.akhir3_depth =
        ds.get('akhir3_depth').toString().replaceAll('.', ',');
    akhirShift!.akhiravg_depth =
        ds.get('akhiravg_depth').toString().replaceAll('.', ',');
    akhirShift!.qtyAkhir = ds.get('qty_akhir');
    akhirShift!.usageQty = ds.get('qty_usage');
    akhirShift!.closed = ds.get('closed');
    awal1_url = ds.get('awal1_img');
    awal2_url = ds.get('awal2_img');
    awal3_url = ds.get('awal3_img');
    akhir1_url = ds.get('akhir1_img');
    akhir2_url = ds.get('akhir2_img');
    akhir3_url = ds.get('akhir3_img');
    date = ds.id;
  }
}
