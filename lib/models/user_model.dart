import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fuelmanager/services/fcm.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui/screens/home screen/home_screen.dart';

class AppUserData {
  String? ID;
  String? name;
  String? email;
  String? role;
  String? company;
  String? imgUrl;
  String? token;

  AppUserData({
    this.ID,
    this.name,
    this.email,
    this.role,
    this.company,
    this.imgUrl,
    this.token,
  });

  AppUserData.fromRegistrationSnapshot(DocumentSnapshot ds, String newRole) {
    ID = ds.get('username');
    name = ds.get('name');
    email = ds.get('email');
    company = ds.get('company');
    imgUrl = ds.get('image');
    token = ds.get('dToken');
    role = newRole;
  }

  AppUserData.fromDocumentSnapshot(DocumentSnapshot ds) {
    ID = ds.id;
    name = ds.get('name');
    email = ds.get('email');
    role = ds.get('role');
    company = ds.get('company');
    imgUrl = ds.get('image');
    token = ds.get('dToken');
  }

  static List<String> toList(AppUserData appUserData) => [
        appUserData.ID!,
        appUserData.name!,
        appUserData.email!,
        appUserData.role!,
        appUserData.company!,
        appUserData.imgUrl!,
        appUserData.token!,
      ];

  static Map<String, String> toMap(AppUserData appUserData) => {
        'id': appUserData.ID!,
        'name': appUserData.name!,
        'email': appUserData.email!,
        'role': appUserData.role!,
        'company': appUserData.company!,
        'image': appUserData.imgUrl!,
        'dToken': appUserData.token!,
      };
  static Map<String, String> toRegistrationMap(AppUserData appUserData) => {
        'username': appUserData.ID!,
        'name': appUserData.name!,
        'email': appUserData.email!,
        'role': appUserData.role!,
        'company': appUserData.company!,
        'image': appUserData.imgUrl!,
        'dToken': appUserData.token!,
      };

  static AppUserData? fromSharedPreferences(SharedPreferences prefs) {
    final prefList = prefs.getStringList('userdata');
    return AppUserData(
      ID: prefList![0],
      name: prefList[1],
      email: prefList[2],
      role: prefList[3],
      company: prefList[4],
      imgUrl: prefList[5],
      token: prefList[6],
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

    // Update token to application server.
    prefs = await SharedPreferences.getInstance();
    prefs.setString('dToken', FirebaseMessagingApi.fcmToken!);
    final prefList = prefs.getStringList('userdata');
    final uid = prefList![0];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({"dToken": FirebaseMessagingApi.fcmToken!});

    Get.offAll(() => HomeScreen(
          appUserCredential: appUserCredential,
          appUserData: appUserData,
        ));
  }
}

class AppUserCredential {
  final bool admin_menu;
  final bool daily_report;
  final bool filter_replace;
  final bool ft_readiness;
  final bool inspeksi_infra;
  final bool issuing_ext;
  final bool receive_do;
  final bool request_ext;
  final bool ritasi_fs;
  final bool sonding_fs;
  final bool stock_taking;
  final bool receiving_menu;
  final bool storing_menu;
  final bool issuing_menu;
  final bool administration_menu;

  AppUserCredential({
    required this.admin_menu,
    required this.issuing_ext,
    required this.receive_do,
    required this.request_ext,
    required this.sonding_fs,
    required this.filter_replace,
    required this.daily_report,
    required this.ft_readiness,
    required this.inspeksi_infra,
    required this.ritasi_fs,
    required this.stock_taking,
    required this.issuing_menu,
    required this.receiving_menu,
    required this.storing_menu,
    required this.administration_menu,
  });

  factory AppUserCredential.fromDocumentSnapshot(DocumentSnapshot ds) {
    return AppUserCredential(
        admin_menu: ds.get('admin_menu'),
        issuing_ext: ds.get('issuing_ext'),
        receive_do: ds.get('receive_do'),
        request_ext: ds.get('request_ext'),
        sonding_fs: ds.get('sonding_fs'),
        filter_replace: ds.get('filter_replace'),
        daily_report: ds.get('daily_report'),
        ft_readiness: ds.get('ft_readiness'),
        inspeksi_infra: ds.get('inspeksi_infra'),
        ritasi_fs: ds.get('ritasi_ft'),
        stock_taking: ds.get('stock_taking'),
        issuing_menu: ds.get('issuing_menu'),
        storing_menu: ds.get('storing_menu'),
        receiving_menu: ds.get('receiving_menu'),
        administration_menu: ds.get('administration_menu') ?? false);
  }

  static List<String> toList(AppUserCredential creds) => [
        creds.admin_menu.toString(),
        creds.daily_report.toString(),
        creds.filter_replace.toString(),
        creds.ft_readiness.toString(),
        creds.inspeksi_infra.toString(),
        creds.issuing_ext.toString(),
        creds.receive_do.toString(),
        creds.request_ext.toString(),
        creds.ritasi_fs.toString(),
        creds.sonding_fs.toString(),
        creds.stock_taking.toString(),
        creds.receiving_menu.toString(),
        creds.storing_menu.toString(),
        creds.issuing_menu.toString(),
        creds.administration_menu.toString()
      ];

  static Map<String, String> toMap(AppUserCredential creds) => {
        'admin_menu': creds.admin_menu.toString(),
        'issuing_ext': creds.issuing_ext.toString(),
        'receive_do': creds.receive_do.toString(),
        'request_ext': creds.request_ext.toString(),
        'sonding_fs': creds.sonding_fs.toString(),
        'filter_replace': creds.filter_replace.toString(),
      };

  factory AppUserCredential.fromSharedPreferences(SharedPreferences prefs) {
    final prefList = prefs.getStringList('credentials');
    return AppUserCredential(
      admin_menu: prefList![0] == 'true',
      daily_report: prefList[1] == 'true',
      filter_replace: prefList[2] == 'true',
      ft_readiness: prefList[3] == 'true',
      inspeksi_infra: prefList[4] == 'true',
      issuing_ext: prefList[5] == 'true',
      receive_do: prefList[6] == 'true',
      request_ext: prefList[7] == 'true',
      ritasi_fs: prefList[8] == 'true',
      sonding_fs: prefList[9] == 'true',
      stock_taking: prefList[10] == 'true',
      receiving_menu: prefList[11] == 'true',
      storing_menu: prefList[12] == 'true',
      issuing_menu: prefList[13] == 'true',
      administration_menu: prefList[14] == 'true',
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
        'dToken': newUserModel.appUserData.token!,
        'image': newUserModel.appUserData.imgUrl!,
      };
}
