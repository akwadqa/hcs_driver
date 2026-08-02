import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/MyOrders/data/models/orders_details_model.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

class OrderDetailsCards extends StatelessWidget {
  final Details details; // استبدل dynamic بنوع الموديل الخاص بك

  const OrderDetailsCards({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ==========================================
        // 1. بطاقة تفاصيل الخدمة (Service Details)
        // ==========================================
        // DetailsCardWrapper(
        //   rows: [
        //     DetailRowItem(
        //       icon: Icons.cleaning_services_outlined,
        //       title: "serviceType".tr(),
        //       value: details?.serviceType,
        //     ),
        //     DetailRowItem(
        //       icon: Icons.wb_sunny_outlined,
        //       title: "shiftType".tr(),
        //       value: details?.shiftType,
        //     ),
        //     DetailRowItem(
        //       icon: Icons.calendar_today_outlined,
        //       title: "date".tr(),
        //       value: details?.date,
        //     ),
        //   ],
        // ),

        // ==========================================
        // 2. بطاقة طاقم العمل (Staff Details) - مطابقة للصورة
        // ==========================================
        DetailsCardWrapper(
          rows: [
            DetailRowItem(
              icon: Icons.people_alt_outlined,
              title: "supervisorName".tr(),
              value: details?.supervisor?.supervisorName,
            ),
            DetailRowItem(
              icon: Icons.local_shipping_outlined,
              title: "driverName".tr(),
              value: details?.driver?.driverName,
            ),
          ],
        ),

        // ==========================================
        // 3. بطاقة أدوات النظافة والملاحظات (Cleaning & Notes)
        // ==========================================
        DetailsCardWrapper(
          rows: [
            DetailRowItem(
              icon: Icons.clean_hands_outlined, // أيقونة مشابهة للصورة
              title: "cleaningSupply".tr(),
              value: details?.withCleaningSupplies != null
                  ? (details!.withCleaningSupplies == 0 ? "No" : "Yes")
                  : null,
            ),
            DetailRowItem(
              icon: Icons.note_alt_outlined,
              title: "note".tr(),
              value: details?.note,
            ),
          ],
        ),

        // ==========================================
        // 4. بطاقة الخصم والدفع (Discount & Payment)
        // ==========================================
        DetailsCardWrapper(
          rows: [
            DetailRowItem(
              icon: Icons.discount_outlined,
              title: "discountType".tr(),
              value: details?.discountType,
            ),
            DetailRowItem(
              icon: Icons.percent_outlined, // أيقونة النسبة المئوية
              title: "discountPercentage".tr(),
              value: details?.discountPercentage != null
                  ? "${details!.discountPercentage}%"
                  : null,
            ),
            DetailRowItem(
              icon: Icons.credit_card_outlined,
              title: "paymentMethod".tr(),
              value: details?.methodOfPayment,
            ),
          ],
        ),

        // ==========================================
        // 5. بطاقة الإجمالي (Total Price) - مطابقة للصورة
        // ==========================================
        DetailsCardWrapper(
          rows: [
            DetailRowItem(
              icon: Icons.local_offer_outlined, // أيقونة التاج
              title: "totalPrice".tr(), // أو استخدم "totalPrice".tr()
              value: details?.totalNetAmount != null
                  ? "${details!.totalNetAmount} ${'qar'.tr()}"
                  : null,
              isTotal: true, // تفعيل النمط الأخضر العريض
            ),
          ],
        ),
      ],
    );
  }
}

// =================================================================
// الويدجت المسؤولة عن تجميع الصفوف بداخل Card وإضافة الخطوط الفاصلة
// =================================================================
class DetailsCardWrapper extends StatelessWidget {
  final List<DetailRowItem> rows;

  const DetailsCardWrapper({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    // 1. تصفية الصفوف لإزالة أي صف قيمته null لكي لا يتم رسمه
    final validRows = rows
        .where((row) =>
            row.value != null && row.value!.toString().trim().isNotEmpty)
        .toList();

    // إذا كانت البطاقة فارغة تماماً لا تقم برسمها
    if (validRows.isEmpty) return const SizedBox.shrink();

    return Container(
      width: 353.w,
      margin: EdgeInsets.only(bottom: 12.h), // المسافة بين البطاقات
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Column(
        children: List.generate(validRows.length, (index) {
          return Column(
            children: [
              validRows[index], // رسم الصف
              // رسم خط فاصل إذا لم يكن هذا هو الصف الأخير
              if (index < validRows.length - 1)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: const Color(0xFFE5E7EB), // لون الخط الرمادي الفاتح
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

// =================================================================
// الويدجت المسؤولة عن رسم صف واحد (أيقونة - عنوان - قيمة)
// =================================================================
class DetailRowItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final bool isTotal; // لتحديد ما إذا كان هذا حقل السعر الإجمالي

  const DetailRowItem({
    super.key,
    required this.icon,
    required this.title,
    this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    // تم التعامل مع null في DetailsCardWrapper، ولكن هذا احتياط إضافي
    if (value == null || value!.toString().trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h), // Padding علوي وسفلي للصف
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // الأيقونة الدائرية
          Container(
            width: 27.w,
            height: 27.w,
            decoration: const BoxDecoration(
              color: Color(0xFFEEF6FF),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 14.sp,
              color: const Color(0xFF1E7BE2),
            ),
          ),
          12.horizontalSpace,
          // العنوان (على اليسار)
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: const Color(0xFF767676), // رمادي
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
          ),
          10.horizontalSpace,
          // القيمة (على اليمين)
          Expanded(
            child: Text(
              value!,
              textAlign: TextAlign.end, // محاذاة لليمين
              style: isTotal
                  ? TextStyle(
                      color: const Color(0xFF218B15), // لون أخضر للسعر
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    )
                  : Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: const Color(0xFF27272A), // أسود داكن
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
