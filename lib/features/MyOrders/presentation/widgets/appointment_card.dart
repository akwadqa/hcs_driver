import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hcs_driver/features/MyOrders/data/models/appointments_model.dart';
import 'package:hcs_driver/features/MyOrders/presentation/controllers/myorders_controller.dart';
import 'package:hcs_driver/gen/assets.gen.dart';
import 'package:hcs_driver/src/shared_widgets/app_dialogs.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

class AppointmentCard extends ConsumerWidget {
  final Appointment appointmentData;
  // final Details? orderDetailstData;
  // final String logId;
  // final String logStatus;
  final String orderId;
  // final String driverStatus;
  // final String servicetype;
  // final String date;
  // final String employeeName;
  const AppointmentCard({
    super.key,
    required this.appointmentData,
    // required this.orderDetailstData,
    // required this.logId,
    // required this.logStatus,
    required this.orderId,
    // required this.driverStatus,
    // required this.servicetype,
    // required this.date,
    // required this.employeeName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAppointmentData = ref.read(myOrdersControllerProvider);
    return Stack(
      children: [
        Dismissible(
          key: ValueKey(appointmentData.logId), // stable key
          background: Container(
            margin: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
            padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 22.w),
            color: Colors.redAccent,
            alignment: Alignment.center,
            child: Center(child: Icon(Icons.delete, color: Colors.white)),
          ),
          confirmDismiss: (direction) async {
            if (appointmentData.serviceType != "Daily" ||
                appointmentData.logStatus != "Canceled") {
              final ok = await showAcceptCancelOrder(
                context: context,
                orderID: orderId,
                logId: appointmentData.logId,
                cancelAppointmentLog: true,
                ref: ref,
              );
              return ok;
            }
            return null; // true => card animates out, false => stays
          },

          // optional: update extra state or analytics after the animation
          onDismissed: (direction) {
            return null;
            // No-op if your provider already refetches/removes the item.
            // If needed, you can also manually remove it from local list here.
          },

          child: Card(
            color: Colors.white,
            shadowColor: Colors.transparent,
            elevation: 0,
            margin: EdgeInsets.symmetric(vertical: 18.h, horizontal: 24.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 18.w),
              child: Column(
                children: [
                  if (appointmentData.logStatus == "Cancelled")
                    Chip(
                      label: Text(
                        "Canceled",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: Colors.red.shade50,
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                    ),

                  //? for the id :
                  // AppoinmentInfoRow(
                  //   'Order Number:',
                  //   value: appointmentData.logId,
                  //   image: Assets.images.numberVector.path,
                  // ),
                  AppoinmentInfoRow(
                    'Driver Status:',
                    value: appointmentData.driverStatus,
                    image: Assets.images.driverStatus.path,
                  ),
                  AppoinmentInfoRow(
                    'Service type:',
                    value: appointmentData.serviceType,
                    image: Assets.images.serviceType.path,
                  ),
                  AppoinmentInfoRow(
                    'Date:',
                    value: appointmentData.date,
                    image: Assets.images.date.path,
                  ),
                  AppoinmentInfoRow(
                    'Employee Name:',
                    value: appointmentData.employeeName,
                    image: Assets.images.employeeName.path,
                  ),
                  AppoinmentInfoRow(
                    'supervisor Name:',
                    value: appointmentData.supervisorName,
                    image: Assets.images.employeeName.path,
                  ),
                ],
              ),
            ),
          ),
        ),

        // PositionedDirectional(
        //   start: 12,
        //   top: 12,
        //   child: InkWell(
        //     onTap: () async{
        //           await    showAcceptCancelOrder(context, orderNumber, true, ref);

        //     },
        //     child: Container(
        //       height: 25,
        //       width: 25,
        //       decoration: BoxDecoration(
        //         shape: BoxShape.circle,
        //         color: Colors.red,
        //       ),

        //       child: Icon(Icons.close, color: Colors.white),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class AppoinmentInfoRow extends StatelessWidget {
  final String? title;
  final String? value;
  final Widget? widget;
  final String image;

  const AppoinmentInfoRow(
    this.title, {
    super.key,
    this.value,
    this.widget,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return value != null
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (title != null)
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        SizedBox(
                          height: 15.sp,
                          width: 15.sp,
                          child: SvgPicture.asset(
                            image,
                            height: 15.sp,
                            width: 15.sp,
                          ),

                          //  image?.svg(
                          //   fit: BoxFit.contain,
                          //   width: 15.sp,
                          //   height: 15.sp,
                          // ),
                        ),
                        11.horizontalSpace,
                        Text(
                          title!,
                          softWrap: true,
                          style: Theme.of(
                            context,
                          ).textTheme.displayMedium!.copyWith(fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                SizedBox(width: 16.w),
                Expanded(
                  flex: 2,
                  child:
                      widget ??
                      Text(
                        "$value",
                        softWrap: true,
                        style: Theme.of(context).textTheme.displayMedium!
                            .copyWith(
                              fontSize: 12.sp,
                              color: AppColors.greyText,
                            ),
                      ),
                ),
              ],
            ),
          )
        : SizedBox();
  }
}
