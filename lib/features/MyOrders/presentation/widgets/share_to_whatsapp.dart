

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/MyOrders/data/models/orders_details_model.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';


class ShareToWhatsApp extends StatefulWidget {
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
  State<ShareToWhatsApp> createState() => _ShareToWhatsAppState();
}

class _ShareToWhatsAppState extends State<ShareToWhatsApp> {
  bool _isSharing = false;

Future<void> shareToWhatsApp({bool isOrderShare = false}) async {
  if (_isSharing) return; // avoid double click
  setState(() => _isSharing = true);

  final cleanersList = (widget.orderDetails?.staffAppointment as List?) ?? [];
  final cleaners = isOrderShare
      ? cleanersList.join('\n') // each cleaner in new line
      : cleanersList.join(' - '); // all in one line

  final cleaningSupplies =
      widget.orderDetails?.withCleaningSupplies == 0 ? "NO" : "YES";

  final note = (widget.orderDetails?.note?.isNotEmpty ?? false)
      ? "\nNote: ${widget.orderDetails?.note}"
      : "";

  final paymentAmount = widget.orderDetails?.totalNetAmount ?? "";
  final paymentMethod = widget.orderDetails?.methodOfPayment ?? "";
  final orderAmount = "Order Amount: QR $paymentAmount\nBy $paymentMethod";

  final String message = '''
Booking Number: ${widget.serviceOrderId}
Supervisor Name: ${widget.orderDetails?.supervisor.supervisorName}

Customer: ${widget.orderDetails?.customer.customerName}
Address: ${widget.orderDetails?.customer.zone}, ${widget.orderDetails?.customer.location}
Mobile: ${widget.orderDetails?.customer.phoneNumber}

${widget.orderDetails?.customer.locationUrl}

Date: ${widget.orderDetails?.date}
Service Type: ${widget.orderDetails?.serviceType}

Shift Type: ${widget.orderDetails?.shiftType}
Duration: ${widget.orderDetails?.shiftType == "Full Day" ? "10 Hours" : "5 Hours"}

Names of Cleaners: $cleaners
Cleaning Material: $cleaningSupplies$note

$orderAmount
''';

  final whatsappUrl =
      Uri.parse("whatsapp://send?text=${Uri.encodeComponent(message)}");
  final waWebUrl =
      Uri.parse("https://wa.me/?text=${Uri.encodeComponent(message)}");

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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:()=> shareToWhatsApp(isOrderShare:widget. isOrderShare!),
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
