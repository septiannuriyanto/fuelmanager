class FilterPopulation {
  String whCode;
  String location;
  String sc;
  String pn;
  String mnemonic;
  double price;
  double totaliser;
  FilterPopulation({
    required this.whCode,
    required this.location,
    required this.sc,
    required this.pn,
    required this.mnemonic,
    required this.price,
    required this.totaliser,
  });

  factory FilterPopulation.fromJson(Map<String, dynamic> json) {
    return FilterPopulation(
        whCode: json["whcode"],
        location: json["location"],
        sc: json["sc"],
        pn: json["pn"],
        mnemonic: json["mnemonic"],
        price: json["price"],
        totaliser: json["totaliser"]);
  }

  factory FilterPopulation.fromGoogleSheet(List<dynamic> gsheetString) {
    return FilterPopulation(
      whCode: gsheetString[0],
      location: gsheetString[1],
      sc: gsheetString[2],
      pn: gsheetString[3],
      mnemonic: gsheetString[4],
      price: double.parse(gsheetString[5].toString()),
      totaliser: double.parse(gsheetString[6].toString()),
    );
  }
}

class FilterChange {
  String period;
  String tgl;
  FilterPopulation? filterPopulation;
  int qty;
  String? reason;
  String? remark;
  double? totaliser;
  double? fuelPass;
  double? filterCostActual;
  String pelapor;

  FilterChange({
    required this.period,
    required this.tgl,
    this.filterPopulation,
    required this.qty,
    required this.reason,
    this.remark,
    required this.totaliser,
    required this.fuelPass,
    required this.filterCostActual,
    required this.pelapor,
  });

  static List<dynamic> toGoogleSheet(FilterChange fltr) {
    return [
      fltr.period,
      fltr.tgl,
      fltr.filterPopulation!.whCode,
      fltr.filterPopulation!.location,
      fltr.filterPopulation!.sc,
      fltr.filterPopulation!.pn,
      fltr.filterPopulation!.mnemonic,
      fltr.qty,
      fltr.filterPopulation!.price,
      fltr.reason,
      fltr.remark ?? "No Remark",
      fltr.totaliser,
      fltr.fuelPass,
      fltr.filterCostActual,
      fltr.pelapor
    ];
  }
}
