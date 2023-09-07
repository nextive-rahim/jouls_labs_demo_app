import 'package:intl/intl.dart';
String? getFormattedDate(DateTime? dateTime) {
  String? time;
  if (dateTime != null) {
    time = DateFormat.yMMMMd().format(dateTime);
  }
  return time;
}

String? getFormattedTime(DateTime? dateTime) {
  String? time;
  time = DateFormat.jm().format(dateTime!.toLocal());
  return time;
}
