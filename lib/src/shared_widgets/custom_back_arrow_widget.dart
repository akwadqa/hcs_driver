import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hcs_driver/features/MyOrders/presentation/controllers/myorders_controller.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

class CustomBackArrowWidget extends ConsumerWidget {
  final Color? color;
  final VoidCallback? onBakPressed;

  const CustomBackArrowWidget({super.key, 
  
    this.onBakPressed,
  this.color});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return InkWell(
      onTap: () {
        // ref.read(myOrdersControllerProvider.notifier).fetchTodayOrders();
        // ref.invalidate(myOrdersControllerProvider);
       if(onBakPressed!=null) onBakPressed?.call();
        Navigator.pop(context);

      },
      child: Icon(
        Icons.arrow_back_ios_new_rounded,
        color: color ?? AppColors.backArrow,
        size: 20,
      ),
    );
  }
}
