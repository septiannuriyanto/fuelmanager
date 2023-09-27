import 'package:fuelmanager/models/infrastructure_findings.dart';
import 'package:fuelmanager/utils/datetime_handler.dart';

class InfrastructureItem {
  int id;
  String key;
  String classItem;
  int index;
  String component;
  String itemCheck;
  int weight;
  int actual;

  InfrastructureItem({
    required this.id,
    required this.key,
    required this.classItem,
    required this.index,
    required this.component,
    required this.itemCheck,
    required this.weight,
    required this.actual,
  });

  factory InfrastructureItem.fromJson(List<dynamic> json) {
    return InfrastructureItem(
        id: int.parse(json[0]),
        key: json[1],
        classItem: json[2],
        index: int.parse(json[3]),
        component: json[4],
        itemCheck: json[5],
        weight: int.parse(json[6]),
        actual: int.parse(json[6]));
  }

  static List<dynamic> toGooglesheet(InfrastructureItem infras, DateTime date,
      String period, String unit, String pic) {
    return [
      '${date.year}${monthsInYearShort[date.month - 1]}_$period$unit',
      date.year,
      monthsInYearShort[date.month - 1],
      period,
      unit,
      infras.key,
      infras.weight,
      infras.actual,
      pic
    ];
  }
}

class Infrastructures {
  String unit;
  String storageType;
  List<InfrastructureItem> infrasItem = [];
  List<InfrastructureFindings> infrasFindings = [];

  Infrastructures({
    required this.unit,
    required this.storageType,
  });

  factory Infrastructures.fromJSON(List<dynamic> json) {
    return Infrastructures(
      unit: json[0],
      storageType: json[1],
    );
  }
}
