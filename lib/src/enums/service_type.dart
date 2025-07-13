enum ServiceType {
  onCall,
  packages,
  deepClean,
  maintenance,
  //
  home,
  myOrders,
  settings,
}

String serviceTypeToString(ServiceType serviceType) {
  switch (serviceType) {
    case ServiceType.onCall:
      return 'On Call';
    case ServiceType.packages:
      return 'Packages';
    case ServiceType.deepClean:
      return 'Deep Clean';
    case ServiceType.maintenance:
      return 'Maintenance';
    case ServiceType.home:
      return 'High Class Services';
    case ServiceType.myOrders:
      return 'My Orders';
    case ServiceType.settings:
      return 'Settings';
  }
}

ServiceType stringToServiceType(String string) {
  switch (string) {
    case 'On Call':
      return ServiceType.onCall;
    case 'Packages':
      return ServiceType.packages;
    case 'Deep Clean':
      return ServiceType.deepClean;
    case 'Maintenance':
      return ServiceType.maintenance;
    case 'High Class Services':
      return ServiceType.home;
    case 'My Orders':
      return ServiceType.myOrders;
    case 'Settings':
      return ServiceType.settings;
    default:
      return ServiceType.home;
  }
}

enum ShiftType { morning, evening, fullDay }

String shiftTypeToString(ShiftType shiftType) {
  switch (shiftType) {
    case ShiftType.morning:
      return 'Morning Shift';
    case ShiftType.evening:
      return 'Evening Shift';
    case ShiftType.fullDay:
      return 'Full Day';
  }
}

ShiftType stringToShiftType(String string) {
  switch (string) {
    case 'Morning':
      return ShiftType.morning;
    case 'Evening':
      return ShiftType.evening;
    case 'Full Day':
      return ShiftType.fullDay;
    default:
      return ShiftType.fullDay;
  }
}

enum ServiceCategory { onCall, stayIn, company, flexible }

String serviceCategoryToString(ServiceCategory serviceCategory) {
  switch (serviceCategory) {
    case ServiceCategory.onCall:
      return 'on Call';
    case ServiceCategory.stayIn:
      return 'Stay - In';
    case ServiceCategory.company:
      return 'Company';
    case ServiceCategory.flexible:
      return 'Flexible';
  }
}

//Payment Enums
enum PaymentMethod { skipCash, cash }

String paymentMethodToString(PaymentMethod paymentMethod) {
  switch (paymentMethod) {
    case PaymentMethod.skipCash:
      return 'SkipCash';
    case PaymentMethod.cash:
      return 'Cash';
  }
}
