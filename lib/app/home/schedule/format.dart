import 'package:intl/intl.dart';

class Format {

  static String date(DateTime date) {
    return DateFormat('E dd MMM yyyy ', 'ru').format(date);
  }

  static String dateSchedule(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  static String dayOfWeek(DateTime date) {
    return DateFormat.E().format(date);
  }

  static String currency(double pay) {
    if (pay != 0.0) {
      final formatter = NumberFormat.simpleCurrency(decimalDigits: 0);
      return formatter.format(pay);
    }
    return '';
  }

//   static String hours(double hours) {
//     final hoursNotNegative = hours < 0.0 ? 0.0 : hours;
//     final formatter = NumberFormat.decimalPattern();
//     final formatted = formatter.format(hoursNotNegative);
//     return '$formatted ч.';
//   }

}