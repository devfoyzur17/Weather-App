import 'package:intl/intl.dart';

String getFormattedDate(num date, String? pattern) {
  return DateFormat.yMMMd()
      .format(DateTime.fromMillisecondsSinceEpoch(date.toInt() * 1000));
}
String getFormattedTime(num date, String? pattern) {
  return DateFormat.jm()
      .format(DateTime.fromMillisecondsSinceEpoch(date.toInt() * 1000));
}
