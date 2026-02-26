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
      case ShiftTypeEnum.morningShift:
        return "Morning Shift";
      case ShiftTypeEnum.eveningShift:
        return "Evening Shift";
      case ShiftTypeEnum.overTime:
        return "Over Time";
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