// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_extra_cost.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MExtraCost _$MExtraCostFromJson(Map<String, dynamic> json) => MExtraCost(
      price: (json['price'] as num?)?.toDouble(),
      explanation: json['explanation'] as String?,
    );

Map<String, dynamic> _$MExtraCostToJson(MExtraCost instance) =>
    <String, dynamic>{
      'price': instance.price,
      'explanation': instance.explanation,
    };
