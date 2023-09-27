import 'package:flutter/material.dart';

class RRContainer extends StatelessWidget {
  FontWeight fontWeight;
  double width;
  String title;
  Color color;
  IconData? icon;

  RRContainer({
    required this.width,
    required this.title,
    required this.fontWeight,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: width,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(width * 0.04))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Center(
              child: Text(
                title,
                style: TextStyle(fontSize: width * 0.1, fontWeight: fontWeight),
              ),
            ),
          ),
          icon != null ? Expanded(child: Container()) : Container(),
          icon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Icon(
                    icon,
                    size: width * 0.1,
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
