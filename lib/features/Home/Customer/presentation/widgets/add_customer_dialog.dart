import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/Home/Availability/presentation/controllers/availability_controller.dart';
import 'package:hcs_driver/features/Home/Customer/data/models/add_cutomer_mdoel.dart';
import 'package:hcs_driver/features/Home/Customer/presentation/controllers/customer_controller.dart';
import 'package:hcs_driver/features/Home/Customer/presentation/widgets/drop_down_textfield.dart';
import 'package:hcs_driver/src/enums/request_state.dart';
import 'package:hcs_driver/src/manager/app_strings.dart';
import 'package:hcs_driver/src/manager/validator.dart';
import 'package:hcs_driver/src/shared_widgets/custom_button.dart';
import 'package:hcs_driver/src/shared_widgets/rich_text.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

class AddCustomerDialog extends StatefulWidget {
  const AddCustomerDialog({super.key});

  @override
  State<AddCustomerDialog> createState() => _AddCustomerDialogState();
}

class _AddCustomerDialogState extends State<AddCustomerDialog> {
  final _formKey = GlobalKey<FormState>();
  String? customerType = 'Individual';
  String? customerArea = 'Al Shamal';
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerQID = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerArea = TextEditingController();
  final TextEditingController _controllerZone = TextEditingController();
  final TextEditingController _controllerLocation = TextEditingController();

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerQID.dispose();
    _controllerPhone.dispose();
    _controllerArea.dispose();
    _controllerZone.dispose();
    _controllerLocation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.dialogColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 18.h),
      // titlePadding: EdgeInsets.only(left: 75.w, right: 24.w),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 30, height: 30),
          Text(
            'New Customer',
            style: Theme.of(
              context,
            ).textTheme.displaySmall!.copyWith(fontSize: 16.sp),
          ),
          GestureDetector(
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Transform.rotate(
                angle: math.pi / 4, // rotate 45°
                child: Icon(Icons.add, color: AppColors.blackText, size: 12),
              ),
            ),
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StarredText('Customer Type'),
              8.verticalSpace,
              DropDownField(
                items: ['Company', 'Individual', 'On Call'],
                value: 'Individual',
                onChanged: (p0) {
                  customerType = p0;
                },
                enabled: true,
              ),
              24.verticalSpace,
              StarredText('Customer Name'),
              8.verticalSpace,
              TextFormField(
                controller: _controllerName,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(hintText: "Name"),
                validator: (name) =>
                    Validator.validateCustomerName(name, context),
              ),

              Consumer(
                builder: (context, ref, child) {
                  var isPackages = ref.watch(
                    availabilityControllerProvider.select(
                      (value) => value.selectedServiceType == 'Packages',
                    ),
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      24.verticalSpace,
                      StarredText('Customer QID', withStar: isPackages),
                      8.verticalSpace,
                      TextFormField(
                        controller: _controllerQID,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "12345678910",
                        ),
                        validator: isPackages
                            ? (qatarId) =>
                                  Validator.validateQatarId(qatarId, context)
                            : null,
                      ),
                    ],
                  );
                },
              ),
              24.verticalSpace,
              StarredText('Phone Number'),
              8.verticalSpace,
              TextFormField(
                controller: _controllerPhone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(hintText: "XXXXXXXX"),
                validator: (phoneNumber) =>
                    Validator.validateQatarPhone(phoneNumber, context),
              ),
              24.verticalSpace,
              StarredText('Area', withStar: false),
              8.verticalSpace,
              DropDownField(
                items: [
                  'Al Shamal',
                  'Al Khor',
                  'Al Wakrah',
                  'Ar Rayyan',
                  'Ad Dawhah (Doha)',
                  'Al Daayen',
                  'Umm Salal',
                  'Al-Shahaniya',
                ],
                value: 'Al Shamal',
                onChanged: (p0) {
                  customerArea = p0;
                },
                enabled: true,
              ),
              // TextFormField(
              //   controller: _controllerArea,
              //   keyboardType: TextInputType.number,
              //   decoration: const InputDecoration(hintText: "Area"),
              // ),
              24.verticalSpace,
              StarredText('Zone', withStar: false),
              8.verticalSpace,
              TextFormField(
                controller: _controllerZone,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(hintText: "Zone"),
              ),
              24.verticalSpace,
              StarredText(
                'Location',
                withStar: false,
                // style: Theme.of(context).textTheme.displayMedium,
              ),
              8.verticalSpace,
              TextFormField(
                keyboardType: TextInputType.streetAddress,
                minLines: 4,
                maxLines: 4,
                controller: _controllerLocation,
                decoration: const InputDecoration(
                  hintText:
                      "Paste location link here:\n\nex: https://www.google.com/maps/@?api=1&map_action=map",
                ),
              ),
              24.verticalSpace,
            ],
          ),
        ),
      ),
      actions: [
        Consumer(
          builder: (context, ref, child) {
            ref.listen(customerControllerProvider, (prev, next) {
              if (next.customersStates == RequestStates.loaded) {
                Navigator.of(context).pop();
              }
            });
            final asyncAddCutomer = ref.watch(customerControllerProvider);

            return CustomButton(
              title: AppStrings.save,
              onPressed:
                  asyncAddCutomer.customersStates == RequestStates.loading
                  ? null
                  : () {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Navigator.of(context).pop(_controller.text.trim());
                        Future(
                          () => ref
                              .read(customerControllerProvider.notifier)
                              .addCustomer(
                                AddCustomerParams(
                                  customerType: customerType,
                                  customerName: _controllerName.text,
                                  customerQid: _controllerQID.text,
                                  customerPhone: _controllerPhone.text,
                                  customerArea: customerArea,
                                  customerZone: _controllerZone.text,
                                  customerLocation: _controllerLocation.text,
                                ),
                              ),
                        );
                      }
                    },
            );
          },
        ),
      ],
    );
  }
}
