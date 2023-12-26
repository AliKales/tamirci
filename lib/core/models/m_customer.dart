import 'package:caroby/caroby.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tamirci/core/json_converters.dart';

part 'm_customer.g.dart';

@JsonSerializable()
class MCustomer {
  int? phone;
  int? phoneCountryCode;
  String? name;
  String? surname;
  String? fullName;
  int? idNo;
  String? taxNo;
  String? address;
  int? serviceCount;

  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
  )
  String? docID;

  @JsonKey(
    fromJson: JsonConvertersFrom.timestampToDate,
    toJson: JsonConvertersTo.firestoreTimestamp,
  )
  DateTime? createdAt;
  @JsonKey(
    fromJson: JsonConvertersFrom.timestampToDate,
    toJson: JsonConvertersTo.firestoreTimestamp,
  )
  DateTime? lastServiceAt;

  MCustomer({
    this.phone,
    this.phoneCountryCode,
    this.name,
    this.surname,
    this.fullName,
    this.idNo,
    this.taxNo,
    this.address,
    this.createdAt,
    this.lastServiceAt,
    this.serviceCount,
    this.docID,
  });

  factory MCustomer.fromJson(Map<String, dynamic> json) =>
      _$MCustomerFromJson(json);

  Map<String, dynamic> toJson() => _$MCustomerToJson(this);

  MCustomer copyWith({
    int? phone,
    int? phoneCountryCode,
    String? name,
    String? surname,
    String? fullName,
    int? idNo,
    int? serviceCount,
    String? taxNo,
    String? address,
    DateTime? lastServiceAt,
    DateTime? createdAt,
  }) {
    return MCustomer(
      phone: phone ?? this.phone,
      phoneCountryCode: phoneCountryCode ?? this.phoneCountryCode,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      fullName: fullName ?? this.fullName,
      idNo: idNo ?? this.idNo,
      taxNo: taxNo ?? this.taxNo,
      address: address ?? this.address,
      lastServiceAt: lastServiceAt ?? this.lastServiceAt,
      createdAt: createdAt ?? this.createdAt,
      serviceCount: serviceCount ?? this.serviceCount,
    );
  }

  String get getFullName {
    return "${name.capitalize()} ${surname.capitalize()}";
  }

  String get getPhone {
    return "+$phoneCountryCode $phone";
  }
}
