import 'package:intl/intl.dart';

extension CustomDateTimeFormatting on String {
  String customDateFormat() {

    DateTime dateTime = DateTime.parse(this);


    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }
}