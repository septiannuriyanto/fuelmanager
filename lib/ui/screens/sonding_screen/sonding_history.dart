import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fuelmanager/ui/screens/sonding_screen/sonding_record.dart';
import 'package:fuelmanager/constant/theme.dart';
import 'package:fuelmanager/ui/screens/sonding_screen/sonding_reports.dart';
import 'package:fuelmanager/widgets/custom_appbar.dart';
import 'package:fuelmanager/widgets/custom_button.dart';
import 'package:fuelmanager/widgets/rrectbutton.dart';
import 'package:get/get.dart';

class SondingHistory extends StatelessWidget {
  const SondingHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          CustomAppBar(title: "Sonding History"),
          Expanded(
              child: Container(
            child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("images").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.size,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: kPrimaryColor.withOpacity(0.5))),
                              child: ListTile(
                                subtitle:
                                    snapshot.data!.docs[index].get('closed') ==
                                            true
                                        ? Text(
                                            'CLOSED',
                                            style: defaultBold.copyWith(
                                                color: Colors.green),
                                          )
                                        : Text(
                                            'OPEN',
                                            style: defaultBold.copyWith(
                                                color: Colors.red),
                                          ),
                                title: Text(snapshot.data!.docs[index].id),
                                trailing: IconButton(
                                    onPressed: () {
                                      Get.to(() => SondingReports(
                                            date: snapshot.data!.docs[index].id,
                                          ));
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: kPrimaryColor,
                                    )),
                              ),
                            ),
                          );
                        }));
                  } else {
                    return const Center(
                      child: Text("No Data"),
                    );
                  }
                }),
          )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomRRButton(
                borderRadius: 12,
                color: kPrimaryColor,
                contentColor: Colors.white,
                title: "Tambah",
                width: Get.width * 0.4,
                onTap: (() => Get.to(() => SondingRecord()))),
          ),
        ],
      ),
    );
  }
}
