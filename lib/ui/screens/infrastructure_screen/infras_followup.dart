import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fuelmanager/functions/secrets.dart';
import 'package:fuelmanager/models/infrastructure_findings.dart';
import 'package:fuelmanager/services/image_uploader.dart';
import 'package:fuelmanager/ui/dialog/loader_dialog.dart';
import 'package:fuelmanager/utils/datetime_handler.dart';
import 'package:fuelmanager/utils/image_handler.dart';
import 'package:fuelmanager/utils/styler.dart';
import 'package:fuelmanager/widgets/custom_button.dart';
import 'package:fuelmanager/widgets/custom_snackbar.dart';
import 'package:fuelmanager/widgets/photo_container/photo_container.dart';
import 'package:gsheets/gsheets.dart';
import 'package:path/path.dart' as p;

class InfrasFollowup extends StatefulWidget {
  InfrasFollowup(
      {required this.infrasFindings, required this.findingKey, super.key});

  InfrastructureFindings findingKey;
  List<InfrastructureFindings> infrasFindings;

  @override
  State<InfrasFollowup> createState() => _InfrasFollowupState();
}

class _InfrasFollowupState extends State<InfrasFollowup> {
  String? imgUrl;

  ImageProvider? followup_img;
  File? followup_file;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(widget.findingKey.findingEvidence);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Column(
                    children: [
                      Text(
                        "Follow up Temuan",
                        style: sfbs(20),
                      ),
                      spc(24),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('Unit'),
                            ),
                            Expanded(
                              child: Text(': ${widget.findingKey.unit}'),
                            ),
                          ],
                        ),
                      ),
                      //==========================================================

                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('Status'),
                            ),
                            Expanded(
                              child: Text(': ${widget.findingKey.status}'),
                            ),
                          ],
                        ),
                      ),
                      //==========================================================
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('Open Date'),
                            ),
                            Expanded(
                              child: Text(': ${widget.findingKey.openDate}'),
                            ),
                          ],
                        ),
                      ),
                      //==========================================================
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('Due Date'),
                            ),
                            Expanded(
                              child: Text(': ${widget.findingKey.duedate}'),
                            ),
                          ],
                        ),
                      ),
                      //==========================================================
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('PIC'),
                            ),
                            Expanded(
                              child: Text(': ${widget.findingKey.pic}'),
                            ),
                          ],
                        ),
                      ),
                      //==========================================================
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('Description'),
                            ),
                            Expanded(
                              child: Text(': ${widget.findingKey.description}'),
                            ),
                          ],
                        ),
                      ),
                      //==========================================================
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('Root Cause'),
                            ),
                            Expanded(
                              child: Text(': ${widget.findingKey.cause}'),
                            ),
                          ],
                        ),
                      ),
                      //==========================================================
                      spc(24),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: size.width * 0.4,
                          height: size.width * 0.4,
                          decoration: barr(context, 12),
                          child: ClipRRect(
                              borderRadius: rads(12),
                              child: PhotoContainer(
                                  imageProvider: NetworkImage(
                                      widget.findingKey.findingEvidence),
                                  height: size.width * 0.4)),
                        ),
                      ),
                      spc(24),
                      Divider(
                        thickness: 2,
                      ),
                      Text(
                        'Tambahkan Evidence Follow up',
                        style: sfbs(20),
                      ),
                      spc(16),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            decoration: barr(context, 12),
                            height: size.width * 0.4,
                            width: size.width * 0.4,
                            child: followup_img == null
                                ? IconButton(
                                    onPressed: () async {
                                      File? file = await selectImage(context);
                                      if (file != null) {
                                        String dir = p.dirname(file.path);
                                        String newPath = p.join(dir,
                                            '$formattedToday-${widget.findingKey.key}-followup.jpg');
                                        //print(newPath);
                                        followup_file =
                                            await file.copy(newPath);
                                        followup_file!.renameSync(newPath);
                                        // final fileString = Utility.base64string(
                                        //     file.readAsBytesSync());
                                        // await getStore.write('awal1_img', fileString);
                                        followup_img =
                                            MemoryImage(file.readAsBytesSync());
                                        file.delete();
                                        setState(() {});
                                      }
                                    },
                                    icon: Icon(
                                      Icons.add_a_photo_outlined,
                                      color: Theme.of(context).primaryColor,
                                      size: size.width * 0.1,
                                    ))
                                : Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: rads(12),
                                        child: PhotoContainer(
                                            imageProvider: followup_img!,
                                            height: size.width * 0.4),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            followup_file = null;
                                            followup_img = null;
                                            setState(() {});
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.redAccent,
                                              ),
                                              child: Icon(
                                                Icons.clear,
                                                color: Colors.white,
                                              )),
                                        ),
                                      )
                                    ],
                                  )),
                      ),

                      spc(16),

                      Container(
                        child: CustomRRButton(
                          color: Theme.of(context).primaryColor,
                          contentColor: Colors.white,
                          borderRadius: 12,
                          title: "Submit",
                          width: size.width * 0.5,
                          onTap: () async {
                            if (followup_img == null) {
                              customErrorMessage("Error",
                                  "Mohon tambahkan evidence follow up");
                              return;
                            }
                            LoaderDialog.showLoadingDialog("Uploading Data...");
                            int recordRow = 0;
                            for (int i = 0;
                                i < widget.infrasFindings.length;
                                i++) {
                              if (widget.infrasFindings[i].key ==
                                  widget.findingKey.key) {
                                recordRow = i + 2;
                                break;
                              }
                            }

                            imgUrl = await ImageUploader.uploadFinding(
                              followup_file,
                              formattedToday,
                              widget.findingKey.unit,
                            );

                            print(imgUrl);

                            final gsheets = GSheets(credentials);
                            final ss = await gsheets.spreadsheet(confisSheet);
                            var sheet = ss.worksheetByTitle('Findings');
                            final cells =
                                await sheet!.values.allRows(fromRow: 1);
                            // int lastRow = cells.length;
                            // await sheet.values
                            //     .insertRow(lastRow + 1, FilterChange.toGoogleSheet(filterChange));

                            //Update closed date
                            await sheet.values.insertValue(
                                formattedSlashDate(DateTime.now()),
                                column: 12,
                                row: recordRow);

                            //Update closing evidence URL
                            await sheet.values.insertValue(imgUrl!,
                                column: 13, row: recordRow);

                            //Update status to Closed
                            await sheet.values.insertValue("CLOSED",
                                column: 9, row: recordRow);

                            Navigator.pop(context);
                            Navigator.pop(context, "ok");
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
