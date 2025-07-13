import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hcs_driver/src/manager/app_strings.dart';

class Validator {
  // General Validators
  static String? validateRequired(String? value, String? errorKey) {
    if (value == null || value.isEmpty) {
      return errorKey ?? tr(AppStrings.fieldRequired);
    }
    return null;
  }

  static String? validatePassword(String? value, BuildContext context) {
    int passLengthRule = 6;
    if (value == null || value.isEmpty) {
      return tr(context: context, AppStrings.pleaseEnterPassword);
    }
    if (value.length < passLengthRule) {
      return (AppStrings.passwordLengthError).tr(args: ['$passLengthRule']);
    }
    return null;
  }

  static String? validateConfirmPassword(
    String? value,
    String passwordValue,
    BuildContext context,
  ) {
    if (value == null || value.isEmpty) {
      return tr(context: context, AppStrings.pleaseEnterPassword);
    }
    if (value != passwordValue) {
      return tr(context: context, AppStrings.passwordMismatch);
    }
    return null;
  }

  static String? validateCustomerName(String? value, BuildContext context) {
    return validateRequired(
      value,
      tr(context: context, AppStrings.pleaseEnterCustomerName),
    );
  }

  static String? validateUserName(String? value, BuildContext context) {
    return validateRequired(
      value,
      tr(context: context, AppStrings.pleaseEnterUserName),
    );
  }

  static String? validateQatarId(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return tr(context: context, AppStrings.pleaseEnterQatarId);
    }
    if (value.length != 11) {
      return tr(context: context, AppStrings.invalidQatarId);
    }
    return null;
  }

  static String? validateQatarPhone(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return tr(context: context, AppStrings.pleaseEnterPhoneNumber);
    }

    if (value.length != 8) {
      return tr(context: context, AppStrings.invalidPhoneNumber);
    }

    return null;
  }

  // OTP Verification Validator
  static String? validateOtp(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return "AppStrings.pleaseEnterOtp.tr(context)";
    }
    if (value.length != 6) {
      return " AppStrings.invalidOtpLength.tr(context)";
    }
    return null;
  }
}
