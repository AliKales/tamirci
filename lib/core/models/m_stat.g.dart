// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_stat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MStat _$MStatFromJson(Map<String, dynamic> json) => MStat(
      servicesLength: json['servicesLength'] as int?,
      newVehicles: json['newVehicles'] as int?,
      month: json['month'] as int?,
      year: json['year'] as int?,
      newCustomers: json['newCustomers'] as int?,
      docID: json['docID'] as String?,
      vehiclesLength: json['vehiclesLength'] as int?,
      customersLength: json['customersLength'] as int?,
      vehicleYears: (json['vehicleYears'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as int),
      ),
      vehicleMakes: (json['vehicleMakes'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as int),
      ),
      colors: (json['colors'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as int),
      ),
    );

Map<String, dynamic> _$MStatToJson(MStat instance) => <String, dynamic>{
      'servicesLength': instance.servicesLength,
      'newVehicles': instance.newVehicles,
      'month': instance.month,
      'year': instance.year,
      'newCustomers': instance.newCustomers,
      'docID': instance.docID,
      'vehiclesLength': instance.vehiclesLength,
      'customersLength': instance.customersLength,
      'vehicleYears': instance.vehicleYears,
      'vehicleMakes': instance.vehicleMakes,
      'colors': instance.colors,
    };
