import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fuelmanager/models/user_model.dart';
import 'package:fuelmanager/constant/theme.dart';
import 'package:fuelmanager/ui/screens/signup_screen/signup_screen.dart';
import 'package:fuelmanager/utils/image_handler.dart';
import 'package:fuelmanager/widgets/custom_button.dart';
import 'package:fuelmanager/widgets/custom_snackbar.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:get/get.dart';

import '../../dialog/loader_dialog.dart';

//code for designing the UI of our text field where the user writes his email id or password

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

final _auth = FirebaseAuth.instance;

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _Loginkey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    asyncFunction();
    super.initState();
  }

  void asyncFunction() async {}

  String username = "";
  String password = "";
  bool showSpinner = false;
  final username_con = TextEditingController();
  final password_con = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final GlobalKey _loginLoader = GlobalKey();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.white, kSecondaryColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _Loginkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Container(
                  width: 100,
                  height: 100,
                  child: Image.asset('assets/images/fuelmanager.png'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    "Welcome to Fuel manager App",
                    style: txt16.copyWith(fontWeight: FontWeight.bold),
                  )),
                ),
                const SizedBox(
                  height: 50,
                ),
                TextFormField(
                    controller: username_con,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => value!.isEmpty ? 'Harus diisi' : null,
                    keyboardType: TextInputType.name,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      username = value;
                      //Do something with the user input.
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Masukkan username (NRP)',
                    )),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                    controller: password_con,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => value!.isEmpty ? 'Harus diisi' : null,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      password = value;
                      //Do something with the user input.
                    },
                    onFieldSubmitted: (newValue) async {
                      final isValid = await validateAndSave(
                          username_con.text.toUpperCase(), password_con.text);
                      if (isValid == LoginStatus.success) {
                        await AppUserData.login();
                      }
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Masukkan password')),
                const SizedBox(
                  height: 24.0,
                ),
                CustomRRButton(
                    borderRadius: 12,
                    contentColor: kSecondaryColor,
                    color: kPrimaryColor,
                    title: "Login",
                    width: Get.width * 0.5,
                    onTap: () async {
                      final isValid = await validateAndSave(
                          username_con.text.toUpperCase(), password_con.text);
                      if (isValid == LoginStatus.success) {
                        await AppUserData.login();
                      }
                    }),
                SizedBox(
                  height: 10,
                ),
                CustomRRButton(
                    outlineColor: kPrimaryColor,
                    borderRadius: 12,
                    contentColor: kPrimaryColor,
                    color: kThirdColor,
                    title: "Sign up",
                    width: Get.width * 0.5,
                    onTap: () {
                      Get.to(() => SignupScreen());
                    }),
                Expanded(child: Container()),
                const Padding(
                  padding: EdgeInsets.only(bottom: 3.0),
                  child: Center(
                    child: Text(
                      'Built for PT. Pama BRCG',
                      style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 13,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
                Expanded(child: Container()),
                const Padding(
                  padding: EdgeInsets.only(bottom: 3.0),
                  child: Center(
                      child: Text(
                    'Developed by Scalar Coding',
                    style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 10,
                        fontWeight: FontWeight.w400),
                  )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validating() {
    final FormState? form = _Loginkey.currentState;
    return form!.validate();
  }

  Future<LoginStatus> validateAndSave(String user, String pass) async {
    if (user.isEmpty) {
      customErrorMessage("Error Input", "Username tidak boleh kosong!");
      return LoginStatus.userempty;
    }

    if (pass.isEmpty) {
      customErrorMessage("Error Input", "Password tidak boleh kosong!");
      return LoginStatus.passwordempty;
    }

    LoaderDialog.showLoadingDialog("Logging in");
    try {
      final status = await FirebaseFirestore.instance
          .collection('users')
          .doc(user)
          .get()
          .then((value) => value.exists);

      if (status == false) {
        Get.back();
        customErrorMessage("Error Login", "Username tidak terdaftar!");
        return LoginStatus.failedAccountNotExist;
      }
    } catch (e) {
      Get.back();
      customErrorMessage("Error", e.toString());
      return LoginStatus.failedBadConnection;
    }

    final email = await FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .get()
        .then((value) => value.get('email'));

    bool? isAuthenticated;
    dynamic errorMsg;

    try {
      UserCredential users = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      errorMsg = e.toString();
      isAuthenticated = false;
    }

    if (isAuthenticated == false) {
      Get.back();
      if (errorMsg.toString().contains("password is invalid")) {
        customErrorMessage("Authentication Error", "Password salah");
      } else if (errorMsg.toString().contains("blocked")) {
        customErrorMessage("Authentication Error",
            "Terlalu banyak percobaan, coba lagi lain kali");
      } else {
        customErrorMessage("Authentication Error", errorMsg.toString());
      }
      return LoginStatus.AuthenticationProblem;
    }

    DocumentSnapshot userDs, credentialDS;

    try {
      userDs =
          await FirebaseFirestore.instance.collection('users').doc(user).get();
      AppUserData appUserData = AppUserData.fromDocumentSnapshot(userDs);

      credentialDS = await FirebaseFirestore.instance
          .collection('credentials')
          .doc(appUserData.role)
          .get();
    } catch (e) {
      print(e);
      customErrorMessage("Error Getting Data", errorMsg.toString());
      return LoginStatus.AuthenticationProblem;
    }

    AppUserData.saveFromDStoSharedPreferences(userDs);
    AppUserCredential.saveFromDStoSharedPreferences(credentialDS);
    Get.back();
    customSuccessMessage("Sukses", "Sukses Login");
    return LoginStatus.success;
  }
}

enum LoginStatus {
  userempty,
  passwordempty,
  success,
  failedAccountNotExist,
  failedWrongPassword,
  failedBadConnection,
  AuthenticationProblem,
}
