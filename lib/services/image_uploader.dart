import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fuelmanager/widgets/custom_snackbar.dart';
import 'package:path/path.dart' as p;

class ImageUploader {
  static CollectionReference usrRef =
      FirebaseFirestore.instance.collection('users');
  static CollectionReference imgRef =
      FirebaseFirestore.instance.collection('images');
  static CollectionReference extRef =
      FirebaseFirestore.instance.collection('issuing_external');

  static Future<String> uploadProfileImg(File? img, String nrp) async {
    var ref =
        FirebaseStorage.instance.ref().child('users/${p.basename(img!.path)}');
    String url = '';

    await ref.putFile(img).whenComplete(() async {
      await ref.getDownloadURL().then((value) {
        try {
          usrRef.doc(nrp).get().then((ds) {
            if (ds.exists) {
              ds.reference.update({'image': value});
            } else {
              ds.reference.set({'image': value});
            }
          });
        } catch (e) {
          customErrorMessage("Error modifying url", e.toString());
          return;
        }
        url = value;
      });
    });
    return url;
  }

  static Future<String> uploadFile(
      File? img, String dateData, String key) async {
    var ref = FirebaseStorage.instance
        .ref()
        .child('images/$dateData/${p.basename(img!.path)}');
    String url = '';

    await ref.putFile(img).whenComplete(() async {
      await ref.getDownloadURL().then((value) {
        try {
          imgRef.doc(dateData).get().then((ds) {
            if (ds.exists) {
              ds.reference.update({key: value});
            } else {
              ds.reference.set({key: value});
            }
          });
        } catch (e) {
          customErrorMessage("Error modifying url", e.toString());
          return;
        }
        url = value;
      });
    });
    return url;
  }

  static Future<String> uploadEvidence(
      File? img, String companyCode, String databaseDocId, String key) async {
    var ref = FirebaseStorage.instance.ref().child(
        'external/${databaseDocId.substring(4, 11)}/${p.basename(img!.path)}');
    String url = '';

    await ref.putFile(img).whenComplete(() async {
      try {
        await ref.getDownloadURL().then((value) {
          extRef.doc(databaseDocId).get().then((ds) {
            ds.reference.update({key: value});
          });
          url = value;
        });
      } catch (e) {
        customErrorMessage("Error modifying url", e.toString());
        return;
      }
    });
    return url;
  }

  static Future<String> uploadFinding(
      File? img, String dateData, String unit) async {
    var ref = FirebaseStorage.instance
        .ref()
        .child('finding/$unit/${p.basename(img!.path)}');
    String url = '';

    await ref.putFile(img).whenComplete(() async {
      await ref.getDownloadURL().then((value) {
        url = value;
      });
    });
    return url;
  }
}
