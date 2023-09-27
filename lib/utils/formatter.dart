import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

var numberOnly = FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
var alwaysUppercase = UpperCaseTextFormatter();

var alphabetOnly = FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'));
var alphabetOnlyWithWhiteSpaces =
    FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z ]+$'));

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
        text: newValue.text.toUpperCase(), selection: newValue.selection);
  }
}

var numberWithDecimals =
    FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'));

//CURRENCY FORMATTER
//flutter pub add currency_text_input_formatter
final CurrencyTextInputFormatter rupiahFormat =
    CurrencyTextInputFormatter(locale: 'id', decimalDigits: 0, symbol: 'IDR');
final CurrencyTextInputFormatter dollarFormat =
    CurrencyTextInputFormatter(locale: 'us', decimalDigits: 0, symbol: '\$.');
final CurrencyTextInputFormatter neutralNumberFormat =
    CurrencyTextInputFormatter(
        locale: 'id', decimalDigits: 2, symbol: '', enableNegative: false);

final dollarMask = TextInputMask(
  mask: '\$! !9+,99',
  placeholder: '0',
  maxPlaceHolders: 3,
  reverse: true,
);

List<CurrencyTextInputFormatter>? getCurrencyFormat(String? currencyCode) {
  List<CurrencyTextInputFormatter> format = [];
  if (currencyCode == null) return null;
  if (currencyCode == 'IDR') {
    format.add(rupiahFormat);
    return format;
  } else if (currencyCode == 'USD') {
    format.add(dollarFormat);
    return format;
  } else {
    return null;
  }
}

String getCurrencyMask(String currencyCode, double number) {
  if (currencyCode == 'IDR') {
    number = number.ceilToDouble();
  } else {
    number = number;
  }
  return NumberFormat.currency(locale: 'id').format(number);
}
