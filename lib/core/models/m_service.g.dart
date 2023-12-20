// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MService _$MServiceFromJson(Map<String, dynamic> json) => MService(
      customerID: json['customerID'] as String?,
      vehicleMake: json['vehicleMake'] as String?,
      vehicleModel: json['vehicleModel'] as String?,
      chassisNo: json['chassisNo'] as String?,
      engineNo: json['engineNo'] as String?,
      vehicleYear: json['vehicleYear'] as int?,
      color: json['color'] as String?,
      kilometer: json['kilometer'] as int?,
      createdAt:
          JsonConvertersFrom.timestampToDate(json['createdAt'] as Timestamp?),
      customerComplaint: json['customerComplaint'] as String?,
      problem: json['problem'] as String?,
      toDone: json['toDone'] as String?,
      usedPieces: (json['usedPieces'] as List<dynamic>?)
          ?.map((e) => MPiece.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      workCost: (json['workCost'] as num?)?.toDouble(),
      extraCosts: (json['extraCosts'] as List<dynamic>?)
          ?.map((e) => MExtraCost.fromJson(e as Map<String, dynamic>))
          .toList(),
      plate: json['plate'] as String?,
    );

Map<String, dynamic> _$MServiceToJson(MService instance) => <String, dynamic>{
      'customerID': instance.customerID,
      'vehicleMake': instance.vehicleMake,
      'vehicleModel': instance.vehicleModel,
      'chassisNo': instance.chassisNo,
      'engineNo': instance.engineNo,
      'vehicleYear': instance.vehicleYear,
      'color': instance.color,
      'kilometer': instance.kilometer,
      'createdAt': JsonConvertersTo.firestoreTimestamp(instance.createdAt),
      'customerComplaint': instance.customerComplaint,
      'problem': instance.problem,
      'toDone': instance.toDone,
      'usedPieces': instance.usedPieces,
      'totalPrice': instance.totalPrice,
      'workCost': instance.workCost,
      'extraCosts': instance.extraCosts,
      'plate': instance.plate,
    };
