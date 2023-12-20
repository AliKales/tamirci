import 'package:json_annotation/json_annotation.dart';
part 'm_customer.g.dart';

@JsonSerializable()
class MCustomer {
  int? phone;
  int? phoneCountryCode;
  String? name;
  String? surname;
  int? idNo;
  String? taxNo;
  String? address;

  MCustomer({
    this.phone,
    this.phoneCountryCode,
    this.name,
    this.surname,
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
    int? idNo,
    String? taxNo,
    String? address,
  }) {
    return MCustomer(
      phone: phone ?? this.phone,
      phoneCountryCode: phoneCountryCode ?? this.phoneCountryCode,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      idNo: idNo ?? this.idNo,
      taxNo: taxNo ?? this.taxNo,
      address: address ?? this.address,
    );
  }
}
