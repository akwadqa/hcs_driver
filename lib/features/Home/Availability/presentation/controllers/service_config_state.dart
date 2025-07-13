import 'package:equatable/equatable.dart';
import 'package:hcs_driver/features/Home/Availability/data/models/packages_model.dart';
import 'package:hcs_driver/src/enums/request_state.dart';

class ServiceConfigState extends Equatable {
  final String? selectedServiceType;
  final String selectedShiftType;
  final PackagesData? selectedPackage;
  final String selectedDate;
  final List<PackagesData> packages;
  final RequestStates packagesStates;
  final String? packagesMessage;
  final List<String> selectedDays; // New field
  final String firstVisitDate;
  final String lastVisitDate;

  const ServiceConfigState({
    this.selectedServiceType,
    this.selectedShiftType = 'Morning Shift',
    this.selectedPackage,
    this.selectedDate = '',
    this.packages = const [],
    this.packagesStates = RequestStates.init,
    this.packagesMessage = '',
    this.selectedDays = const [],
    this.firstVisitDate = '',
    this.lastVisitDate = '',
  });

  ServiceConfigState copyWith({
    String? selectedServiceType,
    String? selectedShiftType,
    PackagesData? selectedPackage,
    String? selectedDate,
    List<PackagesData>? packages,
    RequestStates? packagesStates,
    String? packagesMessage,
    List<String>? selectedDays,
    String? firstVisitDate,
    String? lastVisitDate,
  }) {
    return ServiceConfigState(
      selectedServiceType: selectedServiceType ?? this.selectedServiceType,
      selectedShiftType: selectedShiftType ?? this.selectedShiftType,
      selectedPackage: selectedPackage ?? this.selectedPackage,
      selectedDate: selectedDate ?? this.selectedDate,
      packages: packages ?? this.packages,
      packagesStates: packagesStates ?? this.packagesStates,
      packagesMessage: packagesMessage ?? this.packagesMessage,
      selectedDays: selectedDays ?? this.selectedDays,
      firstVisitDate: firstVisitDate ?? this.firstVisitDate,
      lastVisitDate: lastVisitDate ?? this.lastVisitDate,
    );
  }

  @override
  List<Object?> get props => [
    selectedServiceType,
    selectedShiftType,
    selectedPackage,
    selectedDate,
    packages,
    packagesStates,
    selectedDays,
    firstVisitDate,
    lastVisitDate,
  ];
}
