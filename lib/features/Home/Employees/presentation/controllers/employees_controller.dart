import 'package:hcs_driver/features/Home/Availability/presentation/controllers/availability_controller.dart';
import 'package:hcs_driver/features/Home/Employees/data/models/employees_model.dart';
import 'package:hcs_driver/features/Home/Employees/data/models/get_employees_params.dart';
import 'package:hcs_driver/features/Home/Employees/data/repositories/employees_repository.dart';
import 'package:hcs_driver/features/Home/Employees/presentation/controllers/employees_state.dart';
import 'package:hcs_driver/src/enums/request_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'employees_controller.g.dart';

@riverpod
class EmployeesController extends _$EmployeesController {
  @override
  EmployeesState build() => EmployeesState();

  selectServiceCategory(String serviceCategory) {
    state = state.copyWith(
      serviceCategory: serviceCategory,
      selectedEmployees: [],
    );

  }

  searchEmployee(String employeeName) {
    state = state.copyWith(employeeSearchedFor: employeeName);
    fetchEmployees();

  }

  selectEmployee(Employee selectedEmployee) {
    List<Employee> employeesList = List.from(state.selectedEmployees);
    int index = employeesList.indexWhere(
      (element) => element.employeeName == selectedEmployee.employeeName,
    );
    if (index == -1) {
      employeesList.add(selectedEmployee);
      state = state.copyWith(selectedEmployees: employeesList);
    }


  }

  unSelectEmployee(Employee unSelectedEmployee) {
    List<Employee> employeeList = List.from(state.selectedEmployees);
    int index = employeeList.indexWhere(
      (element) => element.employeeName == unSelectedEmployee.employeeName,
    );
    if (index != -1) {
      employeeList.removeAt(index);
    }
    state = state.copyWith(selectedEmployees: employeeList);
  }

  Future<void> fetchEmployees() async {
    state = state.copyWith(employeesStates: RequestStates.loading);

    try {
      final employeesRepo = ref.read(employeesRepositoryProvider);
      final availabilityController = ref.read(availabilityControllerProvider);

   

      final employeesData = await employeesRepo.getEmployees(
        getEmployeesParams: GetEmployeesParams(
          serviceType: availabilityController.selectedPackage?.id ?? 'Daily',
          date: availabilityController.selectedDate,
          days: availabilityController.selectedDays,
          shift: availabilityController.selectedShiftType,
          serviceCategory: state.serviceCategory,
          employeeName: state.employeeSearchedFor,
          page: 1,
        ),
      );

      int? nextPage;
      //if there is a second page ?
      if (employeesData.pagination.totalPages > 1) {
        nextPage = 2;
      } else {
        nextPage = null;
      }
      state = state.copyWith(
        currentEmployeesPage: nextPage,
        employees: employeesData.data,
        employeesStates: RequestStates.loaded,
        employeesMessage: '',
      );
    } catch (e) {
      state = state.copyWith(
        employeesStates: RequestStates.error,
        employeesMessage: e.toString(),
      );
    }
  }

  Future<void> onLoadMoreEmployees() async {
    try {
      final employeesRepo = ref.read(employeesRepositoryProvider);
      final availabilityController = ref.read(availabilityControllerProvider);
 
      final employeesData = await employeesRepo.getEmployees(
        getEmployeesParams: GetEmployeesParams(
          serviceType: availabilityController.selectedPackage?.id ?? 'Daily',
          date: availabilityController.selectedDate,
          days: availabilityController.selectedDays,
          shift: availabilityController.selectedShiftType,
          serviceCategory: state.serviceCategory,
          employeeName: state.employeeSearchedFor,
          page: state.currentEmployeesPage!,
        ),
      );

      int? nextPage;
      //if we reach the limit or not ?
      if (employeesData.pagination.totalPages > employeesData.pagination.page) {
        nextPage = employeesData.pagination.page + 1;
      } else {
        nextPage = null;
      }
      state = state.copyWith(
        currentEmployeesPage: nextPage,
        employees: [...state.employees, ...employeesData.data],
        employeesStates: RequestStates.loaded,
        employeesMessage: '',
      );
    } catch (e) {
      state = state.copyWith(
        employeesStates: RequestStates.error,
        employeesMessage: e.toString(),
      );
    }
  }
}
