import 'package:intl/intl.dart';

class CurrencyFormat {
  CurrencyFormat._();

  static final _formatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  static String format(double value) => _formatter.format(value);

  static String formatCompact(double value) {
    if (value >= 1000) {
      return 'R\$ ${(value / 1000).toStringAsFixed(1)}k';
    }
    return format(value);
  }
}
