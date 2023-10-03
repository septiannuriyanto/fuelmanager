import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuelmanager/functions/secrets.dart';
import 'package:fuelmanager/models/versions_model.dart';
import 'package:fuelmanager/ui/screens/home%20screen/home_screen.dart';
import 'package:fuelmanager/ui/screens/login_screen/signin_screen.dart';
import 'package:fuelmanager/utils/connection_checker.dart';
import 'package:fuelmanager/utils/styler.dart';
import 'package:fuelmanager/widgets/custom_button.dart';
import 'package:fuelmanager/widgets/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constant/theme.dart';
import '../../../models/user_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    startTimer();
  }

  SharedPreferences? prefs;
  Versions? ver;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, kSecondaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Expanded(child: Container()),
              Container(
                width: 100,
                height: 100,
                child: Image.asset('assets/images/fuelmanager.png'),
              ),
              Text(
                "Fuel Manager App",
                style: txt17.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                "Manage your Fuel Data",
                style: txt12,
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Text("Version : $APP_MAJOR_VER.$APP_MINOR_VER.$APP_PATCH"),
              )
            ],
          ),
        ),
      ),
    );
  }

  void startTimer() {
    Timer(Duration(seconds: 2), () async {
      setState(() {});

      prefs = await SharedPreferences.getInstance();
      // prefs!.clear();
      var status = prefs!.getBool('isLoggedIn') ?? false;
      // var status = false;
      if (status) {
        AppUserData? appUserData;
        AppUserCredential? appUserCredential;
        appUserData = AppUserData.fromSharedPreferences(prefs!);
        appUserCredential = AppUserCredential.fromSharedPreferences(prefs!);
        Get.offAll(() => HomeScreen(
              appUserCredential: appUserCredential,
              appUserData: appUserData,
            ));
      } else {
        Get.offAll(() => LoginScreen());
      }
    });
  }

  Future<Versions> getCurrentVersion() async {
    final ds = await FirebaseFirestore.instance
        .collection('versions')
        .get()
        .catchError((err) {
      print("Problem");
      return "Error";
    });

    final ver = Versions.fromDocumentSnapshot(ds.docs.last);
    return ver;
  }
}
