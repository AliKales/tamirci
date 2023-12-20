import 'package:json_annotation/json_annotation.dart';
part 'm_piece.g.dart';

@JsonSerializable()
class MPiece {
  int? quantity;
  double? price;
  String? piece;

  MPiece({
    this.quantity,
    this.price,
    this.piece,
  });

  factory MPiece.fromJson(Map<String, dynamic> json) => _$MPieceFromJson(json);

  Map<String, dynamic> toJson() => _$MPieceToJson(this);

  MPiece copyWith({
    int? quantity,
    double? price,
    String? piece,
  }) {
    return MPiece(
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      piece: piece ?? this.piece,
    );
  }

  double get getSinglePrice {
    return price! / quantity!;
  }
}
