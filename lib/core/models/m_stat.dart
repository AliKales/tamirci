import 'package:json_annotation/json_annotation.dart';
part 'm_stat.g.dart';

@JsonSerializable()
class MStat {
  int? servicesLength;
  int? newVehicles;
  int? month;
  int? year;
  int? newCustomers;
  String? docID;
  int? vehiclesLength;
  int? customersLength;
  Map<String, int>? vehicleYears;
  Map<String, int>? vehicleMakes;
  Map<String, int>? colors;

  MStat({
    this.servicesLength,
    this.newVehicles,
    this.month,
    this.year,
    this.newCustomers,
    this.docID,
    this.vehiclesLength,
    this.customersLength,
    this.vehicleYears,
    this.vehicleMakes,
    this.colors,
  });

  factory MStat.fromJson(Map<String, dynamic> json) => _$MStatFromJson(json);

  Map<String, dynamic> toJson() => _$MStatToJson(this);
}
