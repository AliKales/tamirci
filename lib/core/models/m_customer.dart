import 'package:caroby/caroby.dart';
import 'package:json_annotation/json_annotation.dart';

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

  MCustomer({
    this.phone,
    this.phoneCountryCode,
    this.name,
    this.surname,
    this.fullName,
    this.idNo,
    this.taxNo,
    this.address,
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
    String? taxNo,
    String? address,
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
    );
  }

  String get getFullName {
    return "${name.capitalize()} ${surname.capitalize()}";
  }

  String get getPhone {
    return "+$phoneCountryCode $phone";
  }
}
