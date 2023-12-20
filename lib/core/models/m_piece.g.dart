// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_piece.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MPiece _$MPieceFromJson(Map<String, dynamic> json) => MPiece(
      quantity: json['quantity'] as int?,
      price: (json['price'] as num?)?.toDouble(),
      piece: json['piece'] as String?,
    );

Map<String, dynamic> _$MPieceToJson(MPiece instance) => <String, dynamic>{
      'quantity': instance.quantity,
      'price': instance.price,
      'piece': instance.piece,
    };
