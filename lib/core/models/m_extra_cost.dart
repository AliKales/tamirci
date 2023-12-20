import 'package:json_annotation/json_annotation.dart';
part 'm_extra_cost.g.dart';

@JsonSerializable()
class MExtraCost {
  double? price;
  String? explanation;

  MExtraCost({
    this.price,
    this.explanation,
  });

  factory MExtraCost.fromJson(Map<String, dynamic> json) =>
      _$MExtraCostFromJson(json);

  Map<String, dynamic> toJson() => _$MExtraCostToJson(this);

  MExtraCost copyWith({
    double? price,
    String? explanation,
  }) {
    return MExtraCost(
      price: price ?? this.price,
      explanation: explanation ?? this.explanation,
    );
  }
}
