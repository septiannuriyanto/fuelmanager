import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fuelmanager/constant/menu_list.dart';
import 'package:fuelmanager/constant/theme.dart';
import 'package:fuelmanager/models/user_model.dart';
import 'package:fuelmanager/ui/screens/approveuser_screen/approveuser_screen.dart';
import 'package:fuelmanager/ui/screens/splash_screen/splash_screen.dart';
import 'package:fuelmanager/utils/styler.dart';
import 'package:fuelmanager/widgets/custom_appbar.dart';
import 'package:fuelmanager/widgets/custom_button.dart';
import 'package:fuelmanager/widgets/custom_loading.dart';
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
  List<bool> menuVisibility = [];

  @override
  void initState() {
    menuVisibility.add(widget.appUserCredential!.sonding_fs!);
    menuVisibility.add(widget.appUserCredential!.request_ext!);
    menuVisibility.add(widget.appUserCredential!.receive_do!);
    menuVisibility.add(widget.appUserCredential!.filter_replace!);
    // TODO: implement initState
    super.initState();
    getCredentials();

    Future.delayed(const Duration(seconds: 2)).then(
      (value) {
        setState(() {
          // isLoaded = true;
        });
      },
    );
  }

  getCredentials() async {
    prefs = await SharedPreferences.getInstance();
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
    return Scaffold(
      key: _key,
      drawer: Drawer(
        backgroundColor: kThirdColor,
        child: buildWidget(),
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
                        : Text("Welcome, User", style: defaultBold)),
                widget.appUserData != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text('${widget.appUserData!.company}'),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(''),
                      ),
                Expanded(
                    child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: Get.width * 0.7,
                        width: Get.width,
                        decoration: BoxDecoration(
                            borderRadius: rads(12),
                            border: Border.all(color: kPrimaryColor)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                    visible: menuVisibility[index],
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                borderRadius: rads(12),
                                                boxShadow: subtleShadow),
                                            height: 100,
                                            width: 100,
                                            child: ClipRRect(
                                              borderRadius: rads(12),
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                      flex: 3,
                                                      child:
                                                          receivingMenu[index]
                                                                  .img ??
                                                              Container(
                                                                color:
                                                                    kSecondaryColor,
                                                                child:
                                                                    receivingMenu[
                                                                            index]
                                                                        .img,
                                                              )),
                                                  Expanded(
                                                      child: Container(
                                                    color: kThirdColor,
                                                    child: Center(
                                                      child: Text(
                                                        receivingMenu[index]
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
                                          onTap: receivingMenu[index].ontap),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: Get.width * 0.7,
                        width: Get.width,
                        decoration: BoxDecoration(
                            borderRadius: rads(12),
                            border: Border.all(color: kPrimaryColor)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                    visible: menuVisibility[index],
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                borderRadius: rads(12),
                                                boxShadow: subtleShadow),
                                            height: 100,
                                            width: 100,
                                            child: ClipRRect(
                                              borderRadius: rads(12),
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                      flex: 3,
                                                      child: storingMenu[index]
                                                              .img ??
                                                          Container(
                                                            color:
                                                                kSecondaryColor,
                                                            child: storingMenu[
                                                                    index]
                                                                .img,
                                                          )),
                                                  Expanded(
                                                      child: Container(
                                                    color: kThirdColor,
                                                    child: Center(
                                                      child: Text(
                                                        storingMenu[index]
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
                                          onTap: storingMenu[index].ontap),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: Get.width * 0.7,
                        width: Get.width,
                        decoration: BoxDecoration(
                            borderRadius: rads(12),
                            border: Border.all(color: kPrimaryColor)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                    visible: menuVisibility[index],
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                borderRadius: rads(12),
                                                boxShadow: subtleShadow),
                                            height: 100,
                                            width: 100,
                                            child: ClipRRect(
                                              borderRadius: rads(12),
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                      flex: 3,
                                                      child: issuingMenu[index]
                                                              .img ??
                                                          Container(
                                                            color:
                                                                kSecondaryColor,
                                                            child: issuingMenu[
                                                                    index]
                                                                .img,
                                                          )),
                                                  Expanded(
                                                      child: Container(
                                                    color: kThirdColor,
                                                    child: Center(
                                                      child: Text(
                                                        issuingMenu[index]
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
                                          onTap: issuingMenu[index].ontap),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
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
    );
  }

  Widget buildWidget() {
    return ListView(
      children: [
        Container(
          width: Get.width,
          height: 100,
          decoration: BoxDecoration(
            color: kPrimaryColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: kThirdColor,
              child: Text("NA"),
              radius: 30,
              foregroundColor: kPrimaryColor,
            ),
          ),
        ),

        Divider(),

        //admin menu
        Visibility(
          visible: true,
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
    );
  }
}
