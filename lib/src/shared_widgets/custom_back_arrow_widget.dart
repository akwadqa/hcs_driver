import 'package:flutter/material.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

class CustomBackArrowWidget extends StatelessWidget {
  final Color? color;
  const CustomBackArrowWidget({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
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
