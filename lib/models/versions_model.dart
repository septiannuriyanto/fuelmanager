import 'package:cloud_firestore/cloud_firestore.dart';

class Versions {
  int major;
  int minor;
  int patch;
  DateTime releasedate;
  List<dynamic> changelog;

  Versions({
    required this.major,
    required this.minor,
    required this.patch,
    required this.releasedate,
    required this.changelog,
  });

  factory Versions.fromDocumentSnapshot(DocumentSnapshot ds) {
    return Versions(
        major: ds.get('major_ver'),
        minor: ds.get('minor_ver'),
        patch: ds.get('patch'),
        releasedate: (ds.get('date_released') as Timestamp).toDate(),
        changelog: ds.get('changelog'));
  }
}
