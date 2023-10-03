class FuelTruck {
  final String ID;
  final String shift;
  final String ftNumber;
  final String whCode;
  final String tgl;
  final String jam;
  final String fuelman;
  final String operator;
  final double sondBefore;
  final double? sondingAwalDepan;
  final double? sondingAwalBelakang;
  final double? sondingAkhirDepan;
  final double? sondingAkhirBelakang;
  final double sondAfter;
  final String qtyBefore;
  final String qtyAfter;
  final String qtyByTera;
  final String noDO;
  final String qtyFM;
  final int urutan;
  String? PONO;
  String? isReceived;
  String? receiveDate;
  int? additive;
  String? pelapor;

  FuelTruck({
    required this.ID,
    required this.shift,
    required this.tgl,
    required this.urutan,
    required this.ftNumber,
    required this.whCode,
    required this.fuelman,
    required this.operator,
    required this.sondBefore,
    required this.sondAfter,
    required this.qtyBefore,
    required this.qtyAfter,
    required this.qtyByTera,
    required this.noDO,
    required this.qtyFM,
    required this.jam,
    this.sondingAkhirBelakang,
    this.sondingAkhirDepan,
    this.sondingAwalBelakang,
    this.sondingAwalDepan,
    this.PONO,
    this.isReceived,
    this.receiveDate,
    this.additive,
    this.pelapor,
  });

  factory FuelTruck.fromMap(Map<String, dynamic> json) => FuelTruck(
        ID: json['ID'].toString(),
        shift: json['shift'].toString(),
        tgl: json['tgl'].toString(),
        urutan: json['urutan'],
        operator: json['operator'],
        ftNumber: json['ft_number'].toString(),
        whCode: json['wh_code'],
        fuelman: json['fuelman'].toString(),
        sondBefore: json['sondBefore'],
        sondAfter: json['sondAfter'],
        qtyBefore: json['qtyBefore'].toString(),
        qtyAfter: json['qtyAfter'].toString(),
        qtyByTera: json['qtyByTera'].toString(),
        noDO: json['noDO'].toString(),
        qtyFM: json['qtyFM'].toString(),
        jam: json['jam'].toString(),
        additive: json['additive'],
        pelapor: json['pelapor'].toString(),
      );

  Map<String, dynamic> toMap() {
    return {
      'ID': ID,
      'shift': shift,
      'tgl': tgl,
      'urutan': urutan,
      'ft_number': ftNumber,
      'fuelman': fuelman,
      'sondBefore': sondBefore,
      'sondAfter': sondAfter,
      'qtyBefore': qtyBefore,
      'qtyAfter': qtyAfter,
      'qtyByTera': qtyByTera,
      'qtyFM': qtyFM,
      'jam': jam,
      'noDO': noDO,
    };
  }

  static List<dynamic> toGoogleMaps(FuelTruck ft) {
    return [
      ft.tgl,
      "PAMA",
      ft.shift,
      ft.urutan,
      ft.ftNumber,
      ft.fuelman,
      ft.operator,
      ft.whCode,
      ft.shift,
      ft.qtyFM,
      ft.qtyFM * 1,
      ft.sondingAwalDepan! * 10,
      ft.sondingAwalBelakang! * 10,
      ft.sondingAkhirDepan! * 10,
      ft.sondingAkhirBelakang! * 10,
      ft.qtyByTera,
      ft.noDO,
      ft.PONO,
      ft.receiveDate,
      ft.additive,
      ft.pelapor,
    ];
  }
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
