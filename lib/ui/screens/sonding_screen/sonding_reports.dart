import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fuelmanager/constant/theme.dart';
import 'package:fuelmanager/utils/styler.dart';
import 'package:fuelmanager/widgets/custom_appbar.dart';
import 'package:fuelmanager/widgets/photo_container/photo_container.dart';
import 'package:get/get.dart';

import '../../../utils/datetime_handler.dart';

class SondingReports extends StatelessWidget {
  String date;

  SondingReports({required this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
              title: "Review Sonding Report ${convertToIndDate(date)}"),
          Expanded(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('images')
                      .doc(date)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                  border: Border.all(color: kPrimaryColor)),
                              child: Column(
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Awal Shift",
                                        style: defaultBold,
                                      ),
                                    ),
                                  ),
                                  ContentRow(
                                    color: kSecondaryColor,
                                    title: "Sonding Awal 1st",
                                    fillType: FillType.outlined,
                                    desc:
                                        '${snapshot.data!.get('awal1_depth')} cm',
                                  ),
                                  ContentRow(
                                    color: kSecondaryColor,
                                    title: "Sonding Awal 2nd",
                                    fillType: FillType.outlined,
                                    desc:
                                        '${snapshot.data!.get('awal2_depth')} cm',
                                  ),
                                  ContentRow(
                                    color: kSecondaryColor,
                                    title: "Sonding Awal 3rd",
                                    fillType: FillType.outlined,
                                    desc:
                                        '${snapshot.data!.get('awal3_depth')} cm',
                                  ),
                                  ContentRow(
                                    color: kSecondaryColor,
                                    title: "Sonding Awal Average",
                                    fillType: FillType.filled,
                                    desc:
                                        '${snapshot.data!.get('awalavg_depth')} cm',
                                  ),
                                  ContentRow(
                                    color: kSecondaryColor,
                                    title: "Qty Awal",
                                    fillType: FillType.filled,
                                    desc:
                                        '${snapshot.data!.get('qty_awal')} liter',
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          color: kPrimaryColor,
                                          height: Get.width * 0.2,
                                          width: Get.width * 0.2,
                                          child: PhotoContainer(
                                            height: Get.width * 0.2,
                                            imageProvider: NetworkImage(snapshot
                                                .data!
                                                .get('awal1_img')),
                                          ),
                                        ),
                                        Container(
                                          color: kPrimaryColor,
                                          height: Get.width * 0.2,
                                          width: Get.width * 0.2,
                                          child: PhotoContainer(
                                            height: Get.width * 0.2,
                                            imageProvider: NetworkImage(snapshot
                                                .data!
                                                .get('awal2_img')),
                                          ),
                                        ),
                                        Container(
                                          color: kPrimaryColor,
                                          height: Get.width * 0.2,
                                          width: Get.width * 0.2,
                                          child: PhotoContainer(
                                            height: Get.width * 0.2,
                                            imageProvider: NetworkImage(snapshot
                                                .data!
                                                .get('awal3_img')),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                        'Stock Taker : ${snapshot.data!.get('stocktaker')}'),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          //Data Akhir Shift

                          snapshot.data!.get('closed') == true
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: kPrimaryColor)),
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Akhir Shift",
                                              style: defaultBold,
                                            ),
                                          ),
                                        ),
                                        ContentRow(
                                          color: kSecondaryColor,
                                          title: "Sonding Akhir 1st",
                                          fillType: FillType.outlined,
                                          desc:
                                              '${snapshot.data!.get('akhir1_depth')} cm',
                                        ),
                                        ContentRow(
                                          color: kSecondaryColor,
                                          title: "Sonding Akhir 2nd",
                                          fillType: FillType.outlined,
                                          desc:
                                              '${snapshot.data!.get('akhir2_depth')} cm',
                                        ),
                                        ContentRow(
                                          color: kSecondaryColor,
                                          title: "Sonding Akhir 3rd",
                                          fillType: FillType.outlined,
                                          desc:
                                              '${snapshot.data!.get('akhir3_depth')} cm',
                                        ),
                                        ContentRow(
                                          color: kSecondaryColor,
                                          title: "Sonding Akhir Average",
                                          fillType: FillType.filled,
                                          desc:
                                              '${snapshot.data!.get('akhiravg_depth')} cm',
                                        ),
                                        ContentRow(
                                          color: kSecondaryColor,
                                          title: "Qty Akhir",
                                          fillType: FillType.filled,
                                          desc:
                                              '${snapshot.data!.get('qty_akhir')} liter',
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                color: kPrimaryColor,
                                                height: Get.width * 0.2,
                                                width: Get.width * 0.2,
                                                child: PhotoContainer(
                                                  height: Get.width * 0.2,
                                                  imageProvider: NetworkImage(
                                                      snapshot.data!
                                                          .get('akhir1_img')),
                                                ),
                                              ),
                                              Container(
                                                color: kPrimaryColor,
                                                height: Get.width * 0.2,
                                                width: Get.width * 0.2,
                                                child: PhotoContainer(
                                                  height: Get.width * 0.2,
                                                  imageProvider: NetworkImage(
                                                      snapshot.data!
                                                          .get('akhir2_img')),
                                                ),
                                              ),
                                              Container(
                                                color: kPrimaryColor,
                                                height: Get.width * 0.2,
                                                width: Get.width * 0.2,
                                                child: PhotoContainer(
                                                  height: Get.width * 0.2,
                                                  imageProvider: NetworkImage(
                                                      snapshot.data!
                                                          .get('akhir3_img')),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Text(
                                              'Stock Taker : ${snapshot.data!.get('stocktaker')}'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ContentRow(
                                              contentColor: Colors.white,
                                              fillType: FillType.filled,
                                              color: kPrimaryColor,
                                              desc:
                                                  '${snapshot.data!.get('qty_usage')} liter',
                                              title: "Qty Usage Final"),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Text(
                                  "Stock Taking Belum Closing",
                                  style: defaultBold,
                                ))
                        ],
                      );
                    } else {
                      return Container(
                        child: Text("No Data"),
                      );
                    }
                  }),
            ),
          ))
        ],
      ),
    );
  }
}

enum FillType {
  filled,
  outlined,
}

class ContentRow extends StatelessWidget {
  FillType fillType;
  String title;
  String desc;
  Color color;
  Color? contentColor;

  ContentRow(
      {required this.fillType,
      required this.color,
      required this.desc,
      required this.title,
      this.contentColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: Get.width,
        height: 40,
        decoration: fillType == FillType.outlined
            ? BoxDecoration(
                borderRadius: rads(12),
                border: Border.all(color: kSecondaryColor),
              )
            : BoxDecoration(
                borderRadius: rads(12),
                color: color,
              ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(title,
                  style: contentColor != null
                      ? TextStyle(color: contentColor)
                      : TextStyle(color: Colors.black)),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Text(desc,
                  style: contentColor != null
                      ? TextStyle(color: contentColor)
                      : TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
