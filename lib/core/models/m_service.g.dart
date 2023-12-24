// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MService _$MServiceFromJson(Map<String, dynamic> json) => MService(
      vehicleID: json['vehicleID'] as String?,
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
      customerID: json['customerID'] as String?,
      customerFullName: json['customerFullName'] as String?,
    );

Map<String, dynamic> _$MServiceToJson(MService instance) => <String, dynamic>{
      'vehicleID': instance.vehicleID,
      'customerID': instance.customerID,
      'kilometer': instance.kilometer,
      'createdAt': JsonConvertersTo.firestoreTimestamp(instance.createdAt),
      'customerComplaint': instance.customerComplaint,
      'problem': instance.problem,
      'toDone': instance.toDone,
      'usedPieces': instance.usedPieces?.map((e) => e.toJson()).toList(),
      'totalPrice': instance.totalPrice,
      'workCost': instance.workCost,
      'extraCosts': instance.extraCosts?.map((e) => e.toJson()).toList(),
      'customerFullName': instance.customerFullName,
    };
