import 'package:intl/intl.dart';

extension CurrencyExt on dynamic {
  String toCurrencyFormat({
    String? countryIso,
    bool needPlusSign = false,
    bool useDecimal = false,
  }) {
    if (this == null) return '';
    final balance = toString().replaceAll(',', '');
    if (balance.isEmpty) return '';

    final format = useDecimal
        ? NumberFormat('#,##0.00', 'en_US')
        : NumberFormat('#,##0', 'en_US');

    String prefix = '';
    String postfix = '';
    if (balance.contains('-')) {
      prefix = '(';
      postfix = ')';
    }
    if (needPlusSign && !balance.contains('-')) {
      prefix = '';
    }

    if (double.tryParse(balance.toString()) == null) {
      return (this is String) ? this : '';
    }

    return prefix +
        (countryIso ?? '') +
        format.format(double.parse(balance.replaceAll('-', ''))) +
        postfix;
  }

  bool isPostive() {
    if (this == null) return true;
    final balance = toString().replaceAll(',', '');

    if (balance.isEmpty || !balance.contains('-')) {
      return true;
    } else {
      return false;
    }
  }

  int forceInt({int defaultValue = 0}) {
    if (this == null) return defaultValue;
    return int.tryParse(this) == null ? defaultValue : int.parse(this);
  }

  double forceDouble({double defaultValue = 0.0}) {
    if (this == null) return defaultValue;
    return int.tryParse(this) == null
        ? defaultValue
        : int.parse(this).roundToDouble();
  }
}
