import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hcs_driver/features/MyOrders/presentation/controllers/myorders_controller.dart';
import 'package:hcs_driver/src/core/enums/shift_type_enum.dart';

import 'custom_button.dart';

Future<void> showOrderFilterMenu(
  BuildContext context,
  WidgetRef ref,
  int tabIndex,
) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "",
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (context, animation, secondary, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );

      return Stack(
        children: [
          /// Blur background
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 3 * animation.value,
                  sigmaY: 3 * animation.value,
                ),
                child: Container(color: Colors.black12),
              ),
            ),
          ),

          /// Filter panel
          Positioned(
            top: kToolbarHeight + 80,
            right: 20,
            child: FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.1),
                  end: Offset.zero,
                ).animate(curved),
                child: Consumer(
                  builder: (context, ref, _) {
                    final controller = ref.read(
                      myOrdersControllerProvider.notifier,
                    );

                    // استدعاء القائمة المختارة بدلاً من العنصر الفردي
                    final selectedShifts = ref.watch(
                      myOrdersControllerProvider.select(
                        (s) => s.selectedShiftTypes,
                      ),
                    );

                    return Material(
                      borderRadius: BorderRadius.circular(16),
                      elevation: 12,
                      color: Colors.white,
                      child: Container(
                        width: 260,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "shiftType".tr(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),

                            /// تحويل الخيارات إلى Checkbox
                            ...ShiftTypeEnum.values.map((shift) {
                              final isSelected = selectedShifts.contains(shift);
                              return _checkboxItem(
                                title: shift.label,
                                isSelected: isSelected,
                                onChanged: (_) {
                                  controller.toggleShiftType(shift);
                                },
                              );
                            }),

                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      controller.clearShiftType();
                                    },
                                    child: Text("clear".tr()),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: CustomButton(
                                    title: "apply".tr(),
                                    onPressed: () {
                                      controller.applyShiftFilter(
                                        tabIndex: tabIndex,
                                      );
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

/// ويدجت الـ Checkbox المخصصة
Widget _checkboxItem({
  required String title,
  required bool isSelected,
  required ValueChanged<bool?> onChanged,
}) {
  return InkWell(
    onTap: () => onChanged(!isSelected),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: onChanged,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    ),
  );
}
