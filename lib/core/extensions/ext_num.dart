import 'package:money_formatter/money_formatter.dart';

extension ExtNumber on num? {}

extension ExtDouble on double? {
  double get noNull {
    return this ?? 0;
  }

  String get moneyFormat {
    return MoneyFormatter(
      amount: this ?? 0,
      settings: MoneyFormatterSettings(
        symbol: "₺"
      ),
    ).output.symbolOnRight;
  }
}

extension ExtInt on int? {
  int get noNull {
    return this ?? 0;
  }
}
