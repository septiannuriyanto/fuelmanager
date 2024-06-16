import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class LegalModel {
  String id;
  String type;
  String name;
  DateTime validUntil;
  String category;

  LegalModel(
      {required this.id,
      required this.type,
      required this.name,
      required this.category,
      required this.validUntil});

  factory LegalModel.fromDocumentSnapshot(DocumentSnapshot ds) {
    return LegalModel(
        id: ds.get('id'),
        type: ds.get('type'),
        name: ds.get('name'),
        category: ds.get('category'),
        validUntil: (ds.get('valid_until') as Timestamp).toDate());
  }

  static Map<String, dynamic> toMap(LegalModel lm) => {
        'id': lm.id,
        'name': lm.name,
        'category': lm.category,
        'type': lm.type,
        'valid_until': lm.validUntil,
      };
}
