import 'package:flutter/material.dart';
import 'package:fuelmanager/constant/theme.dart';
import 'package:fuelmanager/models/user_model.dart';
import 'package:fuelmanager/services/firebase_db.dart';
import 'package:fuelmanager/widgets/custom_appbar.dart';
import 'package:fuelmanager/widgets/custom_button.dart';
import 'package:fuelmanager/widgets/custom_logintext.dart';
import 'package:fuelmanager/widgets/custom_snackbar.dart';
import 'package:get/get.dart';

class SignupScreen extends StatelessWidget {
  String? username, name, email, company, password, confPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: "Pendaftaran User Baru"),
          Expanded(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("Silahkan isi data - data berikut"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomLoginTextField(
                        hintText: "Nama Lengkap", onChanged: (p0) => name = p0),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomLoginTextField(
                      hintText: "Nomor Induk Karyawan",
                      onChanged: (p0) => username = p0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomLoginTextField(
                        hintText: "Alamat Email",
                        onChanged: (p0) => email = p0),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomLoginTextField(
                        hintText: "Perusahaan",
                        onChanged: (p0) => company = p0),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomLoginTextField(
                      hintText: "Password",
                      onChanged: (p0) => password = p0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomLoginTextField(
                      hintText: "Konfirmasi Password",
                      onChanged: (p0) => confPassword = p0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: CustomRRButton(
                        color: kPrimaryColor,
                        contentColor: kSecondaryColor,
                        borderRadius: 12,
                        title: "Daftar",
                        width: Get.width * 0.4,
                        onTap: () async {
                          NewUserModel newUserModel = NewUserModel(
                              appUserData: AppUserData(
                                  company: company,
                                  ID: username!.toUpperCase(),
                                  name: name,
                                  email: email,
                                  role: "new"),
                              password: password!);

                          print(newUserModel.appUserData.ID);
                          print(newUserModel.appUserData.name);
                          print(newUserModel.appUserData.email);
                          print(newUserModel.password);
                          bool? checkUserData =
                              validateRegistration(newUserModel);
                          if (checkUserData != true) {
                            customErrorMessage("Registration Data Error",
                                "Cek Kembali Data Anda");
                            return;
                          }
                          String res =
                              await FirebaseDB.registeringUser(newUserModel);
                          if (res != "success") {
                            customErrorMessage("Registration Error", res);
                          } else {
                            Get.back();
                            customSuccessMessage("Registration Success",
                                "Sukses Mendaftarkan User, Silahkan kontak admin untuk aktivasi login");
                          }
                        }),
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  bool validateRegistration(NewUserModel newUserModel) {
    if (newUserModel.appUserData.ID == null ||
        newUserModel.appUserData.ID == '') {
      return false;
    }

    if (newUserModel.appUserData.name == null ||
        newUserModel.appUserData.name == '') {
      customErrorMessage("Error", "Nama Kosong");
      return false;
    }

    if (newUserModel.appUserData.company == null ||
        newUserModel.appUserData.company == '') {
      customErrorMessage("Error", "Perusahaan Kosong");
      return false;
    }
    if (newUserModel.appUserData.email == null ||
        newUserModel.appUserData.email == '') {
      customErrorMessage("Error", "Email Kosong");
      return false;
    }
    if (newUserModel.password == null || newUserModel.password == '') {
      customErrorMessage("Error", "Password Kosong");
      return false;
    }
    if (newUserModel.password.length < 6) {
      customErrorMessage("Error", "Password Minimal 6 Karakter");
      return false;
    }
    if (newUserModel.password != confPassword!) {
      customErrorMessage("Error", "Password tidak sama");
      return false;
    }

    if (!GetUtils.isEmail(newUserModel.appUserData.email!)) {
      customErrorMessage("Error", "Email tidak sesuai format");
      return false;
    }

    return true;
  }
}
