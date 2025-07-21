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

${orderDetails?.customer?.customerName}
${orderDetails?.customer?.zone}, ${orderDetails?.customer?.location}
Mobile:- ${orderDetails?.customer?.phoneNumber}

${orderDetails?.customer?.locationUrl}

Date:- ${orderDetails?.date}
Number of Cleaners:- ${orderDetails?.staffAppointment?.length}
Cleaning Material:- ${orderDetails?.withCleaningSupplies == 0 ? 'No' : "Yes"}
 

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
