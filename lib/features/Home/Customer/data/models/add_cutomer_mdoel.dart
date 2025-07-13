import 'package:equatable/equatable.dart';

class AddCustomerParams extends Equatable {
  final String? customerType;
  final String? customerName;
  final String? customerQid;
  final String? customerPhone;
  final String? customerArea;
  final String? customerZone;
  final String? customerLocation;

  const AddCustomerParams({
    required this.customerType,
    required this.customerName,
    required this.customerQid,
    required this.customerPhone,
    required this.customerArea,
    required this.customerZone,
    required this.customerLocation,
  });

  @override
  List<Object?> get props => [
    customerType,
    customerName,
    customerQid,
    customerPhone,
    customerArea,
    customerZone,
    customerLocation,
  ];
}
