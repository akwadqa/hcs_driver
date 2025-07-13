import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/Home/Availability/presentation/controllers/availability_controller.dart';
import 'package:hcs_driver/features/Home/Customer/presentation/widgets/drop_down_textfield.dart';
import 'package:hcs_driver/src/enums/service_type.dart';
import 'package:hcs_driver/src/manager/app_strings.dart';

class ServiceTypeMenu extends ConsumerWidget {
  ServiceTypeMenu({super.key});

  List<String> serviceTypeStringList = [
    ServiceType.onCall,
    ServiceType.packages,
    ServiceType.deepClean,
    ServiceType.maintenance,
  ].map((type) => serviceTypeToString(type)).toList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedServiceType = ref.watch(
      availabilityControllerProvider.select(
        (value) => value.selectedServiceType,
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          context.tr(AppStrings.serviceType),
          style: Theme.of(context).textTheme.displayMedium!,
        ),
        8.verticalSpace,
        DropDownField(
          enabled: false,
          items: serviceTypeStringList,
          value: selectedServiceType,
        ),
      ],
    );
  }
}
