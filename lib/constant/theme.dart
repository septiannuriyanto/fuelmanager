import 'package:flutter/material.dart';
import 'package:get/get.dart';
//COLORS DATA===================================================================

//colors
final Color kBackgroundColor = kThirdColor; // HexColor('f8f7fe');
final Color kPrimaryColor = HexColor('824717');
final kSecondaryColor = HexColor('f0d2ac');
final kThirdColor = HexColor('fff1e6');
final Color kTextColor = HexColor('000000');
final Color kBlack = HexColor('000000');
final Color kWhite = HexColor('ffffff');

//padding
const double kDefaultPadding = 16;

//MAIN THEME FOR APP============================================================

ThemeData getAppTheme(BuildContext context) {
  return ThemeData(
    scaffoldBackgroundColor: kBackgroundColor,
    textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
    fontFamily: "Poppins",
    primaryColor: kPrimaryColor,
  );
}

//==============================================================================

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

TextStyle defaultBold = const TextStyle(fontWeight: FontWeight.w800);
TextStyle greyTxt = TextStyle(color: Colors.grey.shade400);
TextStyle txt10 = const TextStyle(fontSize: 10);
TextStyle txt11 = const TextStyle(fontSize: 11);
TextStyle txt12 = const TextStyle(fontSize: 12);
TextStyle txt13 = const TextStyle(fontSize: 13);
TextStyle txt14 = const TextStyle(fontSize: 14);
TextStyle txt15 = const TextStyle(fontSize: 15);
TextStyle txt16 = const TextStyle(fontSize: 16);
TextStyle txt17 = const TextStyle(fontSize: 17);

final TokpedGreen = HexColor('19B715');
final TokpedDarkGreen = HexColor('128a3c');

final shadowPanel = [
  BoxShadow(
    color: Colors.grey.shade600,
    spreadRadius: 1,
    blurRadius: 5,
    offset: const Offset(0, 5),
  ),
  // BoxShadow(
  //   color: Colors.grey.shade300,
  //   offset: const Offset(-5, 0),
  // )
];

final subtleShadow = [
  BoxShadow(
    color: kPrimaryColor, //HexColor('9F9F9F'),
    spreadRadius: 1,
    blurRadius: 50,
    offset: const Offset(1, 20),
  ),
];

Color themeBlue = const Color.fromARGB(255, 37, 81, 155);
Color themeDarkBlue = const Color.fromARGB(255, 43, 42, 106);

InputDecoration kTextFieldDecoration = InputDecoration(
    hintText: 'Enter a value',
    hintStyle: TextStyle(color: Colors.grey),
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ));

LinearGradient gradientLightBlueWhite = LinearGradient(
  colors: [
    Colors.white,
    Colors.lightBlue.shade100,
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const IconData FingerprintIcon = IconData(0xe287, fontFamily: 'MaterialIcons');
