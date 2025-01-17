import 'package:intl/intl.dart';

extension DateExt on DateTime {
  String toDDmmYYYYHHmm() {
    return DateFormat("dd MMM yyyy hh:mm aa").format(this);
  }

  String toDDmmYYYY() {
    return DateFormat("dd MMM yyyy").format(this);
  }
}
