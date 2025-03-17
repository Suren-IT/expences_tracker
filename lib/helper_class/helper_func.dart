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

//calculate month  count
int calculateMonthCount(int startMonth, startYear, currentMonth, currentYear) {
  int monthcount =
      (currentYear - startYear) * 12 + currentMonth - startMonth + 1;
  return monthcount;
}

//get the current  month name

String getCurrentMonthName() {
  DateTime now = DateTime.now();
  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  return months[now.month - 1];
}
