extension ExtObject on Object? {
  String get toStringNull {
    if (this == null) {
      return "";
    }
    return toString();
  }
}
