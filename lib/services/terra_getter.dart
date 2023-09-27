import 'package:fuelmanager/functions/global.dart';
import 'package:fuelmanager/services/google_sheet.dart';
import 'package:gsheets/gsheets.dart';

import '../functions/secrets.dart';

Future<List<Tera>> getTera() async {
  String spreadSheetID = "1cDwraoGt_x_2y53LGYZKB-fsx26Eg0H90QJhkbzfTfA";

  final gsheets = GSheets(credentials);
  final ss = await gsheets.spreadsheet(spreadSheetID);
  var sheet = ss.worksheetByTitle('Tera MT BC');

  final tera = await sheet!.values.allRows(fromRow: 2);

  return List.generate(
      tera.length,
      (index) => Tera(
            depth: tera[index][0],
            qty: tera[index][1],
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

class Tera {
  final String depth;
  final String qty;

  Tera({
    required this.depth,
    required this.qty,
  });

  factory Tera.fromJson(Map<String, dynamic> jsonData) {
    return Tera(
      depth: jsonData['Depth'],
      qty: jsonData['Qty'],
    );
  }

  static Map<String, dynamic> toMap(Tera tera) => {
        'Depth': tera.depth,
        'Qty': tera.qty,
      };
}
