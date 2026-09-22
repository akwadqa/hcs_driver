import 'package:flutter/material.dart';
import 'package:hcs_driver/src/core/enums/service_type.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

extension JobStatusColor on JobStatus {
  Color get color {
    switch (this) {
      case JobStatus.newJob:
        return AppColors.lightBlueText;

      case JobStatus.accepted:
        return AppColors.blueTitle;

      case JobStatus.onTheWay:
        return AppColors.selectedBlue;

      case JobStatus.arrived:
        return AppColors.greenText;

      case JobStatus.inProgress:
        return AppColors.primary;

      case JobStatus.completed:
        return AppColors.green;

      case JobStatus.awaitingPayment:
        return AppColors.warningPayText;

      case JobStatus.paymentReceived:
        return AppColors.greenText;

      case JobStatus.closed:
        return AppColors.darkGray;
    }
  }
}
JobStatus parseJobStatus(String status) {
  switch (status.toLowerCase()) {
    case 'new job':
      return JobStatus.newJob;
    case 'job accepted':
      return JobStatus.accepted;
    case 'on the way':
      return JobStatus.onTheWay;
    case 'arrived':
      return JobStatus.arrived;
    case 'service in progress':
      return JobStatus.inProgress;
    case 'service completed':
      return JobStatus.completed;
    case 'awaiting payment':
      return JobStatus.awaitingPayment;
    case 'payment received':
      return JobStatus.paymentReceived;
    case 'completed':
      return JobStatus.closed;
    default:
      return JobStatus.newJob;
  }
}
