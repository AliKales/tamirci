import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tamirci/core/extensions/ext_list.dart';
import 'package:tamirci/core/extensions/ext_num.dart';
import 'package:tamirci/core/models/m_customer.dart';
import 'package:tamirci/core/models/m_extra_cost.dart';
import 'package:tamirci/core/models/m_piece.dart';

import '../json_converters.dart';
import 'm_vehicle.dart';

part 'm_service.g.dart';

@JsonSerializable(explicitToJson: true)
class MService {
  String? vehicleID;
  String? customerID;
  int? kilometer;
  @JsonKey(
    fromJson: JsonConvertersFrom.timestampToDate,
    toJson: JsonConvertersTo.firestoreTimestamp,
  )
  DateTime? createdAt;
  String? customerComplaint;
  String? problem;
  String? toDone;
  List<MPiece>? usedPieces;
  double? totalPrice;
  double? workCost;
  List<MExtraCost>? extraCosts;
  String? customerFullName;
  String? plate;

  @JsonKey(
    includeFromJson: true,
    includeToJson: false,
  )
  String? docID;

  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
  )
  MCustomer? customer;
  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
  )
  MVehicle? vehicle;

  MService({
    this.vehicleID,
    this.kilometer,
    this.createdAt,
    this.customerComplaint,
    this.problem,
    this.toDone,
    this.usedPieces,
    this.totalPrice,
    this.workCost,
    this.extraCosts,
    this.customer,
    this.customerID,
    this.customerFullName,
    this.docID,
    this.plate,
  });

  factory MService.fromJson(Map<String, dynamic> json) =>
      _$MServiceFromJson(json);

  Map<String, dynamic> toJson() => _$MServiceToJson(this);

  MService copyWith({
    String? vehicleID,
    int? kilometer,
    DateTime? createdAt,
    String? customerComplaint,
    String? problem,
    String? toDone,
    List<MPiece>? usedPieces,
    double? totalPrice,
    double? workCost,
    List<MExtraCost>? extraCosts,
    String? customerFullName,
  }) {
    return MService(
      vehicleID: vehicleID ?? this.vehicleID,
      kilometer: kilometer ?? this.kilometer,
      createdAt: createdAt ?? this.createdAt,
      customerComplaint: customerComplaint ?? this.customerComplaint,
      problem: problem ?? this.problem,
      toDone: toDone ?? this.toDone,
      usedPieces: usedPieces ?? this.usedPieces?.cast<MPiece>(),
      totalPrice: totalPrice ?? this.totalPrice,
      workCost: workCost ?? this.workCost,
      extraCosts: extraCosts ?? this.extraCosts?.cast<MExtraCost>(),
      customerFullName: customerFullName ?? this.customerFullName,
    );
  }

  double get getTotalPrice {
    int maxLength = extraCosts?.length ?? 0;
    int pricesLength = usedPieces?.length ?? 0;

    if (pricesLength > maxLength) {
      maxLength = pricesLength;
    }

    double p = 0;

    for (var i = 0; i < maxLength; i++) {
      p += extraCosts.getByIndex(i)?.price ?? 0;
      p += usedPieces.getByIndex(i)?.price ?? 0;
    }

    p += workCost.noNull;
    return p;
  }
}
