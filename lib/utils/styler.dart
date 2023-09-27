import 'package:flutter/material.dart';

sfs(double size) {
  return TextStyle(fontSize: size);
}

sfb() {
  return TextStyle(fontWeight: FontWeight.bold);
}

sfbs(double size) {
  return TextStyle(fontWeight: FontWeight.bold, fontSize: size);
}

barr(BuildContext context, double radius) {
  return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      border: Border.all(color: Theme.of(context).primaryColor));
}

rads(double radius) {
  return BorderRadius.all(Radius.circular(radius));
}

bord() {
  Border.all(color: Colors.grey.shade400);
}

spc(double heigt) {
  return SizedBox(
    height: heigt,
  );
}
