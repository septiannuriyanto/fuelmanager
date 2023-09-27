import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui/screens/home screen/home_screen.dart';

class AppUserData {
  String? ID;
  String? name;
  String? email;
  String? role;
  String? company;

  AppUserData({this.ID, this.name, this.email, this.role, this.company});

  AppUserData.fromDocumentSnapshot(DocumentSnapshot ds) {
    ID = ds.id;
    name = ds.get('name');
    email = ds.get('email');
    role = ds.get('role');
    company = ds.get('company');
  }

  static List<String> toList(AppUserData appUserData) => [
        appUserData.ID!,
        appUserData.name!,
        appUserData.email!,
        appUserData.role!,
        appUserData.company!,
      ];

  static Map<String, String> toMap(AppUserData appUserData) => {
        'id': appUserData.ID!,
        'name': appUserData.name!,
        'email': appUserData.email!,
        'role': appUserData.role!,
        'company': appUserData.company!,
      };
  static Map<String, String> toRegistrationMap(AppUserData appUserData) => {
        'username': appUserData.ID!,
        'name': appUserData.name!,
        'email': appUserData.email!,
        'role': appUserData.role!,
        'company': appUserData.company!,
      };

  static AppUserData? fromSharedPreferences(SharedPreferences prefs) {
    final prefList = prefs.getStringList('userdata');
    return AppUserData(
      ID: prefList![0],
      name: prefList[1],
      email: prefList[2],
      role: prefList[3],
      company: prefList[4],
    );
  }

  static Future saveFromDStoSharedPreferences(DocumentSnapshot ds) async {
    final userData = AppUserData.fromDocumentSnapshot(ds);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('userdata', AppUserData.toList(userData));
  }

  static Future login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    AppUserData? appUserData;
    AppUserCredential? appUserCredential;
    appUserData = await AppUserData.fromSharedPreferences(prefs);
    appUserCredential = await AppUserCredential.fromSharedPreferences(prefs);

    Get.offAll(() => HomeScreen(
          appUserCredential: appUserCredential,
          appUserData: appUserData,
        ));
  }
}

class AppUserCredential {
  bool? admin_menu;
  bool? issuing_ext;
  bool? receive_do;
  bool? request_ext;
  bool? sonding_fs;
  bool? filter_replace;

  AppUserCredential({
    this.admin_menu,
    this.issuing_ext,
    this.receive_do,
    this.request_ext,
    this.sonding_fs,
    this.filter_replace,
  });

  AppUserCredential.fromDocumentSnapshot(DocumentSnapshot ds) {
    admin_menu = ds.get('admin_menu');
    issuing_ext = ds.get('issuing_ext');
    receive_do = ds.get('receive_do');
    request_ext = ds.get('request_ext');
    sonding_fs = ds.get('sonding_fs');
    filter_replace = ds.get('filter_replace');
  }

  static List<String> toList(AppUserCredential creds) => [
        creds.admin_menu.toString(),
        creds.issuing_ext.toString(),
        creds.receive_do.toString(),
        creds.request_ext.toString(),
        creds.sonding_fs.toString(),
        creds.filter_replace.toString(),
      ];

  static Map<String, String> toMap(AppUserCredential creds) => {
        'admin_menu': creds.admin_menu!.toString(),
        'issuing_ext': creds.issuing_ext!.toString(),
        'receive_do': creds.receive_do!.toString(),
        'request_ext': creds.request_ext!.toString(),
        'sonding_fs': creds.sonding_fs!.toString(),
        'filter_replace': creds.filter_replace.toString(),
      };

  static AppUserCredential fromSharedPreferences(SharedPreferences prefs) {
    final prefList = prefs.getStringList('credentials');
    return AppUserCredential(
      admin_menu: prefList![0] == 'true',
      issuing_ext: prefList[1] == 'true',
      receive_do: prefList[2] == 'true',
      request_ext: prefList[3] == 'true',
      sonding_fs: prefList[4] == 'true',
      filter_replace: prefList[5] == 'true',
    );
  }

  static Future saveFromDStoSharedPreferences(DocumentSnapshot ds) async {
    final userCredentials = AppUserCredential.fromDocumentSnapshot(ds);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        'credentials', AppUserCredential.toList(userCredentials));
  }
}

class NewUserModel {
  AppUserData appUserData;
  String password;

  NewUserModel({required this.appUserData, required this.password});

  static Map<String, String> toMap(NewUserModel newUserModel) => {
        'username': newUserModel.appUserData.ID!,
        'name': newUserModel.appUserData.name!,
        'email': newUserModel.appUserData.email!,
        'role': newUserModel.appUserData.role!,
        'company': newUserModel.appUserData.company!,
        'password': newUserModel.password,
      };
}
