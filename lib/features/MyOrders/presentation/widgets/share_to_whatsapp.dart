import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/MyOrders/data/models/orders_details_model.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareToWhatsApp extends StatelessWidget {
  final String serviceOrderId;
  final Details? orderDetails;
  const ShareToWhatsApp({
    super.key,
    required this.serviceOrderId,
    required this.orderDetails,
  });
  // https://www.waze.com/ul?ll=${orderDetails?.customer?.locationUrl?.split('=').last}

  void shareToWhatsApp() async {
    final String message =
        '''
Booking Number:- $serviceOrderId
Supervisor Name: ${orderDetails?.supervisor.supervisorName}

${orderDetails?.customer.customerName}
${orderDetails?.customer.zone}, ${orderDetails?.customer.location}
Mobile:- ${orderDetails?.customer.phoneNumber}

${orderDetails?.customer.locationUrl}

Date:- ${orderDetails?.date}
Service Type: ${orderDetails?.serviceType}

 
Shift Type: ${orderDetails?.shiftType}
Duration: ${orderDetails?.shiftType == "Full Day" ? "10 Hours" : "5 Hours"}

Names of Cleaners: ${(orderDetails?.staffAppointment as List?)?.join(', ')}
Cleaning Material: ${orderDetails?.withCleaningSupplies == 0 ? 'NO' : "YES"}
${orderDetails?.note != null ? "Note: ${orderDetails?.note}" : ""}

Payment collect by ${orderDetails?.methodOfPayment} QR ${orderDetails?.totalNetAmount}

Payment collect by cash QR ${orderDetails?.totalNetAmount}

https://admin.aldobi.com/homecleaning/hc-store/order/start/7926
''';

    final url = Uri.parse(
      "https://wa.me/?text=${Uri.encodeComponent(message)}",
    );

    if (await canLaunchUrl(url)) {
      try {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } catch (e) {
        debugPrint("Error launching WhatsApp: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: shareToWhatsApp,

      // style: ButtonStyle(
      //   iconColor: WidgetStateProperty.all(AppColors.primary),
      //   backgroundColor: WidgetStatePropertyAll(AppColors.white),

      //   shape: WidgetStateProperty.all(
      //     RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(AppSizes.textFieldRadius),
      //     ),
      //   ),
      // ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(Icons.share, size: 20.sp, color: AppColors.blueText),
      ),
    );
  }
}
// 

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hcs/features/MyOrders/data/models/orders_details_model.dart';
// import 'package:hcs/src/theme/app_colors.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ShareToWhatsApp extends StatelessWidget {
//   final String serviceOrderId;
//   final Details? orderDetails;
//   const ShareToWhatsApp({
//     super.key,
//     required this.serviceOrderId,
//     required this.orderDetails,
//   });
//   https://www.waze.com/ul?ll=${orderDetails?.customer?.locationUrl?.split('=').last}

//   void shareToWhatsApp() async {
//     final String message =
//         '''
// Booking Number: $serviceOrderId

// Supervisor Name: ${orderDetails?.supervisor?.supervisorName}

// ${orderDetails?.customer?.customerName}
// Zone ${orderDetails?.customer?.zone}, ${orderDetails?.customer?.location}
// Mobile: ${orderDetails?.customer?.phoneNumber}

// ${orderDetails?.customer?.locationUrl ?? ""}

// Driver: ${orderDetails?.driver?.driverName}
// Date: ${orderDetails?.date}
// Service Type: ${orderDetails?.serviceType}

// Shift Type: ${orderDetails?.shiftType}
// Duration: ${orderDetails?.shiftType == "Full Day" ? "10 Hours" : "5 Hours"}
// Days: ${(orderDetails?.days as List?)?.join(', ')}
// Names of Cleaners: ${(orderDetails?.staffAppointment as List?)?.join(', ')}
// Cleaning Material: ${orderDetails?.withCleaningSupplies == 0 ? 'NO' : "YES"}
// ${orderDetails?.note != null ? "Note: ${orderDetails?.note}" : ""}

// Payment collect by ${orderDetails?.methodOfPayment} QR ${orderDetails?.totalNetAmount}

// https://highclass.akwad.qa
// ''';

// final waScheme = Uri.parse('whatsapp://send?text=${Uri.encodeComponent(message)}');
//   final waWeb    = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(message)}');

//   // Try the WhatsApp app first
//   final launched = await launchUrl(
//     waScheme,
//     mode: LaunchMode.externalApplication,
//   ).catchError((_) => false);

//   if (launched == true) return;

//   // Fallback to web (needs a browser)
//   final webLaunched = await launchUrl(
//     waWeb,
//     mode: LaunchMode.externalApplication,
//   ).catchError((_) => false);

//   if (webLaunched != true) {
//     debugPrint('No app/browser available to handle WhatsApp link');
//     // Show a snackbar/toast to the user if you want
//   }

//   }

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       onPressed: shareToWhatsApp,
//       icon: Icon(Icons.share, size: 20.sp, color: AppColors.blueText),
//     );
//   }
// }
