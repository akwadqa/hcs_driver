import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/Home/Customer/data/models/customers_model.dart';
import 'package:hcs_driver/features/Home/Customer/presentation/controllers/customer_controller.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

/// A single employee chip with widget.isEnabled/disabled styling.
class CustomerBarChip extends StatefulWidget {
  final Customers customer;
  final VoidCallback? onTap;
  final bool isEnabled;
  const CustomerBarChip({
    super.key,
    required this.customer,
    this.onTap,
    required this.isEnabled,
  });

  @override
  State<CustomerBarChip> createState() => _CustomerBarChipState();
}

class _CustomerBarChipState extends State<CustomerBarChip> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final controller = ref.read(customerControllerProvider.notifier);
        return GestureDetector(
          onTap: () {
            controller.toggleCustomer(widget.customer);
          },

          child: Container(
            width: 345.w,
            height: 48.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: widget.isEnabled ? Colors.white : AppColors.unSelectedGrey,
              border: Border.all(
                style: widget.isEnabled ? BorderStyle.solid : BorderStyle.none,
                color: AppColors.primary,
              ),
            ),
            child: Text(
              widget.customer.customerName,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: widget.isEnabled
                    ? AppColors.blackText
                    : AppColors.unSelectedText,
              ),
            ),
          ),
        );
      },
    );
  }
}
