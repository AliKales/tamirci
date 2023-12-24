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
      fullName: json['fullName'] as String?,
      idNo: json['idNo'] as int?,
      taxNo: json['taxNo'] as String?,
      address: json['address'] as String?,
      createdAt:
          JsonConvertersFrom.timestampToDate(json['createdAt'] as Timestamp?),
      lastServiceAt: JsonConvertersFrom.timestampToDate(
          json['lastServiceAt'] as Timestamp?),
      serviceCount: json['serviceCount'] as int?,
    );

Map<String, dynamic> _$MCustomerToJson(MCustomer instance) => <String, dynamic>{
      'phone': instance.phone,
      'phoneCountryCode': instance.phoneCountryCode,
      'name': instance.name,
      'surname': instance.surname,
      'fullName': instance.fullName,
      'idNo': instance.idNo,
      'taxNo': instance.taxNo,
      'address': instance.address,
      'serviceCount': instance.serviceCount,
      'createdAt': JsonConvertersTo.firestoreTimestamp(instance.createdAt),
      'lastServiceAt':
          JsonConvertersTo.firestoreTimestamp(instance.lastServiceAt),
    };
