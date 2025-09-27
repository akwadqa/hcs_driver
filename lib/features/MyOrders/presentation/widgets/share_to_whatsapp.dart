import 'package:auto_route/auto_route.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/MyOrders/data/models/order_details_share.dart';
import 'package:hcs_driver/features/MyOrders/data/models/orders_details_model.dart';
import 'package:hcs_driver/features/MyOrders/presentation/controllers/myorders_controller.dart';
import 'package:hcs_driver/features/MyOrders/presentation/controllers/myorders_state.dart';
import 'package:hcs_driver/features/MyOrders/presentation/controllers/order_details_controller.dart';
import 'package:hcs_driver/features/MyOrders/presentation/controllers/order_details_notifier.dart';
import 'package:hcs_driver/src/core/enums/request_state.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareToWhatsApp extends ConsumerStatefulWidget {
  final String serviceOrderId;
  final Details? orderDetails;
  final bool? isOrderShare;

  const ShareToWhatsApp({
    super.key,
    required this.serviceOrderId,
    required this.orderDetails,
    required this.isOrderShare,
  });

  @override
  ConsumerState<ShareToWhatsApp> createState() => _ShareToWhatsAppState();
}

class _ShareToWhatsAppState extends ConsumerState<ShareToWhatsApp> {
  bool _isSharing = false;

  Future<void> shareToWhatsApp({OrderDetailsShare? orderDetails}) async {
    if (widget.isOrderShare! && orderDetails != null) {
      final cleanersList =
          (orderDetails?.data?.staffAppointment as List?) ?? [];
      final cleaners = widget.isOrderShare!
          ? cleanersList.join('\n') // each cleaner in new line
          : cleanersList.join(' - '); // all in one line

      final cleaningSupplies = orderDetails?.data?.withCleaningSupplies == 0
          ? "NO"
          : "YES";

      final note = (orderDetails?.data?.note?.isNotEmpty ?? false)
          ? "\nNote: ${orderDetails?.data?.note}"
          : "";

      final paymentAmount = orderDetails?.data?.totalNetAmount ?? "";
      final paymentMethod = orderDetails?.data?.methodOfPayment ?? "";
      final orderAmount = "Order Amount: QR $paymentAmount\nBy $paymentMethod";

      final String message =
          '''
Booking Number: ${widget.serviceOrderId}
Supervisor Name: ${orderDetails?.data?.supervisor?.supervisorName}

Customer: ${orderDetails?.data?.customer?.customerName}
Address: ${orderDetails?.data?.customer?.zone}, ${orderDetails?.data?.customer?.location}
Mobile: ${orderDetails?.data?.customer?.phoneNumber}

${orderDetails?.data?.customer?.locationUrl}

Date: ${orderDetails?.data?.date}
Service Type: ${orderDetails?.data?.serviceType}

Shift Type: ${orderDetails?.data?.shiftType}
Duration: ${orderDetails?.data?.shiftType == "Full Day" ? "10 Hours" : "5 Hours"}

Names of Cleaners: $cleaners
Cleaning Material: $cleaningSupplies$note

$orderAmount
''';

      final whatsappUrl = Uri.parse(
        "whatsapp://send?text=${Uri.encodeComponent(message)}",
      );
      final waWebUrl = Uri.parse(
        "https://wa.me/?text=${Uri.encodeComponent(message)}",
      );

      try {
        if (await canLaunchUrl(whatsappUrl)) {
          await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
        } else if (await canLaunchUrl(waWebUrl)) {
          await launchUrl(waWebUrl, mode: LaunchMode.externalApplication);
        } else {
          debugPrint("WhatsApp not installed!");
        }
      } catch (e) {
        debugPrint("Error launching WhatsApp: $e");
      }

      await Future.delayed(const Duration(seconds: 1));
      if (mounted) setState(() => _isSharing = false);

      // return;
    } else {
      final order = widget.orderDetails;

      if (_isSharing) return; // avoid double click
      setState(() => _isSharing = true);

      final cleanersList = (order?.staffAppointment as List?) ?? [];
      final cleaners = widget.isOrderShare!
          ? cleanersList.join('\n') // each cleaner in new line
          : cleanersList.join(' - '); // all in one line

      final cleaningSupplies = order?.withCleaningSupplies == 0 ? "NO" : "YES";

      final note = (order?.note?.isNotEmpty ?? false)
          ? "\nNote: ${order?.note}"
          : "";

      final paymentAmount = order?.totalNetAmount ?? "";
      final paymentMethod = order?.methodOfPayment ?? "";
      final orderAmount = "Order Amount: QR $paymentAmount\nBy $paymentMethod";

      final String message =
          '''
Booking Number: ${widget.serviceOrderId}
Supervisor Name: ${order?.supervisor.supervisorName}

Customer: ${order?.customer.customerName}
Address: ${order?.customer.zone}, ${order?.customer.location}
Mobile: ${order?.customer.phoneNumber}

${order?.customer.locationUrl}

Date: ${order?.date}
Service Type: ${order?.serviceType}

Shift Type: ${order?.shiftType}
Duration: ${order?.shiftType == "Full Day" ? "10 Hours" : "5 Hours"}

Names of Cleaners: $cleaners
Cleaning Material: $cleaningSupplies$note

$orderAmount
    ''';

      final whatsappUrl = Uri.parse(
        "whatsapp://send?text=${Uri.encodeComponent(message)}",
      );
      final waWebUrl = Uri.parse(
        "https://wa.me/?text=${Uri.encodeComponent(message)}",
      );

      try {
        if (await canLaunchUrl(whatsappUrl)) {
          await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
        } else if (await canLaunchUrl(waWebUrl)) {
          await launchUrl(waWebUrl, mode: LaunchMode.externalApplication);
        } else {
          debugPrint("WhatsApp not installed!");
        }
      } catch (e) {
        debugPrint("Error launching WhatsApp: $e");
      }

      await Future.delayed(const Duration(seconds: 1));
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    late BuildContext dialogContext;

    ref.listen(orderDetailsNotifierProvider, (prev, next) {
      next.whenOrNull(
        loading: () {
          showGeneralDialog(
            context: context,
            pageBuilder: (ctx, animation, secondaryAnimation) {
              dialogContext = ctx;
              return PopScope(
                canPop: false,
                child: const Center(child: CircularProgressIndicator()),
              );
            },
          );
        },
        loaded: (order) {
          dialogContext.pop();
          if (order.data?.customer?.customerName != null) {
            shareToWhatsApp(orderDetails: order);
          }
        },
        error: (msg) {
          dialogContext.pop();
          BotToast.showText(text: msg);
        },
      );
    });

    return InkWell(
      onTap: () {
        if (widget.isOrderShare!) {
          ref
              .read(orderDetailsNotifierProvider.notifier)
              .getOrderDetails(widget.serviceOrderId);
        } else {
          shareToWhatsApp();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(Icons.share, size: 20.sp, color: AppColors.blueText),
      ),
    );
  }
}

// class ShareToWhatsApp extends StatelessWidget {
//   final String serviceOrderId;
//   final Details? orderDetails;
//   const ShareToWhatsApp({
//     super.key,
//     required this.serviceOrderId,
//     required this.orderDetails,
//   });
//   // https://www.waze.com/ul?ll=${orderDetails?.customer?.locationUrl?.split('=').last}
//   void shareToWhatsApp() async {
//     debugPrint("SHARE");

//     // Format cleaners list
//     final cleaners =
//         (orderDetails?.staffAppointment as List?)?.join(' - ') ?? "";

//     // Format cleaning supplies
//     final cleaningSupplies = orderDetails?.withCleaningSupplies == 0
//         ? "NO"
//         : "YES";

//     // Format note
//     final note = (orderDetails?.note != null && orderDetails!.note!.isNotEmpty)
//         ? "\nNote: ${orderDetails?.note}"
//         : "";

//     // Format payment
//     final paymentAmount = orderDetails?.totalNetAmount ?? "";
//     final paymentMethod = orderDetails?.methodOfPayment ?? "";
//     final orderAmount = "Order Amount: QR $paymentAmount\nBy $paymentMethod";

//     final String message =
//         '''
// Booking Number: $serviceOrderId
// Supervisor Name: ${orderDetails?.supervisor.supervisorName}

// Customer: ${orderDetails?.customer.customerName}
// Address: ${orderDetails?.customer.zone}, ${orderDetails?.customer.location}
// Mobile: ${orderDetails?.customer.phoneNumber}

// ${orderDetails?.customer.locationUrl}

// Date: ${orderDetails?.date}
// Service Type: ${orderDetails?.serviceType}

// Shift Type: ${orderDetails?.shiftType}
// Duration: ${orderDetails?.shiftType == "Full Day" ? "10 Hours" : "5 Hours"}

// Names of Cleaners: $cleaners
// Cleaning Material: $cleaningSupplies$note

// $orderAmount
// ''';

//     final url = Uri.parse(
//       "https://wa.me/?text=${Uri.encodeComponent(message)}",
//     );

//     if (await canLaunchUrl(url)) {
//       try {
//         await launchUrl(url, mode: LaunchMode.externalApplication);
//       } catch (e) {
//         debugPrint("Error launching WhatsApp: $e");
//       }
//     }
//   }

//   //   void shareToWhatsApp() async {
//   //     debugPrint("SHARE");
//   //     final String message =
//   //         '''
//   // Booking Number:- $serviceOrderId
//   // Supervisor Name: ${orderDetails?.supervisor.supervisorName}

//   // ${orderDetails?.customer.customerName}
//   // ${orderDetails?.customer.zone}, ${orderDetails?.customer.location}
//   // Mobile:- ${orderDetails?.customer.phoneNumber}

//   // ${orderDetails?.customer.locationUrl}

//   // Date:- ${orderDetails?.date}
//   // Service Type: ${orderDetails?.serviceType}

//   // Shift Type: ${orderDetails?.shiftType}
//   // Duration: ${orderDetails?.shiftType == "Full Day" ? "10 Hours" : "5 Hours"}

//   // Names of Cleaners: ${(orderDetails?.staffAppointment as List?)?.join(', ')}
//   // Cleaning Material: ${orderDetails?.withCleaningSupplies == 0 ? 'NO' : "YES"}
//   // ${orderDetails?.note != null ? "Note: ${orderDetails?.note}" : ""}

//   // Payment collect by ${orderDetails?.methodOfPayment} QR ${orderDetails?.totalNetAmount}

//   // Payment collect by cash QR ${orderDetails?.totalNetAmount}

//   // ''';

//   //     final url = Uri.parse(
//   //       "https://wa.me/?text=${Uri.encodeComponent(message)}",
//   //     );

//   //     if (await canLaunchUrl(url)) {
//   //       try {
//   //         await launchUrl(url, mode: LaunchMode.externalApplication);
//   //       } catch (e) {
//   //         debugPrint("Error launching WhatsApp: $e");
//   //       }
//   //     }
//   //   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: shareToWhatsApp,

//       // style: ButtonStyle(
//       //   iconColor: WidgetStateProperty.all(AppColors.primary),
//       //   backgroundColor: WidgetStatePropertyAll(AppColors.white),

//       //   shape: WidgetStateProperty.all(
//       //     RoundedRectangleBorder(
//       //       borderRadius: BorderRadius.circular(AppSizes.textFieldRadius),
//       //     ),
//       //   ),
//       // ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Icon(Icons.share, size: 20.sp, color: AppColors.blueText),
//       ),
//     );
//   }
// }
