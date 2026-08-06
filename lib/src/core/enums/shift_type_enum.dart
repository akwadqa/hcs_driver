import 'package:easy_localization/easy_localization.dart';

enum ShiftTypeEnum {
  fullDay,
  morningShift,
  eveningShift,
  overTime,
}

extension ShiftTypeEnumX on ShiftTypeEnum {

  /// Label for UI
  String get label {
    switch (this) {
      case ShiftTypeEnum.fullDay:
        return "Full Day";
        // return "fullDay".tr();
      case ShiftTypeEnum.morningShift:
        return "Morning Shift";
        // return "morningShift".tr();
      case ShiftTypeEnum.eveningShift:
        return "Evening Shift";
        // return "eveningShift".tr();
      case ShiftTypeEnum.overTime:
        return "Over Time";
        // return "overTime".tr();
    }
  }

  /// Value sent to API
  String get apiValue {
    switch (this) {
      case ShiftTypeEnum.fullDay:
        return "Full Day";
      case ShiftTypeEnum.morningShift:
        return "Morning Shift";
      case ShiftTypeEnum.eveningShift:
        return "Evening Shift";
      case ShiftTypeEnum.overTime:
        return "OverTime";
    }
  }
}