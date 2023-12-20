import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

final class JsonConvertersFrom {
  const JsonConvertersFrom._();

  static DateTime? timestampToDate(Timestamp? timestamp) {
    return timestamp?.toDate();
  }
}

final class JsonConvertersTo {
  const JsonConvertersTo._();
  
  static FieldValue? firestoreTimestamp(Object? val) {
    if (val == null) return null;
    return FieldValue.serverTimestamp();
  }
}

class EpochDateTimeConverter implements JsonConverter<DateTime, int> {
  const EpochDateTimeConverter();

  @override
  DateTime fromJson(int json) => DateTime.fromMillisecondsSinceEpoch(json);

  @override
  int toJson(DateTime object) => object.millisecondsSinceEpoch;
}
