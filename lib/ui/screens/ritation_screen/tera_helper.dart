import 'dart:ffi';

import 'package:fuelmanager/functions/secrets.dart';
import 'package:fuelmanager/models/tera_ft.dart';
import 'package:gsheets/gsheets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<List<Tera>> checkIfTeraAvailable(
    String prefString, String teraSheet, int depthCol, int volCol) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String teraFromSharedPrefs = prefs.getString(prefString) ?? '';
  List<Tera> thisTera;

  if (teraFromSharedPrefs.isEmpty) {
    print('Tera is not present, downloading......');
    //download tera table from server
    thisTera = await getTeraFrom(teraSheet, depthCol, volCol);
    //encode to JSON String
    String newTera = encode(thisTera);
    //save to sharedpreferences
    await prefs.setString(prefString, newTera);
  } else {
    thisTera = decode(teraFromSharedPrefs);
    print('Tera is alreaded saved');
  }

  return thisTera;
}

String encode(List<Tera> tera) => json.encode(
      tera.map<Map<String, dynamic>>((tera) => Tera.toMap(tera)).toList(),
    );
List<Tera> decode(String tera) => (json.decode(tera) as List<dynamic>)
    .map<Tera>((item) => Tera.fromJson(item))
    .toList();

Future<List<Tera>> getTeraFrom(
    String SheetName, int depthColumn, int volColumn) async {
  final gsheets = GSheets(credentials);
  final ss = await gsheets.spreadsheet(fuelManagerSheet);
  var sheet = ss.worksheetByTitle(SheetName);
  final tera = await sheet!.values.allRows(fromRow: 2);

  return List.generate(
      tera.length,
      (index) => Tera(
            depth: tera[index][depthColumn],
            qty: tera[index][volColumn],
          ));
}

double convertToLiter(String depth, List<Tera> TeraTable) {
  double resultLiter = 0;
  List<String> col1 = [];
  List<String> col2 = [];
  double sonding = 0;
  String sondingX1 = "", sondingX2 = "";
  int index = 0;
  int x1 = 0;
  int x2 = 0;
  double y = 0, y1 = 0, y2 = 0;

  if (depth == "") {
    return 0;
  } else {
    sonding = double.parse(depth);
    if (sonding % 1 == 0) {
      print('genap');
      x1 = sonding.floor();
      x2 = sonding.ceil();
      sondingX1 = x1.toString();
      sondingX2 = x2.toString();

      for (int i = 0; i < TeraTable.length; i++) {
        col1.add(TeraTable[i].depth);
        col2.add(TeraTable[i].qty);
      }
      index = col1.indexWhere((element) => element == sondingX1);
      y1 = double.parse(col2[index]);
      resultLiter = y1;
    } else {
      print('ganjil');
      x1 = sonding.floor();
      x2 = sonding.ceil();
      sondingX1 = x1.toString();
      sondingX2 = x2.toString();

      for (int i = 0; i < TeraTable.length; i++) {
        col1.add(TeraTable[i].depth);
        col2.add(TeraTable[i].qty);
      }

      index = col1.indexWhere((element) => element == sondingX1);
      y1 = double.parse(col2[index]);
      index = col1.indexWhere((element) => element == sondingX2);
      y2 = double.parse(col2[index]);

      y = y1 + (sonding - x1) * ((y2 - y1) / (x2 - x1));
      resultLiter = y;
    }
  }

//<><><><><><><><><><><><><><><><><><>
  return resultLiter;
}
