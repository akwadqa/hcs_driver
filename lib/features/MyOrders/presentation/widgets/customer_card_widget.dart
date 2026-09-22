import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/MyOrders/data/models/orders_details_model.dart';
import 'package:hcs_driver/features/MyOrders/presentation/widgets/order_card.dart';
import 'package:hcs_driver/gen/assets.gen.dart';
import 'package:hcs_driver/src/shared_widgets/custom_bottom_sheets.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

class CustomerDetailsCard extends StatefulWidget {
  final Details details; // استبدل dynamic بنوع الموديل الفعلي لديك
  final BuildContext parentContext; // نمررها من أجل showContactActionsSheet

  const CustomerDetailsCard({
    super.key,
    required this.details,
    required this.parentContext,
  });

  @override
  State<CustomerDetailsCard> createState() => _CustomerDetailsCardState();
}

class _CustomerDetailsCardState extends State<CustomerDetailsCard> {
  bool _isEmployeesExpanded = false;

  @override
  Widget build(BuildContext context) {
    // تجهيز قائمة الموظفين
    final List? staffList = widget.details?.staffAppointment as List?;
    final bool hasStaff = staffList != null && staffList.isNotEmpty;

    return Container(
      width: 353.w,
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 13.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==========================================
          // 1. قسم العميل (Customer)
          // ==========================================
          if (widget.details?.customer?.customerName != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIconContainer(
                    Assets.images.customerIc.svg()), // استخدم أيقونة العميل
                10.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'customer'.tr(),
                        style:
                            Theme.of(context).textTheme.displaySmall!.copyWith(
                                  color: const Color(0xFF1E71A3),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      5.verticalSpace,
                      Text(
                        widget.details!.customer!.customerName!,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: const Color(0xFF27272A),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _buildDivider(),
          ],

          // ==========================================
          // 2. قسم الهاتف (Phone)
          // ==========================================
          if (widget.details?.customer?.phoneNumber != null) ...[
            Row(
              children: [
                _buildIconContainer(Icon(Icons.phone_in_talk_outlined,
                    size: 14.sp,
                    color:
                        const Color(0xFF1E7BE2))), // يمكن استبدالها بأيقونة SVG
                10.horizontalSpace,
                Expanded(
                  child: Text(
                    widget.details!.customer!.phoneNumber!,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: const Color(0xFF27272A),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                // زر الإتصال (Call)
                InkWell(
                  onTap: () {
                    showContactActionsSheet(
                      widget.parentContext,
                      rawPhone: widget.details!.customer!.phoneNumber,
                      defaultCountryCode: "+974",
                    );
                  },
                  borderRadius: BorderRadius.circular(6.r),
                  child: Container(
                    width: 63.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF1E71A3)),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Assets.images.customerCallIc.svg(),
                        5.horizontalSpace,
                        Text(
                          'Call', // يمكنك استخدام 'call'.tr() للترجمة
                          style: TextStyle(
                            color: const Color(0xFF1E71A3),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _buildDivider(),
          ],

          // ==========================================
          // 3. قسم المنطقة (Location)
          // ==========================================
          if (widget.details?.customer?.location != null) ...[
            GestureDetector(
              onTap: () =>
                  openMapLink(widget.details!.customer!.locationUrl ?? ""),
              child: Row(
                children: [
                  _buildIconContainer(Icon(Icons.location_on_outlined,
                      size: 14.sp, color: const Color(0xFF1E7BE2))),
                  10.horizontalSpace,
                  Expanded(
                    child: Text(
                      widget.details!.customer!.location!,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: const Color(0xFF27272A),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            if (hasStaff) _buildDivider(),
          ],

          // ==========================================
          // 4. قسم الموظفين (Employees) قابل للطي
          // ==========================================
          if (hasStaff) ...[
            InkWell(
              onTap: () {
                setState(() {
                  _isEmployeesExpanded = !_isEmployeesExpanded;
                });
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Row(
                children: [
                  _buildIconContainer(Icon(Icons.person_outline,
                      size: 14.sp, color: const Color(0xFF1E7BE2))),
                  10.horizontalSpace,
                  Expanded(
                    child: Text(
                      "${'employeesName'.tr()} (${staffList.length})",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: const Color(0xFF27272A),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  // حركة دوران السهم
                  AnimatedRotation(
                    turns: _isEmployeesExpanded
                        ? 0.5
                        : 0.0, // نصف دورة (180 درجة) للأعلى والأسفل
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: const Color(0xFF767676),
                      size: 24.sp,
                    ),
                  ),
                ],
              ),
            ),

            // الأنيميشن الخاص بإظهار وإخفاء القائمة
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: _isEmployeesExpanded
                  ? Padding(
                      padding: EdgeInsets.only(
                          top: 12.h, left: 37.w), // إزاحة لتبدأ من محاذاة النص
                      child: SizedBox(
                        width: double.infinity, // لضمان أخذ العرض بالكامل
                        child: Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: staffList
                              .map((employee) =>
                                  _EmployeeChip(name: employee.toString()))
                              .toList(),
                        ),
                      ),
                    )
                  : const SizedBox(
                      width: double
                          .infinity, // ضروري لعدم حدوث اهتزاز بالعرض أثناء الـ Animation
                      height: 0,
                    ),
            ),
          ],
        ],
      ),
    );
  }

  // ==========================================
  // الويدجتس المساعدة (Helper Widgets)
  // ==========================================

  Widget _buildIconContainer(Widget icon) {
    return Container(
      width: 27.w,
      height: 27.w,
      decoration: const BoxDecoration(
        color: Color(0xFFEEF6FF),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: icon,
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Divider(
        height: 1,
        thickness: 1,
        color: const Color(0xFFD8D8D8),
      ),
    );
  }

  // بناء Chips الموظفين مع منطق الـ "+X More"
  List<Widget> _buildEmployeeChips(List staffList) {
    List<Widget> chips = [];
    int maxVisible =
        2; // عدد الأسماء الظاهرة قبل وضع زر "+ More" (بناءً على الفيجما)

    for (int i = 0; i < staffList.length; i++) {
      if (i < maxVisible) {
        chips.add(_EmployeeChip(name: staffList[i].toString()));
      } else {
        // الشريحة الأخيرة التي تحتوي على العدد المتبقي
        int remaining = staffList.length - maxVisible;
        chips.add(_MoreEmployeesChip(count: remaining));
        break;
      }
    }
    return chips;
  }
}

// ------------------------------------------
// ويدجت الشريحة العادية لاسم الموظف
// ------------------------------------------
class _EmployeeChip extends StatelessWidget {
  final String name;

  const _EmployeeChip({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person, size: 10.sp, color: const Color(0xFF444F58)),
          5.horizontalSpace,
          Text(
            name,
            style: TextStyle(
              color: const Color(0xFF444F58),
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------
// ويدجت شريحة "+ More" للعدد المتبقي
// ------------------------------------------
class _MoreEmployeesChip extends StatelessWidget {
  final int count;

  const _MoreEmployeesChip({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(20.r),
      ),
      alignment: Alignment.center,
      child: Text(
        "+$count More",
        style: TextStyle(
          color: const Color(0xFF1E7BE2),
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
