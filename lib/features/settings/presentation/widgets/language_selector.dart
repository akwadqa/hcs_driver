import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/src/manager/app_strings.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';

class LanguageSelector extends StatefulWidget {
  final ValueChanged<String> onLanguageSelected;
  final String initialLanguage;
  const LanguageSelector({
    super.key,
    required this.onLanguageSelected,
    required this.initialLanguage,
  });

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  late String _selectedLanguage; // Default language
  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.initialLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildLanguageContainer(
          isSelected: _selectedLanguage == "en",
          title: AppStrings.english,
          onTap: () {
            setState(() => _selectedLanguage = "en");
            widget.onLanguageSelected("en");
          },
        ),
        SizedBox(height: 40.h),
        _buildLanguageContainer(
          isSelected: _selectedLanguage == "ar",
          title: AppStrings.arabic,
          onTap: () {
            setState(() => _selectedLanguage = "ar");
            widget.onLanguageSelected("ar");
          },
        ),
      ],
    );
  }

  Widget _buildLanguageContainer({
    required bool isSelected,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 114.h,
        width: 615.w,
        padding: EdgeInsets.symmetric(horizontal: 55.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyText),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 8,
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.displaySmall!.copyWith(fontSize: 26.sp),
              ),
            ),
            Expanded(
              flex: 1,
              child: Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                size: 33.sp,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
