import 'package:flutter/material.dart';

Widget sequenceCircle(int i) {
  return Container(
    height: 20,
    width: 20,
    decoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
    child: Center(
      child: Text(i.toString(), style: TextStyle(color: Colors.white)),
    ),
  );
}
