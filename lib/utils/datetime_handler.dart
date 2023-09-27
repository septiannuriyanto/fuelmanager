import 'package:intl/intl.dart';

final String today = DateFormat.yMMMMd('en_US').format(DateTime.now());
final String formattedToday = DateFormat('yyyyMMdd').format(DateTime.now());
final String formattedTodayTwoString =
    DateFormat('yyMMdd').format(DateTime.now());
final String formattedPeriod = DateFormat('yyyyMM').format(DateTime.now());

String formattedDate(DateTime date) {
  return DateFormat('yyyyMMdd').format(date);
}

String formattedSlashDate(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

formattedTodayIndDate() {
  return convertToIndDate(formattedToday);
}

const Map<String, String> monthsInYear = {
  "01": "Januari",
  "02": "Februari",
  "03": "Maret",
  "04": "April",
  "05": "Mei",
  "06": "Juni",
  "07": "Juli",
  "08": "Agustus",
  "09": "September",
  "10": "Oktober",
  "11": "November",
  "12": "Desember"
};

const List<String> monthsInYearShort = [
  "JAN",
  "FEB",
  "MAR",
  "APR",
  "MEI",
  "JUN",
  "JUL",
  "AGU",
  "SEP",
  "OKT",
  "NOV",
  "DES",
];

DateTime convertToDateTimeFromTwoDigitDate(String twoDigitDate) {
  //220107
  final year = '20${twoDigitDate.substring(0, 2)}';
  final month = twoDigitDate.substring(3, 4);
  final date = twoDigitDate.substring(5, 6);

  return DateTime(int.parse(year), int.parse(month), int.parse(date));
}

String convertToIndDate(String yyyyMMdd) {
  int len = yyyyMMdd.length;
  String day = yyyyMMdd.substring(len - 2, len);
  String year = yyyyMMdd.substring(0, 4);
  String month = yyyyMMdd.substring(4, 6);
  String convertedmonth =
      monthsInYear.entries.firstWhere((element) => element.key == month).value;
  return '$day $convertedmonth $year';
}

String convertToIndShortDate(String yyyyMMdd) {
  int len = yyyyMMdd.length;
  String day = yyyyMMdd.substring(len - 2, len);
  String year = yyyyMMdd.substring(0, 4);
  String month = yyyyMMdd.substring(4, 6);
  return '$day/$month/$year';
}

String convertToIndDateFromTwoDigit(String yyMMdd) {
  int len = yyMMdd.length;
  String day = yyMMdd.substring(len - 2, len);
  String year = yyMMdd.substring(0, 2);
  String month = yyMMdd.substring(2, 4);
  String convertedmonth =
      monthsInYear.entries.firstWhere((element) => element.key == month).value;
  return '$day $convertedmonth $year';
}

String getCurrentShift() {
  String shiftNum;
  int Jam = int.parse(DateFormat("HH").format(DateTime.now()));
  Jam > 7 && Jam <= 18 ? shiftNum = "1" : shiftNum = "2";
  return shiftNum;
}

String getCurrentTime() {
  return DateFormat("Hm").format(DateTime.now());
}
