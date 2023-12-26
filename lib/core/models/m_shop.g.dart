// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_shop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MShop _$MShopFromJson(Map<String, dynamic> json) => MShop(
      ownerName: json['ownerName'] as String?,
      shopName: json['shopName'] as String?,
      phone: json['phone'] as String?,
      createdAt:
          JsonConvertersFrom.timestampToDate(json['createdAt'] as Timestamp?),
      available: json['available'] as bool?,
    );

Map<String, dynamic> _$MShopToJson(MShop instance) => <String, dynamic>{
      'ownerName': instance.ownerName,
      'shopName': instance.shopName,
      'phone': instance.phone,
      'createdAt': JsonConvertersTo.firestoreTimestamp(instance.createdAt),
      'available': instance.available,
    };
