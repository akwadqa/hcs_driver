import 'package:equatable/equatable.dart';
import 'package:hcs_driver/features/Home/Employees/data/models/employees_model.dart';
import 'package:hcs_driver/src/enums/request_state.dart';

class EmployeesState extends Equatable {
  //employees
  final int? currentEmployeesPage;
  final List<Employee> employees;
  final RequestStates employeesStates;
  final String? employeesMessage;
  final List<Employee> selectedEmployees;
  final String employeeSearchedFor;

  //service category
  final String serviceCategory;

  const EmployeesState({
    //employees
    this.currentEmployeesPage,
    this.employees = const [],
    this.employeesStates = RequestStates.init,
    this.employeesMessage = '',
    this.selectedEmployees = const [],
    this.employeeSearchedFor = '',
    //service category
    this.serviceCategory = 'Stay - In',
  });
  EmployeesState copyWith({
    //employees
    int? currentEmployeesPage,
    List<Employee>? employees,
    RequestStates? employeesStates,
    String? employeesMessage,
    List<Employee>? selectedEmployees,
    String? employeeSearchedFor,

    //service category
    String? serviceCategory,
  }) {
    return EmployeesState(
      //employees
      currentEmployeesPage: currentEmployeesPage,
      employees: employees ?? this.employees,
      employeesStates: employeesStates ?? this.employeesStates,
      employeesMessage: employeesMessage ?? this.employeesMessage,
      selectedEmployees: selectedEmployees ?? this.selectedEmployees,
      employeeSearchedFor: employeeSearchedFor ?? this.employeeSearchedFor,
      //service category
      serviceCategory: serviceCategory ?? this.serviceCategory,
    );
  }

  @override
  List<Object?> get props => [
    //employees
    currentEmployeesPage,
    employees,
    employeesStates,
    employeesMessage, selectedEmployees, employeeSearchedFor, serviceCategory,
  ];
}
