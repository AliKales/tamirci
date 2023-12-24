// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MVehicle _$MVehicleFromJson(Map<String, dynamic> json) => MVehicle(
      createdAt:
          JsonConvertersFrom.timestampToDate(json['createdAt'] as Timestamp?),
      vehicleMake: json['vehicleMake'] as String?,
      vehicleModel: json['vehicleModel'] as String?,
      vehicleModelDetail: json['vehicleModelDetail'] as String?,
      chassisNo: json['chassisNo'] as String?,
      engineNo: json['engineNo'] as String?,
      vehicleYear: json['vehicleYear'] as int?,
      color: json['color'] as String?,
      kilometer: json['kilometer'] as int?,
      plate: json['plate'] as String?,
      customerID: json['customerID'] as String?,
      lastServiceAt: JsonConvertersFrom.timestampToDate(
          json['lastServiceAt'] as Timestamp?),
      serviceCount: json['serviceCount'] as int?,
    );

Map<String, dynamic> _$MVehicleToJson(MVehicle instance) => <String, dynamic>{
      'createdAt': JsonConvertersTo.firestoreTimestamp(instance.createdAt),
      'lastServiceAt':
          JsonConvertersTo.firestoreTimestamp(instance.lastServiceAt),
      'vehicleMake': instance.vehicleMake,
      'vehicleModel': instance.vehicleModel,
      'vehicleModelDetail': instance.vehicleModelDetail,
      'chassisNo': instance.chassisNo,
      'engineNo': instance.engineNo,
      'vehicleYear': instance.vehicleYear,
      'color': instance.color,
      'kilometer': instance.kilometer,
      'plate': instance.plate,
      'customerID': instance.customerID,
      'serviceCount': instance.serviceCount,
    };
