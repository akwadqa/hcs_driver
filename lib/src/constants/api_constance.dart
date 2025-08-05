class ApiConstance {
  static const String baseUrl = "https://highclass.akwad.qa/api/method";
  static const String baseDomain = "highclass";
  static const String baseImageUrl = 'https://$baseDomain.akwad.qa/';

  static String imageUrl(String? path) {
    if (path != null) {
      return '$baseImageUrl$path';
    } else {
      return 'https://picsum.photos/600/400?random=1';
    }
  }

  ////////////////// *  Login   /////////////////////
  static const String loginPath =
      '$baseUrl/$baseDomain.api.authentication.login';
  static String forgotPassword(String email) =>
      '$baseUrl/frappe.core.doctype.user.user.reset_password?user=$email';
  ////////////////// *  Customers   /////////////////////
  static String getCustomers({
    required String page,
    required String customerName,
  }) =>
      '$baseUrl/$baseDomain.api.customer.customers?page=$page&limit=100&customer_name=$customerName';
  static String addCustomers = '$baseUrl/$baseDomain.api.customer.customer';

  ////////////////// *  Availabillty   /////////////////////
  static String getPackages =
      '$baseUrl/$baseDomain.api.service_type.service_types';

  ////////////////// *  Employees   /////////////////////

  static String getEmployees({
    required String serviceType,
    required String date,
    required List<String> days,
    required String shift,
    String? serviceCategory,
    String? employeeName,
    required String page,
  }) {
    // return 'https://highclass.akwad.qa/api/method/highclass.api.employee.employees?service_type=Flexible – 8 visits/month&date=2025-06-28&shift=Full Day&designation=&service_category=Company&days=["monday", "wednesday"]&page=1&limit=10';
    final Map<String, String> queryParams = {
      'service_type': serviceType,
      'date': date,
      'shift': shift,
      'designation': '',
      'page': page,
      'limit': '10',
    };

    if (serviceCategory != null && serviceCategory.isNotEmpty) {
      queryParams['service_category'] = serviceCategory;
    }

    if (days.isNotEmpty) {
      queryParams['days'] = days.isEmpty ? '' : '$days';
    }

    if (employeeName != null && employeeName.isNotEmpty) {
      queryParams['employee_name'] = employeeName;
    }

    final uri = Uri.parse(
      '$baseUrl/$baseDomain.api.employee.employees',
    ).replace(queryParameters: queryParams);

    // print('Request URL: $uri');

    return uri.toString();
  }

  ////////////////// *  Drivers   /////////////////////
  static String getDrivers(String page) =>
      '$baseUrl/$baseDomain.api.driver.drivers?page=$page&limit=25';

  static String getDiscoutType() =>
      '$baseUrl/$baseDomain.api.discount_type.discount_types';
  ////////////////// *  SubmitService   /////////////////////
  static String submitService() =>
      '$baseUrl/$baseDomain.api.service_order.service_order';

  //////////////////! *  MyOrders Services   /////////////////////
  static String myServicesOrders({
    required String page,
    // required String status,
    required String dateType,
  }) =>
      // '$baseUrl/$baseDomain.api.service_order.service_orders?page=$page&limit=10&status=$status';
      '$baseUrl/$baseDomain.api.service_order.service_orders?page=$page&limit=10&status=Approved&date_type=$dateType';

  static String getServiceOrderDetails({required String staffAppointmentLog}) =>
      // 'https://highclass.akwad.qa/api/method/highclass.api.staff_appointment_log.staff_appointment_log_details?staff_appointment_log=SAL-59593-2025&';
      '$baseUrl/$baseDomain.api.staff_appointment_log.staff_appointment_log_details?staff_appointment_log=$staffAppointmentLog';

  static String orderCancelltion() =>
      '$baseUrl/$baseDomain.api.service_order.cancel_service_order';

  static String updateStatusOrder =
      '$baseUrl/$baseDomain.api.staff_appointment_log.update_driver_status';

  static String appontmentsLogs({required int page, required String orderId}) =>
      '$baseUrl/$baseDomain.api.staff_appointment_log.staff_appointment_logs?search&status=&date_type=&page=$page&limit=10&sort_by&sort=&order_id=$orderId';

  static String appontmentsLogsDetails({
    required int page,
    required String staffAppointmentLog,
  }) =>
      '$baseUrl/$baseDomain.api.staff_appointment_log.staff_appointment_log_details?staff_appointment_log=$staffAppointmentLog';
}
