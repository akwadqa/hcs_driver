import 'package:easy_localization/easy_localization.dart';
import 'package:hcs_driver/features/Home/Availability/data/models/packages_model.dart';
import 'package:hcs_driver/features/Home/Availability/data/repositories/availability_repo.dart';
import 'package:hcs_driver/features/Home/Availability/presentation/controllers/service_config_state.dart';
import 'package:hcs_driver/src/enums/request_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'availability_controller.g.dart';

@riverpod
class AvailabilityController extends _$AvailabilityController {
  @override
  ServiceConfigState build() => const ServiceConfigState();

  selectService(String selectedServiceType) {
    state = state.copyWith(selectedServiceType: selectedServiceType);
  }

  toggleDaySelection(String day) {
    final currentDays = List<String>.from(state.selectedDays);
    final isSelected = currentDays.contains(day);
    isSelected ? currentDays.remove(day) : currentDays.add(day);

    if (currentDays.isNotEmpty) {
      state = state.copyWith(selectedDays: currentDays);
      calculateVisitDates();
    } else {
      state = state.copyWith(
        selectedDays: currentDays,
        firstVisitDate: '',
        lastVisitDate: '',
      );
    }
  }

  selectShift(String selectedShiftType) {
    state = state.copyWith(selectedShiftType: selectedShiftType);
  }

  selectDate(String selectedDate) {
    state = state.copyWith(selectedDate: selectedDate);
  }

  selecPackage(PackagesData selectedPackage) {
    state = state.copyWith(selectedPackage: selectedPackage);
  }

  Future<void> fetchPackages() async {
    state = state.copyWith(
      packagesStates: RequestStates.loading,
      selectedShiftType: 'Morning Shift',
      selectedDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      selectedDays: [],
      firstVisitDate: '',
      lastVisitDate: '',
    );

    try {
      final availabilityRepo = ref.read(availabilityRepositoryProvider);
      final packagesData = await availabilityRepo.getPackages();
      PackagesData selectPackage;

      //when service type is Packages so filter the list to x visits / month
      if (state.selectedServiceType == 'Packages') {
        List<PackagesData> filteredPackages = packagesData.data
            .where((element) => element.numberOfVisits != null)
            .toList();
        state = state.copyWith(
          packages: filteredPackages,
          selectedPackage: filteredPackages[0],
          packagesStates: RequestStates.loaded,
          packagesMessage: 'loadded successfully',
        );
      }
      //otherwise no filter apllied
      else {
        //this auto select Daily it because the flow of (on Call) depend on it
        selectPackage = packagesData.data.firstWhere(
          (element) => element.id == 'Daily',
        );

        state = state.copyWith(
          packages: packagesData.data,
          selectedPackage: selectPackage,
          packagesStates: RequestStates.loaded,
          packagesMessage: 'loadded successfully',
        );
      }
    } catch (e) {
      state = state.copyWith(
        packagesStates: RequestStates.error,
        packagesMessage: e.toString(),
      );
    }
  }

  calculateVisitDates() {
    List<String> selectedDays = List.from(state.selectedDays);
    if (selectedDays.isEmpty) {
      return;
    }
    DateTime startDate = DateFormat('yyyy-MM-dd').parse(state.selectedDate);
    int? visitsRemaining = int.tryParse(state.selectedPackage!.numberOfVisits!);

    // قائمة للأيام المختارة في الأسبوع
    final weekDays = {
      'saturday': DateTime.saturday,
      'sunday': DateTime.sunday,
      'monday': DateTime.monday,
      'tuesday': DateTime.tuesday,
      'wednesday': DateTime.wednesday,
      'thursday': DateTime.thursday,
      'friday': DateTime.friday,
    };

    List<DateTime> visitDates = [];
    DateTime currentDate =
        startDate; // البحث عن أول يوم يتطابق مع الأيام المختارة

    //check how many Vists in month // if null skip it
    if (visitsRemaining != null) {
      while (visitsRemaining! > 0) {
        if (selectedDays.contains(
          weekDays.entries
              .firstWhere((entry) => entry.value == currentDate.weekday)
              .key,
        )) {
          visitDates.add(currentDate);
          visitsRemaining--;
        }
        currentDate = currentDate.add(
          Duration(days: 1),
        ); // الانتقال إلى اليوم التالي
      }
    }
    // الحصول على أول زيارة وآخر زيارة
    String firstVisitDate = DateFormat('yyyy-MM-dd').format(visitDates.first);
    String lastVisitDate = DateFormat('yyyy-MM-dd').format(visitDates.last);

    state = state.copyWith(
      firstVisitDate: firstVisitDate,
      lastVisitDate: lastVisitDate,
    );
  }
}
