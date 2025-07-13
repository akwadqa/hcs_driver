import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/Home/Driver_Payment/presentation/controllers/drivers_payment_controllers.dart';
import 'package:hcs_driver/gen/assets.gen.dart';
import 'package:hcs_driver/src/enums/service_type.dart';
import 'package:hcs_driver/src/manager/app_strings.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

class PaymentMethodChips extends ConsumerWidget {
  PaymentMethodChips({super.key});

  final List<String> _options = [
    PaymentMethod.skipCash,
    PaymentMethod.cash,
  ].map((type) => paymentMethodToString(type)).toList();

  final List<SvgGenImage> _image = [
    Assets.images.creditCard,
    Assets.images.cash,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    var paymentMethodState = ref.watch(
      driversPaymentControllerProvider.select(
        (value) => value.selectedPaymentMethod,
      ),
    );
    final notifier = ref.read(driversPaymentControllerProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,

      children: [
        Text(
          context.tr(AppStrings.paymentMethod),
          style: Theme.of(context).textTheme.displayMedium,
        ),
        16.verticalSpace,
        Wrap(
          spacing: 19.w,
          runSpacing: 16.h,
          children: List.generate(_options.length, (i) {
            final bool isSelected = _options[i] == paymentMethodState;
            return Consumer(
              builder: (context, ref, child) {
                return GestureDetector(
                  onTap: () {
                    notifier.selectPaymentMethod(_options[i]);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      // horizontal: 40.w,
                      vertical: 10.h,
                    ),
                    alignment: Alignment.center,
                    width: 155.w,
                    height: 115.h,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white
                          : AppColors.unSelectedGrey,
                      border: isSelected
                          ? Border.all(color: AppColors.blueText, width: 0.5)
                          : null,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      children: [
                        _image[i].svg(),
                        12.verticalSpace,
                        Text(
                          _options[i],
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                color: isSelected
                                    ? AppColors.blackText
                                    : AppColors.unSelectedText,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
