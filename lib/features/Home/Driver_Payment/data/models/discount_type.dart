import 'package:json_annotation/json_annotation.dart';

part 'discount_type.g.dart';

@JsonSerializable()
class DiscountTypes {
  @JsonKey(name: "status_code")
  int statusCode;
  @JsonKey(name: "error")
  int error;
  @JsonKey(name: "message")
  String message;
  @JsonKey(name: "data")
  List<Discount> data;

  DiscountTypes({
    required this.statusCode,
    required this.error,
    required this.message,
    required this.data,
  });

  factory DiscountTypes.fromJson(Map<String, dynamic> json) =>
      _$DiscountTypesFromJson(json);

  Map<String, dynamic> toJson() => _$DiscountTypesToJson(this);
}

@JsonSerializable()
class Discount {
  @JsonKey(name: "id")
  String id;
  @JsonKey(name: "title")
  String title;
  @JsonKey(name: "discount_percentage")
  int discountPercentage;

  Discount({
    required this.id,
    required this.title,
    required this.discountPercentage,
  });

  factory Discount.fromJson(Map<String, dynamic> json) =>
      _$DiscountFromJson(json);

  Map<String, dynamic> toJson() => _$DiscountToJson(this);
}
