import 'package:flutter_test/flutter_test.dart';
import 'package:tamirci/core/extensions/ext_string.dart';

void main() {
  test("Int Ext", () {
    final r = "".toIntOrNull;

    expect(null, r);
  });
}
