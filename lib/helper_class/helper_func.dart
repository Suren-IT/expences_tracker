/*
  here i am going used the set to functions that useful throught entire app

*/

import 'package:intl/intl.dart';

//convert string to double
double convertStrtoDou(String string) {
  double? amount = double.tryParse(string);

  return amount ?? 0;
}

//convert double to currency
String formatCurreny(double amount) {
  final format =
      NumberFormat.currency(locale: "en_US", symbol: "\$", decimalDigits: 2);

  return format.format(amount);
}
