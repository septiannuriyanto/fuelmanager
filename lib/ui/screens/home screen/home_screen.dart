import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fuelmanager/constant/menu_list.dart';
import 'package:fuelmanager/constant/theme.dart';
import 'package:fuelmanager/functions/secrets.dart';
import 'package:fuelmanager/models/user_model.dart';
import 'package:fuelmanager/models/versions_model.dart';
import 'package:fuelmanager/services/fcm.dart';
import 'package:fuelmanager/services/image_uploader.dart';
import 'package:fuelmanager/ui/dialog/update_version_dialog.dart';
import 'package:fuelmanager/ui/screens/approveuser_screen/approveuser_screen.dart';
import 'package:fuelmanager/ui/screens/loading_screen.dart';
import 'package:fuelmanager/ui/screens/splash_screen/splash_screen.dart';
import 'package:fuelmanager/utils/image_handler.dart';
import 'package:fuelmanager/utils/styler.dart';
import 'package:fuelmanager/widgets/custom_appbar.dart';
import 'package:fuelmanager/widgets/custom_button.dart';
import 'package:fuelmanager/widgets/photo_container/photo_container.dart';
import 'package:fuelmanager/widgets/photo_container/photo_zoom.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../dialog/loader_dialog.dart';

class HomeScreen extends StatefulWidget {
  AppUserCredential? appUserCredential;
  AppUserData? appUserData;

  HomeScreen({
    Key? key,
    required this.appUserCredential,
    required this.appUserData,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SharedPreferences? prefs;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoaded = false;
  List<bool> receivingVisibility = [];
  List<bool> storingVisibility = [];
  List<bool> issuingVisibility = [];

  @override
  void initState() {
    // TODO: implement initState
    // receivingVisibility.add(ap)
    super.initState();
    getCredentials();
  }

  getCredentials() async {
    prefs = await SharedPreferences.getInstance();

    //adding visibility for receiving menu
    receivingVisibility.add(widget.appUserCredential!.sonding_fs);
    receivingVisibility.add(widget.appUserCredential!.ritasi_fs);

    //adding visibility for storing menu
    storingVisibility.add(widget.appUserCredential!.filter_replace);
    storingVisibility.add(widget.appUserCredential!.inspeksi_infra);
    storingVisibility.add(widget.appUserCredential!.stock_taking);

    //adding visibility for issuing menu
    issuingVisibility.add(widget.appUserCredential!.request_ext);
    issuingVisibility.add(widget.appUserCredential!.ft_readiness);
    issuingVisibility.add(widget.appUserCredential!.daily_report);

    // print(widget.appUserData!.ID!);

    String token = await prefs!.getString('dToken')!;

    // final mapOf = HashMap.of({"token": token, "timestamp": DateTime.now()});

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.appUserData!.ID!)
        .update({'dToken': token});
    isLoaded = true;
    setState(() {});
  }

  logOut() async {
    LoaderDialog.showLoadingDialog('Logging Out');
    prefs ?? await prefs!.clear();
    await prefs!.setBool('isLoggedIn', false);
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => SplashScreen());
  }

  @override
  Widget build(BuildContext context) {
    //--------------------------------------------------------------------------
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('versions').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          } else {
            if (snapshot.hasData) {
              final verDS = snapshot.data!.docs.last;
              Versions newestVer = Versions.fromDocumentSnapshot(verDS);
              int version = (newestVer.major * 100) +
                  (newestVer.minor * 10) +
                  newestVer.patch;
              if (version > APP_VER)
                return Scaffold(
                  body: UpdateVersionDialog(ver: newestVer),
                );
              return Visibility(
                visible: isLoaded,
                replacement: LoadingScreen(),
                child: Scaffold(
                  key: _key,
                  drawer: Drawer(
                    backgroundColor: kThirdColor,
                    child: buildDrawer(),
                  ),
                  body: Column(
                    children: [
                      CustomAppBar(
                        appbarType: AppbarType.home,
                        title: "Fuel Manager App",
                        leadingButton: null,
                        onLeadingPressed: () async {
                          //logOut();
                          _key.currentState!.openDrawer();
                        },
                      ),
                      Expanded(
                          child: Container(
                        width: Get.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: widget.appUserData != null
                                    ? Text(
                                        "Welcome, ${widget.appUserData!.name}",
                                        style: defaultBold,
                                      )
                                    : Text("Welcome, User",
                                        style: defaultBold)),
                            widget.appUserData != null
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child:
                                        Text('${widget.appUserData!.company}'),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(''),
                                  ),
                            Expanded(
                                child: ListView(
                              children: [
                                Visibility(
                                  visible:
                                      widget.appUserCredential!.receiving_menu,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Container(
                                      height: Get.width * 0.7,
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                          borderRadius: rads(12),
                                          border:
                                              Border.all(color: kPrimaryColor)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Receiving",
                                              style: defaultBold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: Get.width * 0.5,
                                            width: Get.width,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: receivingMenu.length,
                                              itemBuilder: (context, index) {
                                                return Visibility(
                                                  visible: receivingVisibility[
                                                      index],
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: GestureDetector(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors.grey
                                                                  .shade100,
                                                              borderRadius:
                                                                  rads(12),
                                                              boxShadow:
                                                                  subtleShadow),
                                                          height: 100,
                                                          width: 100,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                rads(12),
                                                            child: Column(
                                                              children: [
                                                                Expanded(
                                                                    flex: 3,
                                                                    child: receivingMenu[index]
                                                                            .img ??
                                                                        Container(
                                                                          color:
                                                                              kSecondaryColor,
                                                                          child:
                                                                              receivingMenu[index].img,
                                                                        )),
                                                                Expanded(
                                                                    child:
                                                                        Container(
                                                                  color:
                                                                      kThirdColor,
                                                                  child: Center(
                                                                    child: Text(
                                                                      receivingMenu[
                                                                              index]
                                                                          .desc!,
                                                                      style: txt12.copyWith(
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                )),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        onTap:
                                                            receivingMenu[index]
                                                                .ontap),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      widget.appUserCredential!.storing_menu,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Container(
                                      height: Get.width * 0.7,
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                          borderRadius: rads(12),
                                          border:
                                              Border.all(color: kPrimaryColor)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Storing",
                                              style: defaultBold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: Get.width * 0.5,
                                            width: Get.width,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: storingMenu.length,
                                              itemBuilder: (context, index) {
                                                return Visibility(
                                                  visible:
                                                      storingVisibility[index],
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: GestureDetector(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors.grey
                                                                  .shade100,
                                                              borderRadius:
                                                                  rads(12),
                                                              boxShadow:
                                                                  subtleShadow),
                                                          height: 100,
                                                          width: 100,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                rads(12),
                                                            child: Column(
                                                              children: [
                                                                Expanded(
                                                                    flex: 3,
                                                                    child: storingMenu[index]
                                                                            .img ??
                                                                        Container(
                                                                          color:
                                                                              kSecondaryColor,
                                                                          child:
                                                                              storingMenu[index].img,
                                                                        )),
                                                                Expanded(
                                                                    child:
                                                                        Container(
                                                                  color:
                                                                      kThirdColor,
                                                                  child: Center(
                                                                    child: Text(
                                                                      storingMenu[
                                                                              index]
                                                                          .desc!,
                                                                      style: txt12.copyWith(
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                )),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        onTap:
                                                            storingMenu[index]
                                                                .ontap),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      widget.appUserCredential!.issuing_menu,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Container(
                                      height: Get.width * 0.7,
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                          borderRadius: rads(12),
                                          border:
                                              Border.all(color: kPrimaryColor)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Issuing",
                                              style: defaultBold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: Get.width * 0.5,
                                            width: Get.width,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: issuingMenu.length,
                                              itemBuilder: (context, index) {
                                                return Visibility(
                                                  visible:
                                                      issuingVisibility[index],
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: GestureDetector(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors.grey
                                                                  .shade100,
                                                              borderRadius:
                                                                  rads(12),
                                                              boxShadow:
                                                                  subtleShadow),
                                                          height: 100,
                                                          width: 100,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                rads(12),
                                                            child: Column(
                                                              children: [
                                                                Expanded(
                                                                    flex: 3,
                                                                    child: issuingMenu[index]
                                                                            .img ??
                                                                        Container(
                                                                          color:
                                                                              kSecondaryColor,
                                                                          child:
                                                                              issuingMenu[index].img,
                                                                        )),
                                                                Expanded(
                                                                    child:
                                                                        Container(
                                                                  color:
                                                                      kThirdColor,
                                                                  child: Center(
                                                                    child: Text(
                                                                      issuingMenu[
                                                                              index]
                                                                          .desc!,
                                                                      style: txt12.copyWith(
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                )),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        onTap:
                                                            issuingMenu[index]
                                                                .ontap),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ))
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              );
            } else {
              return Scaffold(
                body: Center(
                  child: Text('No Data Available'),
                ),
              );
            }
          }
        });
  }

  Widget buildDrawer() {
    String name = widget.appUserData!.name!;
    String alias = '';
    if (name.contains(' ')) {
      List<String> nameSeparation = name.split(' ');

      var init1 = nameSeparation[0].substring(0, 1).toUpperCase();
      var init2 = nameSeparation[1].substring(0, 1).toUpperCase();
      alias = '$init1$init2';
      if (nameSeparation.length == 3) {
        var init3 = nameSeparation[2].substring(0, 1).toUpperCase();
        alias = '$alias$init3';
      }
    } else {
      alias = name.substring(0, 2);
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.appUserData!.ID)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  return Container(
                    width: Get.width,
                    height: 100,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: snapshot.data!.get('image').toString().isEmpty
                          ? Stack(
                              children: [
                                CircleAvatar(
                                  backgroundColor: kThirdColor,
                                  child: Text(alias),
                                  radius: 30,
                                  foregroundColor: kPrimaryColor,
                                ),
                                GestureDetector(
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Center(
                                        child: Icon(
                                          Icons.edit,
                                          size: 12,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    File? file = await selectImage(context);
                                    if (file != null) {
                                      final strimgurl =
                                          await ImageUploader.uploadProfileImg(
                                        file,
                                        widget.appUserData!.ID!,
                                      );
                                      file.delete();
                                      widget.appUserData!.ID != strimgurl;
                                      setState(() {});
                                    }
                                  },
                                )
                              ],
                            )
                          : Container(
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              height: 40,
                              width: 40,
                              child: PhotoContainer(
                                imageProvider: NetworkImage(
                                  snapshot.data!.get('image'),
                                ),
                                height: 40,
                                // width: 40,
                              ),
                            ),
                    ),
                  );
                }),

            Divider(),

            //admin menu
            Visibility(
              visible: widget.appUserCredential!.admin_menu,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(
                      8.0,
                    ),
                    child: Text(
                      "Administrator Menu",
                      style: defaultBold,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CustomRRButton(
                        borderRadius: 12,
                        color: kSecondaryColor,
                        contentColor: kPrimaryColor,
                        title: "Approve Registration",
                        width: Get.width * 0.75,
                        onTap: () {
                          _key.currentState!.closeDrawer();
                          Get.to(() => ApproveUserScreen());
                        }),
                  ),
                  Divider(),
                ],
              ),
              replacement: Container(),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomRRButton(
                  borderRadius: 12,
                  color: kSecondaryColor,
                  contentColor: Colors.red,
                  title: "Sign out",
                  width: Get.width * 0.75,
                  onTap: () => logOut()),
            )
          ],
        ),
      ),
    );
  }
}
