import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tamirci/core/json_converters.dart';
part 'm_shop.g.dart';

@JsonSerializable()
class MShop {
  String? ownerName;
  String? shopName;
  String? phone;
  @JsonKey(
    fromJson: JsonConvertersFrom.timestampToDate,
    toJson: JsonConvertersTo.firestoreTimestamp,
  )
  DateTime? createdAt;
  bool? available;

  MShop({
    this.ownerName,
    this.shopName,
    this.phone,
    this.createdAt,
    this.available,
  });

  factory MShop.fromJson(Map<String, dynamic> json) => _$MShopFromJson(json);

  Map<String, dynamic> toJson() => _$MShopToJson(this);

  MShop copyWith({
    String? ownerName,
    String? shopName,
    String? phone,
    DateTime? createdAt,
    bool? available,
  }) {
    return MShop(
      ownerName: ownerName ?? this.ownerName,
      shopName: shopName ?? this.shopName,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      available: available ?? this.available,
    );
  }
}
