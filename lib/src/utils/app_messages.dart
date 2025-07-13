import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppMessages {
  static showSuccess({
    required String message,
    Color color = const Color(0xFF222222),
  }) {
    BotToast.showText(
      align: Alignment.bottomCenter,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      duration: const Duration(seconds: 3),
      text: message,
      contentColor: AppColors.green,
      onlyOne: true,
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    );
  }

  static showError({
    required String message,
    Color color = const Color(0xFFF91717),
  }) {
    BotToast.showText(
      text: message,
      contentColor: color,
      onlyOne: true,
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.offWhite,
      ),
    );
  }

  static showMessage({
    required String message,
    Color color = const Color(0xFF222222),
    Color textColor = Colors.white,
  }) {
    BotToast.showCustomText(
      align: Alignment.bottomCenter,
      toastBuilder: (context) => Padding(
        padding: const EdgeInsets.only(right: 12, left: 12, bottom: 30),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: color,
            boxShadow: [
              BoxShadow(
                color: AppColors.black800.withValues(alpha: 0.3),
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Text(
            message,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ),
        ),
      ),
      onlyOne: true,
    );
  }
}
