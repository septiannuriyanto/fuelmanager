import 'package:cloud_firestore/cloud_firestore.dart';

class FuelRequestModel {
  String? codeNumber;
  String? company;
  DateTime? date_delivered;
  bool? isDelivered;
  String? evidence_url;
  String? fuelman;
  int? qty;
  String? requestor;
  String? receiver;
  String? ft_name;

  FuelRequestModel({
    required this.codeNumber,
    required this.company,
    required this.date_delivered,
    required this.isDelivered,
    required this.evidence_url,
    required this.fuelman,
    required this.qty,
    required this.requestor,
    required this.receiver,
    required this.ft_name,
  });

  static Map<String, dynamic> toMap(FuelRequestModel req) => {
        'code_number': req.codeNumber!,
        'company': req.company!,
        'date_delivered': req.date_delivered!,
        'date_request': req.date_delivered!,
        'delivered': req.isDelivered,
        'evidence_url': req.evidence_url!,
        'fuelman': req.fuelman,
        'qty_request': req.qty,
        'requestor': req.requestor,
        'receiver': req.receiver,
        'warehouse': req.ft_name,
      };
}
