import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension SizedBoxExtensions on int {
  Widget get verticalSpace => SizedBox(height: toDouble().h);
  Widget get horizontalSpace => SizedBox(width: toDouble().w);
}
