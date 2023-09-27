//--------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:fuelmanager/models/user_model.dart';
import 'package:fuelmanager/ui/screens/infrastructure_screen/infrastructure_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/menu_model.dart';
import '../ui/screens/externalrequest_screen/externalrequest_screen.dart';
import '../ui/screens/filterchange_screen/filterchange_screen.dart';
import '../ui/screens/sonding_screen/sonding_history.dart';

List<MenuModel> receivingMenu = [
  MenuModel(
      img: Image(
          fit: BoxFit.cover, image: AssetImage('assets/images/sonding.jpg')),
      desc: "Sonding\n Fuel Station",
      ontap: () {
        Get.to(() => SondingHistory());
      }),
];

List<MenuModel> storingMenu = [
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
];
