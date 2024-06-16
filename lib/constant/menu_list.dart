//--------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:fuelmanager/constant/constant.dart';
import 'package:fuelmanager/models/user_model.dart';
import 'package:fuelmanager/ui/screens/fuel_report_screen/fuel_report.dart';
import 'package:fuelmanager/ui/screens/legalitas_screen/legalitas_screen.dart';
import 'package:fuelmanager/ui/screens/infrastructure_screen/infrastructure_screen.dart';
import 'package:fuelmanager/ui/screens/readiness_screen/readiness_screen.dart';
import 'package:fuelmanager/ui/screens/ritation_screen/ritation_screen.dart';
import 'package:fuelmanager/ui/screens/stocktaking_screen/stocktaking_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/menu_model.dart';
import '../ui/screens/externalrequest_screen/externalrequest_screen.dart';
import '../ui/screens/filterchange_screen/filterchange_screen.dart';
import '../ui/screens/sonding_screen/sonding_history.dart';

List<MenuModel> receivingMenu = [
  MenuModel(
      img: Image(
          fit: BoxFit.cover, image: AssetImage('assets/images/sonding.png')),
      desc: "Sonding\nFuel Station",
      ontap: () {
        Get.to(() => SondingHistory());
      }),
  MenuModel(
      img: Image(
          fit: BoxFit.cover, image: AssetImage('assets/images/ritation.png')),
      desc: "Daily\nRitation Report",
      ontap: () {
        Get.to(() => RitationScreen());
      }),
];

List<MenuModel> storingMenu = [
  MenuModel(
      img: Image(
        fit: BoxFit.cover,
        image: AssetImage('assets/images/stocktaking.png'),
      ),
      desc: "Monthly\nStocktaking",
      ontap: () {
        Get.to(() => StocktakingScreen());
      }),
];

List<MenuModel> issuingMenu = [
  MenuModel(
      img: Image(
          fit: BoxFit.cover, image: AssetImage('assets/images/external.jpg')),
      desc: "External\nFuel Request",
      ontap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        AppUserData appUserData = AppUserData.fromSharedPreferences(prefs)!;
        Get.to(() => ExternalRequestScreen(
              appUserData: appUserData,
            ));
      }),
  MenuModel(
      img: Image(
          fit: BoxFit.cover, image: AssetImage('assets/images/report.png')),
      desc: "Daily\nFuel Report",
      ontap: () {
        Get.to(() => FuelReport());
      }),
];

List<MenuModel> administrationMenu = [
  MenuModel(
      img: Image(
          fit: BoxFit.cover, image: AssetImage('assets/images/filter.jpeg')),
      desc: "Penggantian\nFilter",
      ontap: () {
        Get.to(() => FilterChangeScreen());
      }),
  MenuModel(
      img: Image(
        fit: BoxFit.cover,
        image: AssetImage('assets/images/infrastructure.png'),
      ),
      desc: "Inspeksi\nInfrastructure",
      ontap: () {
        Get.to(() => InfrastructureScreen());
      }),
  MenuModel(
      img: Image(
          fit: BoxFit.cover, image: AssetImage('assets/images/readiness.png')),
      desc: "Fuel Truck\nReadiness",
      ontap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        AppUserData appUserData = AppUserData.fromSharedPreferences(prefs)!;
        Get.to(() => FTReadiness());
      }),
  MenuModel(
      img: Image(
          fit: BoxFit.cover, image: AssetImage('assets/images/readiness.png')),
      desc: "Legalitas",
      ontap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        AppUserData appUserData = AppUserData.fromSharedPreferences(prefs)!;
        Get.to(() => LegalitasScreen());
      }),
];
