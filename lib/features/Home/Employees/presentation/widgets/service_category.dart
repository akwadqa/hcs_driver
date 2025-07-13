import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/Home/Employees/presentation/controllers/employees_controller.dart';
import 'package:hcs_driver/src/enums/service_type.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

class ServiceCategoryChips extends ConsumerStatefulWidget {
  final String selectedChip;
  const ServiceCategoryChips({super.key, required this.selectedChip});

  @override
  ServiceCategoryChipsState createState() => ServiceCategoryChipsState();
}

class ServiceCategoryChipsState extends ConsumerState<ServiceCategoryChips> {
  late List<String> serviceCategoryStringList;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    serviceCategoryStringList = [
      ServiceCategory.onCall,
      ServiceCategory.stayIn,
      ServiceCategory.company,
      ServiceCategory.flexible,
    ].map((type) => serviceCategoryToString(type)).toList();

    _selectedIndex = serviceCategoryStringList.indexOf(widget.selectedChip);
    if (_selectedIndex == -1) {
      _selectedIndex = 0; // fallback if selectedChip is not found
    }
    Future.microtask(() {
      _selectedIndex == 0 || _selectedIndex == 1
          ? ref
                .read(employeesControllerProvider.notifier)
                .selectServiceCategory(serviceCategoryStringList[1])
          : ref
                .read(employeesControllerProvider.notifier)
                .selectServiceCategory(
                  serviceCategoryStringList[_selectedIndex],
                );
      ref.read(employeesControllerProvider.notifier).fetchEmployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 165.w / 80.h,
      ),
      itemCount: serviceCategoryStringList.length,
      itemBuilder: (context, index) {
        final bool isSelected = index == _selectedIndex;
        return GestureDetector(
          onTap: () {
            setState(() => _selectedIndex = index);
            Future.microtask(() {
              _selectedIndex == 0 || _selectedIndex == 1
                  ? ref
                        .read(employeesControllerProvider.notifier)
                        .selectServiceCategory(serviceCategoryStringList[1])
                  : ref
                        .read(employeesControllerProvider.notifier)
                        .selectServiceCategory(
                          serviceCategoryStringList[_selectedIndex],
                        );
              ref.read(employeesControllerProvider.notifier).fetchEmployees();
            });
          },
          child: Container(
            alignment: Alignment.center,
            width: 165.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.selectedBlue : AppColors.primary,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              serviceCategoryStringList[index],
              style: Theme.of(
                context,
              ).textTheme.displayLarge!.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        );
      },
    );
  }
}
