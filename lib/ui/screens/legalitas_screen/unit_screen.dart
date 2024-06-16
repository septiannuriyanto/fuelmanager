import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fuelmanager/constant/theme.dart';
import 'package:fuelmanager/ui/screens/loading_screen.dart';
import 'package:fuelmanager/utils/datetime_handler.dart';
import 'package:fuelmanager/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';

import 'addmodify_legal_dialog.dart';

class UnitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('legal_document')
            .where('type', isEqualTo: "SKO")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'This Collection has no Data',
                style: TextStyle(fontSize: 24),
              ),
            );
          }

          List<QueryDocumentSnapshot> snap = snapshot.data!.docs;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: snap.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.white70,
                          child: ListTile(
                            title: Text(
                              snap[index].get('name'),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                                "Valid Until : ${convertToIndDate(DateFormat('yyyyMMdd').format((snap[index].get('valid_until') as Timestamp).toDate()))}"),
                            trailing: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.play_circle_outline_rounded)),
                          ),
                        ),
                      );
                    }),
              ),
              Expanded(
                  flex: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomRRButton(
                        color: kPrimaryColor,
                        contentColor: Colors.white,
                        borderRadius: 12,
                        enabled: true,
                        title: "New",
                        width: Get.width * 0.3,
                        onTap: () {
                          showBottomSheet(
                              context: context,
                              builder: (BuildContext contextt) {
                                return Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  width: Get.width,
                                  child: AddModifyLegalDialog(),
                                );
                              });
                        }),
                  ))
            ],
          );
        });
  }
}
