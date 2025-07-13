import 'package:hcs_driver/features/Home/Availability/presentation/controllers/availability_controller.dart';
import 'package:hcs_driver/features/Home/Customer/presentation/controllers/customer_controller.dart';
import 'package:hcs_driver/features/Home/Driver_Payment/presentation/controllers/drivers_payment_controllers.dart';
import 'package:hcs_driver/features/Home/Employees/presentation/controllers/employees_controller.dart';
import 'package:hcs_driver/features/Home/Submit_Service/data/models/submit_service_params.dart';
import 'package:hcs_driver/features/Home/Submit_Service/data/repo/submit_servcie_repo.dart';
import 'package:hcs_driver/features/Home/Submit_Service/presentation/submit_service_state.dart';
import 'package:hcs_driver/src/enums/request_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'submit_service_controller.g.dart';

@riverpod
class SubmitServiceController extends _$SubmitServiceController {
  @override
  SubmitServiceState build() => const SubmitServiceState();

  Future<void> submitService(
    // BuildContext context
  ) async {
    state = state.copyWith(submitServiceStates: RequestStates.loading);

    try {
      final submitServiceRepo = ref.read(submitServiceRepositoryProvider);
      final customerController = ref.read(customerControllerProvider);
      final availabilityController = ref.read(availabilityControllerProvider);
      final employeesController = ref.read(employeesControllerProvider);
      final driverPaymentController = ref.read(
        driversPaymentControllerProvider,
      );

       await submitServiceRepo.submitService(
        SubmitServiceParams(
          customerId: customerController.selectedCustomer!.customerId,
          customerName: customerController.selectedCustomer!.customerName,
          driver: driverPaymentController.selectedDriver!.driverId,
          date: availabilityController.selectedDate,
          serviceType: availabilityController.selectedPackage!.id,
          shiftType: availabilityController.selectedShiftType,
          days: availabilityController.selectedDays,
          employees: employeesController.selectedEmployees,
          paymentMethod: driverPaymentController.selectedPaymentMethod,
          discountPercentage: driverPaymentController.discountPercentage
              .toString(),
          withCleaningSupplies: driverPaymentController.withCleaningSupplies ,
        ),
      );

      state = state.copyWith(
        submitServiceStates: RequestStates.loaded,
        submitServiceMessage: 'loadded successfully',
      );
    } catch (e) {
      state = state.copyWith(
        submitServiceStates: RequestStates.error,
        submitServiceMessage: e.toString(),
      );
    }
  }
}
