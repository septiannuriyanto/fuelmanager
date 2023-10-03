import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fuelmanager/constant/theme.dart';
import 'package:fuelmanager/services/fcm.dart';
import 'package:fuelmanager/ui/screens/splash_screen/splash_screen.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseMessaging.instance.setAutoInitEnabled(false);
  await FirebaseMessagingApi().initNotifications();

  runApp(FuelManager());
}

class FuelManager extends StatelessWidget {
  FuelManager({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: getAppTheme(context),
      home: SplashScreen(),
    );
  }
}
