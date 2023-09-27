import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fuelmanager/models/fuel_request_model.dart';
import 'package:fuelmanager/models/user_model.dart';
import 'package:fuelmanager/widgets/custom_snackbar.dart';

class FirebaseDB {
  static Future<String> registeringUser(NewUserModel newUserModel) async {
    try {
      FirebaseFirestore.instance
          .collection('new_registrant')
          .add(NewUserModel.toMap(newUserModel));
    } catch (e) {
      return e.toString();
    }
    return "success";
  }

  static Future<String> injectUser(AppUserData appUserData) async {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(appUserData.ID)
          .set(AppUserData.toRegistrationMap(appUserData));
    } catch (e) {
      return e.toString();
    }
    return "success";
  }

  static Future<String> checkUser(AppUserData appUserData) async {
    bool exist = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: appUserData.ID)
        .snapshots()
        .first
        .then((value) {
      return value.docs.first.exists;
    });

    if (exist == false) {
      return "not found";
    } else {
      return "found";
    }
  }

  static Future<String> insertExternalUsage(
      String id, FuelRequestModel req) async {
    try {
      FirebaseFirestore.instance
          .collection('issuing_external')
          .doc(id)
          .set(FuelRequestModel.toMap(req));
    } catch (e) {
      return e.toString();
    }
    return "success";
  }

  static Future<String?> fetchCompanyID(String company) async {
    String? name;
    name = await FirebaseFirestore.instance
        .collection('companies')
        .where('company_name', isEqualTo: company)
        .snapshots()
        .first
        .then((value) {
      return value.docs.first.get('initial');
    });
    return name;
  }

  static Future<int> fetchRequestCount(String checkCode) async {
    int count = 0;
    QuerySnapshot qs =
        await FirebaseFirestore.instance.collection('issuing_external').get();
    List<DocumentSnapshot> ds = qs.docs;
    for (int i = 0; i < ds.length; i++) {
      if (ds[i].id.startsWith(checkCode)) {
        count++;
      }
    }

    return count;
  }
}
