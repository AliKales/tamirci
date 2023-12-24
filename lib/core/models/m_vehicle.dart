import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';
part 'm_vehicle.g.dart';

@JsonSerializable()
class MVehicle {
  @JsonKey(
    fromJson: JsonConvertersFrom.timestampToDate,
    toJson: JsonConvertersTo.firestoreTimestamp,
  )
  DateTime? createdAt;
  @JsonKey(
    fromJson: JsonConvertersFrom.timestampToDate,
    toJson: JsonConvertersTo.firestoreTimestamp,
  )
  DateTime? lastServiceAt;
  String? vehicleMake;
  String? vehicleModel;
  String? vehicleModelDetail;
  String? chassisNo;
  String? engineNo;
  int? vehicleYear;
  String? color;
  int? kilometer;
  String? plate;
  String? customerID;
  int? serviceCount;

  MVehicle({
    this.createdAt,
    this.vehicleMake,
    this.vehicleModel,
    this.vehicleModelDetail,
    this.chassisNo,
    this.engineNo,
    this.vehicleYear,
    this.color,
    this.kilometer,
    this.plate,
    this.customerID,
    this.lastServiceAt,
    this.serviceCount,
  });

  factory MVehicle.fromJson(Map<String, dynamic> json) =>
      _$MVehicleFromJson(json);

  Map<String, dynamic> toJson() => _$MVehicleToJson(this);

  MVehicle copyWith({
    DateTime? createdAt,
    DateTime? lastServiceAt,
    String? vehicleMake,
    String? vehicleModel,
    String? vehicleModelDetail,
    String? chassisNo,
    String? engineNo,
    int? vehicleYear,
    String? color,
    int? kilometer,
    int? serviceCount,
    String? plate,
    String? customerID,
  }) {
    return MVehicle(
      createdAt: createdAt ?? this.createdAt,
      lastServiceAt: lastServiceAt ?? this.lastServiceAt,
      vehicleMake: vehicleMake ?? this.vehicleMake,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleModelDetail: vehicleModelDetail ?? this.vehicleModelDetail,
      chassisNo: chassisNo ?? this.chassisNo,
      engineNo: engineNo ?? this.engineNo,
      vehicleYear: vehicleYear ?? this.vehicleYear,
      color: color ?? this.color,
      kilometer: kilometer ?? this.kilometer,
      plate: plate ?? this.plate,
      customerID: customerID ?? this.customerID,
      serviceCount: serviceCount ?? this.serviceCount,
    );
  }
}
