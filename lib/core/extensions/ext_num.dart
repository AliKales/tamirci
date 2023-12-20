extension ExtNumber on num? {}

extension ExtDouble on double? {
  double get noNull {
    return this ?? 0;
  }
}

extension ExtInt on int? {
  int get noNull {
    return this ?? 0;
  }
}
