import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hcs_driver/features/MyOrders/presentation/controllers/myorders_controller.dart';
import 'package:hcs_driver/src/enums/request_state.dart';
import 'package:hcs_driver/src/extenssions/int_extenssion.dart';
import 'package:hcs_driver/src/extenssions/widget_extensions.dart';
import 'package:hcs_driver/src/shared_widgets/custom_button_widget.dart';
import 'package:hcs_driver/src/shared_widgets/fade_circle_loading_indicator.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

Dialog showYesNowChoicesDialog(
  BuildContext context, {
  required String title,
  required String dsc,
  required VoidCallback yesButton,
  bool withField = false,
  TextEditingController? controller ,
  VoidCallback? noButton,
}) {
  return Dialog(
    insetPadding: EdgeInsets.symmetric(horizontal: 20),
    backgroundColor: Colors.white.withOpacity(0.99),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        25.verticalSpace,

        Text(
          title.tr(),
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            // color: Colors.grey,
          ),
        ).centered(),

        25.verticalSpace,

        Text(
          dsc.tr(),
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontSize: 14,
            color: AppColors.darkGray,
            fontWeight: FontWeight.w500,
          ),
        ),
        15.verticalSpace,

        if (withField)
          TextFormField(
            controller: controller,
            maxLines: 2,
            style: TextStyle(color: AppColors.gray),
            decoration: InputDecoration(
              labelText: "cancellation reasson",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.grey600),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.grayBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primary),
              ),
              labelStyle: TextStyle(
                color: AppColors.black900,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              // hintText: "0.00",
              hintStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                fontSize: 14,
                color: AppColors.grey600,
              ),
            ),
            textInputAction: TextInputAction.next,
            // keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (v) {
              // if (choice != PaymentChoice.cash) return null;
              if (v == null || v.trim().isEmpty) {
                return "Amount is required";
              }
              final d = double.tryParse(v.replaceAll(',', '.'));
              if (d == null || d <= 0) return "Enter a valid amount";
              return null;
            },
          ),
        40.verticalSpace,

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: CustomButtonWidget(
                text: context.tr("yes"),
                onTap: yesButton,
                backgroundColor: AppColors.blackText,
                isFiled: true,
                height: 45,
                radius: 12,
                width: MediaQuery.sizeOf(context).width,
              ),
            ),
            20.horizontalSpace,
            Flexible(
              child: CustomButtonWidget(
                text: context.tr("no"),
                onTap:
                    noButton ??
                    () {
                      Navigator.pop(context);
                    },
                color: AppColors.blackText,
                isFiled: false,
                borderColor: AppColors.darkGray,
                height: 45,
                radius: 12,
                width: MediaQuery.sizeOf(context).width,
              ),
            ),
          ],
        ),
      ],
    ).symmetricPadding(horizontal: 20, vertical: 25),
  );
}

enum PaymentAction { cash, skip }

Future<void> withBlockingLoader(
  BuildContext context,
  Future<void> Function() body,
) async {
  final nav = Navigator.of(context, rootNavigator: true);
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: FadeCircleLoadingIndicator()),
  );
  try {
    await body();
  } finally {
    if (nav.canPop()) nav.pop();
  }
}

Future<void> showPaymentStatusDialog(BuildContext context) async {
  await showDialog<void>(
    context: context,
    builder: (_) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Payment", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            // “Waiting for payment – Payment received” visual
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Waiting for payment"),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward),
                SizedBox(width: 8),
                Text("Payment received"),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

enum PaymentChoice { cash, skip }

class PaymentResult {
  final PaymentChoice choice;
  final double? amount; // only for cash
  PaymentResult(this.choice, {this.amount});
}

Future<PaymentResult?> showPaymentMethodDialog(BuildContext context) async {
  final formKey = GlobalKey<FormState>();
  final amountCtrl = TextEditingController();
  PaymentChoice choice = PaymentChoice.cash;

  return showDialog<PaymentResult>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Payment Received",
                  style: Theme.of(ctx).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),

                RadioListTile<PaymentChoice>(
                  value: PaymentChoice.cash,
                  groupValue: choice,
                  onChanged: (v) => setState(() => choice = v!),
                  title: const Text("Cash"),
                ),
                if (choice == PaymentChoice.cash) ...[
                  TextFormField(
                    controller: amountCtrl,
                    style: TextStyle(color: AppColors.gray),
                    decoration: InputDecoration(
                      labelText: "Received amount",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.grey600),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.grayBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      labelStyle: TextStyle(
                        color: AppColors.black900,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      hintText: "0.00",
                      hintStyle: Theme.of(context).textTheme.labelSmall!
                          .copyWith(fontSize: 14, color: AppColors.grey600),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (v) {
                      if (choice != PaymentChoice.cash) return null;
                      if (v == null || v.trim().isEmpty)
                        return "Amount is required";
                      final d = double.tryParse(v.replaceAll(',', '.'));
                      if (d == null || d <= 0) return "Enter a valid amount";
                      return null;
                    },
                  ),

                  const SizedBox(height: 8),
                ],

                RadioListTile<PaymentChoice>(
                  value: PaymentChoice.skip,
                  groupValue: choice,
                  onChanged: (v) => setState(() => choice = v!),
                  title: const Text("Skip Cash"),
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (choice == PaymentChoice.cash) {
                            if (!formKey.currentState!.validate()) return;
                            final amount = double.parse(
                              amountCtrl.text.replaceAll(',', '.'),
                            );
                            Navigator.of(ctx).pop(
                              PaymentResult(PaymentChoice.cash, amount: amount),
                            );
                          } else {
                            Navigator.of(
                              ctx,
                            ).pop(PaymentResult(PaymentChoice.skip));
                          }
                        },
                        child: const Text("Confirm"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Future<double?> showCashAmountDialog(BuildContext context) async {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();
  return showDialog<double>(
    context: context,
    builder: (_) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Enter received amount",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(hintText: "0.00"),
                validator: (v) {
                  if (v == null || v.trim().isEmpty)
                    return "Amount is required";
                  final value = double.tryParse(v.replaceAll(',', '.'));
                  if (value == null || value <= 0)
                    return "Enter a valid amount";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final value = double.parse(
                        controller.text.replaceAll(',', '.'),
                      );
                      Navigator.pop(context, value);
                    }
                  },
                  child: const Text("Confirm"),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<void> showPaymentReceivedDialog({
  required BuildContext context,
  required WidgetRef ref,
  required String appointmentID,
}) async {
  final notifier = ref.read(myOrdersControllerProvider.notifier);

  final amountCtrl = TextEditingController();
  PaymentChoice? choice = PaymentChoice.cash; // default on Cash
  final formKey = GlobalKey<FormState>();

  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          final isCash = choice == PaymentChoice.cash;

          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Payment Received",
                      style: Theme.of(ctx).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),

                    // choices
                    RadioListTile<PaymentChoice>(
                      value: PaymentChoice.cash,
                      groupValue: choice,
                      onChanged: (v) => setState(() => choice = v),
                      title: const Text("Cash"),
                    ),
                    if (isCash) ...[
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: amountCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: "Received amount",
                          hintText: "0.00",
                        ),
                        validator: (v) {
                          if (!isCash) return null;
                          if (v == null || v.trim().isEmpty)
                            return "Amount is required";
                          final parsed = double.tryParse(
                            v.replaceAll(',', '.'),
                          );
                          if (parsed == null || parsed <= 0)
                            return "Enter a valid amount";
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                    RadioListTile<PaymentChoice>(
                      value: PaymentChoice.skip,
                      groupValue: choice,
                      onChanged: (v) => setState(() => choice = v),
                      title: const Text("Skip Cash"),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text("Cancel"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (choice == PaymentChoice.cash) {
                                if (!formKey.currentState!.validate()) return;
                              }

                              // call your APIs with a single loader
                              await withBlockingLoader(ctx, () async {
                                if (choice == PaymentChoice.cash) {
                                  final amount = double.parse(
                                    amountCtrl.text.replaceAll(',', '.'),
                                  );

                                  // TODO: replace with your real endpoint:
                                  // await notifier.completeOrderWithCash(
                                  //   appointmentID: appointmentID,
                                  //   amount: amount,
                                  // );

                                  // placeholder: advance to Completed
                                  await notifier.updateStatusOrder(
                                    appointmentID: appointmentID,
                                  );
                                  await notifier.updateStatusOrder(
                                    appointmentID: appointmentID,
                                  );
                                } else {
                                  // TODO: replace with your real endpoint:
                                  // await notifier.completeOrderSkipCash(
                                  //   appointmentID: appointmentID,
                                  // );

                                  // placeholder: advance to Completed
                                  await notifier.updateStatusOrder(
                                    appointmentID: appointmentID,
                                  );
                                  await notifier.updateStatusOrder(
                                    appointmentID: appointmentID,
                                  );
                                }
                              });

                              if (ctx.mounted) Navigator.of(ctx).pop();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      choice == PaymentChoice.cash
                                          ? "Order completed (cash)."
                                          : "Order completed.",
                                    ),
                                  ),
                                );
                              }
                            },
                            child: const Text("Confirm"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Future<void> startPaymentFlow({
  required BuildContext context,
  required WidgetRef ref,
  required String appointmentID,
}) async {
  // 1) Show the “Waiting for payment → Payment received” info
  await showPaymentStatusDialog(context);

  // 2) Ask how to complete the order
  final action = await showPaymentMethodDialog(context);
  if (action == null) return; // user closed dialog

  final notifier = ref.read(myOrdersControllerProvider.notifier);

  if (action == PaymentAction.cash) {
    final amount = await showCashAmountDialog(context);
    if (amount == null) return; // user canceled
    await withBlockingLoader(context, () async {
      // TODO: replace with your real API call
      // e.g. await notifier.completeOrderWithCash(appointmentID: appointmentID, amount: amount);
      await notifier.updateStatusOrder(
        appointmentID: appointmentID,
      ); // placeholder
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Order completed with cash.")));
  } else {
    await withBlockingLoader(context, () async {
      // TODO: replace with your real API call for skipping cash
      // e.g. await notifier.completeOrderSkipCash(appointmentID: appointmentID);
      await notifier.updateStatusOrder(
        appointmentID: appointmentID,
      ); // placeholder
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Order completed.")));
  }
}

Dialog choicePaymentMethod(
  BuildContext context, {
  required String title,
  required String dsc,
  required VoidCallback yesButton,
  VoidCallback? noButton,
}) {
  return Dialog(
    insetPadding: EdgeInsets.symmetric(horizontal: 20),
    backgroundColor: Colors.white.withOpacity(0.99),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        40.verticalSpace,

        Text(
          title.tr(),
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            // color: Colors.grey,
          ),
        ).centered(),

        40.verticalSpace,

        Text(
          dsc.tr(),
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontSize: 14,
            color: AppColors.darkGray,
            fontWeight: FontWeight.w500,
          ),
        ),

        40.verticalSpace,

        // **Pay Button**
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: CustomButtonWidget(
                text: context.tr("yes"),
                onTap: yesButton,
                backgroundColor: AppColors.blackText,
                isFiled: true,
                height: 45,
                radius: 12,
                width: MediaQuery.sizeOf(context).width,
              ),
            ),
            20.horizontalSpace,
            Flexible(
              child: CustomButtonWidget(
                text: context.tr("no"),
                onTap:
                    noButton ??
                    () {
                      Navigator.pop(context);
                    },
                color: AppColors.blackText,
                isFiled: false,
                borderColor: AppColors.darkGray,
                height: 45,
                radius: 12,
                width: MediaQuery.sizeOf(context).width,
              ),
            ),
          ],
        ),
      ],
    ).symmetricPadding(horizontal: 20, vertical: 25),
  );
}

// Future<void> showAcceptCancelOrder(
//   BuildContext context,
//   String orderID,
//   bool cancelAppointmentLog,
//   WidgetRef ref,
// ) async {
//   final notifier = ref.read(myOrdersControllerProvider.notifier);

//   final confirmed = await showDialog<bool>(
//     context: context,
//     builder: (ctx) => showYesNowChoicesDialog(
//       ctx,
//       title: "attention",
//       dsc: "cancel_order_msg",
//       yesButton: () => Navigator.of(ctx).pop(true),
//     ),
//   );

//   if (confirmed != true) return;

//   // Show ONE blocking loader
//   await showDialog(
//     context: context,
//     // barrierDismissible: false,
//     builder: (_) => const Center(child: FadeCircleLoadingIndicator()),
//   );

//   // Note: we hold a reference to the Navigator since we'll pop twice
//   // final nav = Navigator.of(context, rootNavigator: true);
//   try {
//     if (cancelAppointmentLog) {
//       await notifier.orderAppointmentLogCancelltion(
//         staffAppointmentLog: orderID,
//         context: context,
//       );
//       await notifier.fetchAppontments(serviceOrderID: orderID);
//     } else {
//       await notifier.orderCancelltion(
//         serviceOrderID: orderID,
//         orderDate: 0,
//       );
//     }
//   } catch (e) {
//     // Show the error after closing loader
//     // (don’t swallow—surface it to the user)
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(e.toString())),
//     );
//   } finally {
//     // Always close the loader
//     context.pop();
//     // if (nav.canPop()) nav.pop();
//   }
// }
Future<bool> showAcceptCancelOrder({
  required BuildContext context,
  required String orderID,
  String? logId,
  required bool cancelAppointmentLog,
  required WidgetRef ref,
}) async {
  // 1) Ask for confirmation
  final controller = TextEditingController();

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => showYesNowChoicesDialog(
      controller: controller,
      ctx,
      title: "attention",
      dsc: "cancel_order_msg",
      withField: true,
      yesButton: () => Navigator.of(ctx).pop(true),
    ),
  );
  if (confirmed != true) return false;

  // 2) Show ONE blocking loader (or use the overlay approach from earlier)
  final nav = Navigator.of(context, rootNavigator: true);
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: FadeCircleLoadingIndicator()),
  );

  final notifier = ref.read(myOrdersControllerProvider.notifier);
  try {
    if (cancelAppointmentLog) {
      await notifier.orderAppointmentLogCancelltion(
        staffAppointmentLog: logId!,
        cancelMsg:controller.text,
        orderId: orderID,
        context: context,
      );
      // await notifier.fetchAppontments(serviceOrderID: orderID);
    } else {
      await notifier.orderCancelltion(serviceOrderID: orderID, orderDate: 0,cancelMsg:controller.text);
    }
    return true; // success -> allow Dismissible to remove
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(e.toString())));
    return false; // failure -> keep the card
  } finally {
    if (nav.canPop()) nav.pop(); // close loader
  }
}


// Future<void> showAcceptCancelOrder(
//   BuildContext context,
//   String orderID,
//   bool cancelAppointmentLog,
//   WidgetRef ref,
// ) {
//   return showDialog(
//     context: context,
//     builder: (BuildContext context) {

//       return Consumer(
//    builder: (context, ref, _) {
//                       ref.listen(myOrdersControllerProvider, (previous, next) {
//                         if (next.orderCancelltionStates ==RequestStates.loading
//                         ||next.orderCancelltionStates ==RequestStates.init
//                         ) {
//                        WidgetsBinding.instance.addPostFrameCallback((_) {
//                          showDialog(context: context, builder: (context){
//                        return   Center(child: FadeCircleLoadingIndicator());

//                          });
//                          });
//                         }
//                         if (next.orderCancelltionStates ==RequestStates.loaded) {
                         
//                           ref.read(myOrdersControllerProvider.notifier)
//                            .fetchAppontments(serviceOrderID: orderID);
//                             context.pop();
//                         } else if (next is AsyncError) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(
//                                 next.ordersMessage ?? "error occcured",
//                               ),
//                             ),
//                           );
//                         }
//                       });
//           return showYesNowChoicesDialog(
//             context,
//             title: "attention",
//             dsc: "cancel_order_msg",
//             yesButton: () async {
//               final asyncMyOrder =  ref.read(
//                 myOrdersControllerProvider.notifier,
//               );
          
//               cancelAppointmentLog
//                   ? {
//                     await  asyncMyOrder.orderAppointmentLogCancelltion(
//                         staffAppointmentLog: orderID,
//                         context: context,
//                       ),
//                       await asyncMyOrder.fetchAppontments(serviceOrderID: orderID),
//                     }
//                   : {
//                     await  asyncMyOrder.orderCancelltion(
//                         serviceOrderID: orderID,
//                         orderDate: 0,
//                       ),
//                     };
//               //  if(result){
//               //   Navigator.pop(context);
          
//               //   // Navigator.pop(context);
//               //  }
//               //   // await Future.delayed(Duration(milliseconds: 1000));
//               //   // Navigator.pop(context);
//             },
//           );
//         }
//       );
//     },
//   );
// }
