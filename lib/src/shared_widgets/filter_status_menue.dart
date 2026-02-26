import 'dart:ui';

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
    // barrierColor: Colors.black.withOpacity(0.2),
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

                    final selectedShift = ref.watch(
                      myOrdersControllerProvider.select(
                        (s) => s.selectedShiftType,
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
                            const Text(
                              "Shift Type",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),

                            ...ShiftTypeEnum.values.map((shift) {
                              return _radioItem<ShiftTypeEnum>(
                                title: shift.label,
                                value: shift,
                                groupValue: selectedShift ,
                                onChanged: (value) {
                                  controller.setShiftType(value);
                                },
                              );
                            }),

                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () async {
                                      controller.clearShiftType();

                                      // await controller.applyShiftFilter(
                                      //   tabIndex: tabIndex,
                                      // );

                                      // Navigator.pop(context);
                                    },
                                    child: const Text("Clear"),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: CustomButton(
                                    title: "Apply",
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

Widget _radioItem<T>({
  required String title,
  required T value,
  required T? groupValue,
  required ValueChanged<T?> onChanged,
}) {
  return InkWell(
    onTap: () => onChanged(value),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Radio<T>(value: value, groupValue: groupValue, onChanged: onChanged),
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
