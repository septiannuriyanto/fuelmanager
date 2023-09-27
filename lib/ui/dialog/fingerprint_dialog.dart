import 'package:flutter/material.dart';
import 'package:fuelmanager/widgets/custom_snackbar.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

import '../../constant/theme.dart';
import '../../widgets/custom_button.dart';

class BiometricAuth extends StatelessWidget {
  bool? isBiometricSupported;
  bool? canCheckBiometrics;
  bool? isAuthenticated;
  final LocalAuthentication localAuthentication = LocalAuthentication();
  List<BiometricType>? biometricTypes;

  void asyncProcedures() async {
    isBiometricSupported = await localAuthentication.isDeviceSupported();
    canCheckBiometrics = await localAuthentication.canCheckBiometrics;
    biometricTypes = await localAuthentication.getAvailableBiometrics();
    print("Support Biometric :$isBiometricSupported");
    print("Can Check Biometric :$canCheckBiometrics");
    print("Biometric Types : $biometricTypes");
  }

  @override
  Widget build(BuildContext context) {
    asyncProcedures();
    Size size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: size.width * 0.9,
        height: size.width * 0.9,
        decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: const BorderRadius.all(Radius.circular(30))),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Fingerprint Authentication",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(child: Container()),
              Column(
                children: [
                  NeumorphicFingerPrint(
                      iconData: FingerprintIcon,
                      onClicked: (() async {
                        if (isBiometricSupported == false) {
                          customErrorMessage("Error Authentication",
                              "Device anda tidak support Fingerprint / Fingerprint belum diaktifkan di perangkat anda");
                        } else {
                          if (canCheckBiometrics! && isBiometricSupported!) {
                            try {
                              isAuthenticated =
                                  await localAuthentication.authenticate(
                                localizedReason: 'Tekan Sensor FingerPrint',
                              );
                              if (isAuthenticated!) {
                                // Lakukan sesuatu setelah terautentikasi
                                String msg = "success";
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context, msg);
                              }
                            } on PlatformException catch (exception) {
                              // catch the exception
                              print(
                                  "Error Otentikasi, ${exception.stacktrace}");
                            }
                          }
                        }
                      }))
                ],
              ),
              Expanded(child: Container()),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "Dengan melakukan otentikasi berikut, saya menyatakan bahwa data yang saya sampaikan adalah benar",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
