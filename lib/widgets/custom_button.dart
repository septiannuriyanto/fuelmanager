import 'package:flutter/material.dart';

import '../constant/theme.dart';

class CustomRRButton extends StatelessWidget {
  VoidCallback? onTap;
  double? height;
  double width;
  String title;
  Color? color;
  Color? splashColor;
  IconData? icon;
  double? borderRadius;
  Color? contentColor;
  Color? outlineColor;
  bool? enabled;

  CustomRRButton(
      {required this.title,
      required this.width,
      required this.onTap,
      this.enabled,
      this.icon,
      this.height,
      this.color,
      this.contentColor,
      this.splashColor,
      this.borderRadius,
      this.outlineColor});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius:
            BorderRadius.circular(borderRadius == null ? 0 : borderRadius!),
        child: Material(
          child: InkWell(
            enableFeedback: enabled,
            splashColor: splashColor ?? Colors.white,
            onTap: enabled == false ? null : onTap,
            child: Ink(
              height: height ?? 40,
              width: width,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: outlineColor == null
                          ? Colors.transparent
                          : outlineColor!),
                  color: enabled == false
                      ? Colors.grey.shade600
                      : color ?? Colors.grey.shade600,
                  borderRadius: BorderRadius.all(Radius.circular(
                      borderRadius == null ? 0 : borderRadius!))),
              child: icon == null
                  ? Center(
                      child: Text(
                        title,
                        style: defaultBold.copyWith(
                            color:
                                enabled == false ? Colors.black : contentColor),
                      ),
                    )
                  : Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            icon!,
                            color: contentColor,
                          ),
                          Text(
                            title,
                            style: defaultBold.copyWith(
                                color: contentColor ?? Colors.black),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ));
  }
}

Widget NeumorphicFingerPrint({
  IconData? iconData,
  VoidCallback? onClicked,
}) {
  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.grey.shade300,
      boxShadow: [
        BoxShadow(
            color: Colors.grey.shade900,
            offset: Offset(4, 4),
            blurRadius: 15,
            spreadRadius: 1),
        const BoxShadow(
            color: Colors.white,
            offset: Offset(-4, -4),
            blurRadius: 15,
            spreadRadius: 1),
      ],
      gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade200,
            Colors.grey.shade300,
            Colors.grey.shade400,
            Colors.grey.shade900,
          ],
          stops: const [
            0.1,
            0.4,
            0.8,
            1
          ]),
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: IconButton(
        icon: Icon(iconData),
        onPressed: onClicked,
      ),
    ),
  );
}
