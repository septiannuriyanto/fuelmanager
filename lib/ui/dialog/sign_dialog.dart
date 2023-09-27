import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuelmanager/constant/theme.dart';
import 'package:fuelmanager/widgets/custom_snackbar.dart';
import 'package:hand_signature/signature.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignDialog extends StatefulWidget {
  String nrp;
  String yesCommand;
  String name;
  String message;

  SignDialog({
    Key? key,
    required this.nrp,
    required this.yesCommand,
    required this.name,
    required this.message,
  }) : super(key: key);

  @override
  State<SignDialog> createState() => _SignDialogState();
}

class _SignDialogState extends State<SignDialog> {
  SharedPreferences? prefs;
  SvgPicture? svgSignature;
  ValueNotifier<String?> svg = ValueNotifier<String?>(null);
  bool confirmationVisibility = true;
  final control = HandSignatureControl(
    threshold: 3.0,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );

  @override
  void initState() {
    // TODO: implement initState
    asyncProcedures();
    super.initState();
  }

  asyncProcedures() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<DocumentSnapshot> documents = [];
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.width * 1.3,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(24))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Center(
                        child: Container(
                          color: Colors.grey[350],
                          height: MediaQuery.of(context).size.width * 0.8,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: HandSignature(
                            control: control,
                            color: Colors.blueGrey,
                            width: 1,
                            maxWidth: 10.0,
                            type: SignatureDrawType.shape,
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.grey,
                        height: MediaQuery.of(context).size.width * 0.1,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Center(
                            child: Text('${widget.name}, NRP : ${widget.nrp}')),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          color: Colors.grey[350],
                          child: Center(
                              child: Material(
                            child: Ink(
                              height: MediaQuery.of(context).size.width * 0.1,
                              width: MediaQuery.of(context).size.width * 0.1,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                              ),
                              child: InkWell(
                                splashColor: Colors.white,
                                onTap: () {
                                  control.clear();
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Container(
                    color: Colors.amber,
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Text(
                        widget.message,
                        style: const TextStyle(fontSize: 10),
                      )),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        color: kPrimaryColor,
                        height: 40,
                        width: 100,
                        child: Material(
                            child: Ink(
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: InkWell(
                                  splashColor: Colors.white,
                                  onTap: () async {
                                    svg.value = control.toSvg(
                                      color: Colors.blueGrey,
                                      strokeWidth: 2.0,
                                      maxStrokeWidth: 15.0,
                                      type: SignatureDrawType.shape,
                                    );
                                    if (svg.value != null) {
                                      Navigator.pop(context, svg.value);
                                    } else {
                                      customErrorMessage("No Signature",
                                          "Mohon isi tanda tangan");
                                    }
                                  },
                                  child: Center(
                                      child: Text(
                                    widget.yesCommand,
                                    style: const TextStyle(color: Colors.white),
                                  )),
                                )))),
                    Container(
                      color: Colors.grey,
                      height: 40,
                      width: 100,
                      child: Material(
                        child: Ink(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: InkWell(
                            splashColor: Colors.white,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Center(
                                child: Text(
                              'Back',
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
