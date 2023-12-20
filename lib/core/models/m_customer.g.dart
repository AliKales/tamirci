// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MCustomer _$MCustomerFromJson(Map<String, dynamic> json) => MCustomer(
      phone: json['phone'] as int?,
      phoneCountryCode: json['phoneCountryCode'] as int?,
      name: json['name'] as String?,
      surname: json['surname'] as String?,
      idNo: json['idNo'] as int?,
      taxNo: json['taxNo'] as String?,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$MCustomerToJson(MCustomer instance) => <String, dynamic>{
      'phone': instance.phone,
      'phoneCountryCode': instance.phoneCountryCode,
      'name': instance.name,
      'surname': instance.surname,
      'idNo': instance.idNo,
      'taxNo': instance.taxNo,
      'address': instance.address,
    };
