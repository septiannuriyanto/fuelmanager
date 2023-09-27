import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fuelmanager/constant/theme.dart';
import 'package:fuelmanager/models/user_model.dart';
import 'package:fuelmanager/services/firebase_db.dart';
import 'package:fuelmanager/widgets/custom_appbar.dart';
import 'package:fuelmanager/widgets/custom_button.dart';
import 'package:fuelmanager/widgets/custom_snackbar.dart';
import 'package:fuelmanager/widgets/custom_userapproval.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

class ApproveUserScreen extends StatefulWidget {
  const ApproveUserScreen({super.key});

  @override
  State<ApproveUserScreen> createState() => _ApproveUserScreenState();
}

final newUserStream =
    FirebaseFirestore.instance.collection('new_registrant').snapshots();

final existingUserStream =
    FirebaseFirestore.instance.collection('users').snapshots();

Stream<QuerySnapshot> streamGrp = newUserStream;
String type = "new";

class _ApproveUserScreenState extends State<ApproveUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: "User Management"),
          Expanded(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomRRButton(
                      borderRadius: 12,
                      color: kSecondaryColor,
                      title: "New",
                      width: Get.width * 0.4,
                      onTap: () {
                        setState(() {
                          type = "new";
                          streamGrp = newUserStream;
                        });
                      }),
                  CustomRRButton(
                      borderRadius: 12,
                      color: kSecondaryColor,
                      title: "Existing",
                      width: Get.width * 0.4,
                      onTap: () {
                        setState(() {
                          type = "existing";
                          streamGrp = existingUserStream;
                        });
                      })
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: streamGrp,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.size,
                      itemBuilder: ((context, index) {
                        return CustomUserApprovalForm(
                          type: type,
                          nama: snapshot.data!.docs[index].get('name'),
                          email: snapshot.data!.docs[index].get('email'),
                          uid: snapshot.data!.docs[index].get('username'),
                          company: snapshot.data!.docs[index].get('company'),
                          role: snapshot.data!.docs[index].get('role'),
                          onFirstTap: () async {
                            if (type == "existing") {
                              return;
                            } else {
                              //script registrasi user
                              final status = await Get.dialog(Dialog(
                                backgroundColor: Colors.transparent,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: kThirdColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  width: Get.width,
                                  height: Get.width,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Assign Role",
                                          style: defaultBold,
                                        ),
                                        Expanded(
                                          child: StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('credentials')
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return ListView.builder(
                                                      itemCount:
                                                          snapshot.data!.size,
                                                      itemBuilder:
                                                          ((context, index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: CustomRRButton(
                                                              borderRadius: 12,
                                                              color:
                                                                  kSecondaryColor,
                                                              title: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .id,
                                                              width: Get.width *
                                                                  0.8,
                                                              onTap: () {
                                                                Get.back(
                                                                    result: snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                        .id);
                                                              }),
                                                        );
                                                      }));
                                                } else {
                                                  return Center(
                                                    child: Text('No Data'),
                                                  );
                                                }
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                              if (status != null) {
                                AppUserData newUser = AppUserData(
                                  ID: snapshot.data!.docs[index]
                                      .get('username'),
                                  name: snapshot.data!.docs[index].get('name'),
                                  email:
                                      snapshot.data!.docs[index].get('email'),
                                  company:
                                      snapshot.data!.docs[index].get('company'),
                                  role: status,
                                );
                                String password =
                                    snapshot.data!.docs[index].get('password');

                                //daftarkan di tabel authentikasi
                                try {
                                  FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                          email: newUser.email!,
                                          password: password);
                                } catch (e) {
                                  customErrorMessage(
                                      "Error Auth Registration", e.toString());
                                  return;
                                }

                                //daftarkan di tabel user
                                FirebaseDB.injectUser(newUser);

                                //delete user dari tabel new registrant
                                String deleteWithStatus = await deleteUser(
                                    snapshot.data!.docs[index].get('username'),
                                    type);
                                //----------------------------------------------

                                if (deleteWithStatus == "success") {
                                  setState(() {
                                    customSuccessMessage(
                                        "Success", "Registration Success");
                                  });
                                }
                              }
                            }
                          },
                          onSecondTap: () {
                            if (type == "existing") {
                              Get.defaultDialog(
                                cancelTextColor: Colors.black,
                                confirmTextColor: Colors.white,
                                backgroundColor: kThirdColor,
                                buttonColor: Colors.redAccent,
                                title: "Delete?",
                                middleText:
                                    "Yakin untuk delete user ini?\nPeringatan! ini tidak dapat di undo",
                                onConfirm: () async {
                                  Get.back();

                                  //delete dari tabel authentication

                                  try {
                                    AuthService auth = AuthService();
                                    auth.deleteUser(
                                      snapshot.data!.docs[index]
                                          .get('username'),
                                      "123456",
                                    );
                                  } catch (e) {
                                    customErrorMessage(
                                        "Error Deleting User", e.toString());
                                    return;
                                  }

                                  //delete dari tabel user
                                  String deleteWithStatus = await deleteUser(
                                      snapshot.data!.docs[index]
                                          .get('username'),
                                      type);
                                  if (deleteWithStatus == "success") {
                                    setState(() {
                                      customSuccessMessage(
                                          "Success", "User Delete");
                                    });
                                  }
                                },
                                onCancel: () {},
                              );
                            } else {
                              Get.defaultDialog(
                                cancelTextColor: kPrimaryColor,
                                confirmTextColor: kPrimaryColor,
                                backgroundColor: kThirdColor,
                                buttonColor: kSecondaryColor,
                                title: "Reject?",
                                middleText: "Yakin untuk reject user ini?",
                                onConfirm: () async {
                                  Get.back();
                                  String deleteWithStatus = await deleteUser(
                                      snapshot.data!.docs[index]
                                          .get('username'),
                                      type);
                                  if (deleteWithStatus == "success") {
                                    setState(() {
                                      customSuccessMessage(
                                          "Success", "User Rejected");
                                    });
                                  }
                                },
                                onCancel: () {},
                              );
                            }
                          },
                        );
                      }),
                    );
                  } else {
                    return Center();
                  }
                }),
          ),
        ],
      ),
    );
  }
}

Future<String> deleteUser(String uid, String type) async {
  String dbName;
  type == "new" ? dbName = "new_registrant" : dbName = "users";

  try {
    final id = await FirebaseFirestore.instance
        .collection(dbName)
        .where('username', isEqualTo: uid)
        .snapshots()
        .first
        .then((value) => value.docs.first.id);
    await FirebaseFirestore.instance.collection(dbName).doc(id).delete();
  } catch (e) {
    return e.toString();
  }
  return "success";
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future deleteUser(String email, String password) async {
    try {
      User user = await _auth.currentUser!;
      AuthCredential credentials =
          EmailAuthProvider.credential(email: email, password: password);
      print(user);
      UserCredential result =
          await user.reauthenticateWithCredential(credentials);
      await result.user!.delete();
      return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
