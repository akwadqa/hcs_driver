import 'package:hcs_driver/features/Home/Availability/presentation/controllers/availability_controller.dart';
import 'package:hcs_driver/features/Home/Driver_Payment/data/models/discount_type.dart';
import 'package:hcs_driver/features/Home/Driver_Payment/data/models/drivers_model.dart';
import 'package:hcs_driver/features/Home/Driver_Payment/data/repositories/driver_payment_repo.dart';
import 'package:hcs_driver/features/Home/Driver_Payment/presentation/controllers/driver_payment_state.dart';
import 'package:hcs_driver/features/Home/Employees/data/models/employees_model.dart';
import 'package:hcs_driver/features/Home/Employees/presentation/controllers/employees_controller.dart';
import 'package:hcs_driver/src/enums/request_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'drivers_payment_controllers.g.dart';

@riverpod
class DriversPaymentController extends _$DriversPaymentController {
  @override
  DriverPaymentState build() => const DriverPaymentState();

  Future<void> withCleaningSupplies(String choice) async {
    state = state.copyWith(withCleaningSupplies: choice);
    calculateTotalCost(state.discountPercentage);
  }

  Future<void> selectPaymentMethod(String? selectedPaymentMethod) async {
    state = state.copyWith(selectedPaymentMethod: selectedPaymentMethod);
  }

  // In this function we getDiscountType and Auto selectDiscount,discountPercentage and calculateTotalCost
  Future<void> getDiscountType() async {
    state = state.copyWith(driversStates: RequestStates.loading);

    try {
      final driverPaymentRepo = ref.read(driverPaymentRepositoryProvider);
      final driverPaymentData = await driverPaymentRepo.getDiscountType();
      calculateTotalCost(state.discountPercentage.toDouble());

      state = state.copyWith(
        discountType: driverPaymentData.data,
        // selectedDiscount: driverPaymentData.data[0],
        // discountPercentage: driverPaymentData.data[0].discountPercentage
        //     .toDouble(),
        discountStates: RequestStates.loaded,
        driversMessage: '',
      );
    } catch (e) {
      state = state.copyWith(
        discountStates: RequestStates.error,
        driversMessage: e.toString(),
      );
    }
  }

  // In this function we chose Discount and Auto calculateCosts
  Future<void> selectDiscount(Discount? selectedDiscount) async {
    calculateTotalCost(selectedDiscount?.discountPercentage.toDouble());
    state = state.copyWith(selectedDiscount: selectedDiscount);
  }

  // In this function calculate withCleaningSupplies
  double calculatewithCleaningSupplies() {
    final availabilityController = ref.read(availabilityControllerProvider);
    final String selectedServiceType =
        availabilityController.selectedServiceType!;
    final String selectedShiftType = availabilityController.selectedShiftType;

    if (state.withCleaningSupplies == "no") {
      return 0.0;
    }
    if (selectedServiceType == "Packages") {
      return 0.0;
    }
    if (selectedShiftType == "Full Day") {
      return 100.0;
    }
    return 50.0;
  }

  // In this function calculateEmployeesSum
  double calculateEmployeesSum() {
    final employeesController = ref.read(employeesControllerProvider);
    final List<Employee> selectedEmployees =
        employeesController.selectedEmployees;

    double total = selectedEmployees.fold(
      0.0,
      (sum, employee) => sum + employee.serviceCost,
    );

    return total;
  }

  // In this function we controll 3 (originalCost , discountedCost, discountPercentage) in state
  Future<void> calculateTotalCost(double? discountPercentage) async {
    if (discountPercentage == null || discountPercentage < 0) {
      discountPercentage = 0.0;
    } else if (discountPercentage > 100) {
      discountPercentage = 100.0;
    }

    double employeesCost = calculateEmployeesSum();
    double withCleaningSupplies = calculatewithCleaningSupplies();
    double totalCost = employeesCost;

    // Convert percentage to a decimal (e.g., 10% -> 0.10)
    double discountDecimal = discountPercentage / 100;

    // Calculate the discount amount
    double discountAmount = totalCost * discountDecimal;

    // Apply the discount
    double discountedTotal = totalCost - discountAmount + withCleaningSupplies;

    // Update the state with the new total cost
    state = state.copyWith(
      originalCost: totalCost + withCleaningSupplies,
      discountedCost: discountedTotal,
      discountPercentage: discountPercentage,
    );
  }

  Future<void> selectDriver(Driver? selectedDriver) async {
    state = state.copyWith(selectedDriver: selectedDriver);
  }

  Future<void> fetchDrivers() async {
    state = state.copyWith(driversStates: RequestStates.loading);

    try {
      final driverPaymentRepo = ref.read(driverPaymentRepositoryProvider);
      final driverPaymentData = await driverPaymentRepo.getDrivers(page: 1);

      int? nextPage;
      //if there is a second page ?
      if (driverPaymentData.pagination.totalPages > 1) {
        nextPage = 2;
      } else {
        nextPage = null;
      }
      state = state.copyWith(
        currentDriversPage: nextPage,
        selectedDriver: driverPaymentData.data[0],
        drivers: driverPaymentData.data,
        driversStates: RequestStates.loaded,
        driversMessage: '',
      );
    } catch (e) {
      state = state.copyWith(
        driversStates: RequestStates.error,
        driversMessage: e.toString(),
      );
    }
  }

  Future<void> onLoadMoreDrivers() async {
    try {
      final driverPaymentRepo = ref.read(driverPaymentRepositoryProvider);
      final driverPaymentData = await driverPaymentRepo.getDrivers(
        page: state.currentDriversPage!,
      );

      int? nextPage;
      //if we reach the limit or not ?
      if (driverPaymentData.pagination.totalPages >
          driverPaymentData.pagination.page) {
        nextPage = driverPaymentData.pagination.page + 1;
      } else {
        nextPage = null;
      }
      state = state.copyWith(
        currentDriversPage: nextPage,
        drivers: [...state.drivers, ...driverPaymentData.data],
        driversStates: RequestStates.loaded,
        driversMessage: '',
      );
    } catch (e) {
      state = state.copyWith(
        driversStates: RequestStates.error,
        driversMessage: e.toString(),
      );
    }
  }
}
