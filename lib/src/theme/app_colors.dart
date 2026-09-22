import 'package:flutter/material.dart';

abstract class AppColors {
  static const List<Color> splashGradientColors = [
    Color(0xFFF4F9FF),
    Color(0xFFE3F0FF),
  ];
  static const List<double> splashGradientStops = [0.234, 0.5324];
  static LinearGradient get splashGradient => const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        stops: splashGradientStops,
        transform: GradientRotation(138.65 * 3.14159265359 / 180),
        colors: splashGradientColors,
      );

  static const List<Color> serviceCardGradientColors = [
    Color(0x251E71A3),
    Color(0xFF034C78),
  ];
  static const List<double> serviceCardGradientStops = [0.0, 0.9856];

  static LinearGradient get serviceCardGradient => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: serviceCardGradientStops,
        colors: serviceCardGradientColors,
      );

  static Color getServiceTypeColor(String type) {
    switch (type.trim()) {
      case 'Flexible':
        return AppColors.serviceTypeBg; // لون بنفسجي فاتح (كما في التصميم)
      case 'Daily':
        return const Color(0xFF90CAF9); // لون أزرق فاتح
      case 'Deep Clean':
        return const Color(0xFF80CBC4); // لون أخضر مزرق (تيل)
      case 'Maintenance':
        return const Color(0xFFFFCC80); // لون برتقالي فاتح
      default:
        return const Color(
            0xFFEEEEEE); // لون رمادي افتراضي في حال لم تتطابق الكلمة
    }
  }

  static Color getServiceTypeTextColor(String type) {
    switch (type.trim()) {
      case 'Flexible':
        return const Color(0xFF512DA8); // بنفسجي غامق حاد
      case 'Daily':
        return const Color(0xFF1565C0); // أزرق غامق
      case 'Deep Clean':
        return const Color(0xFF00695C); // تيل/أخضر غامق
      case 'Maintenance':
        return const Color(0xFFE65100); // برتقالي غامق
      default:
        return const Color(0xFF424242); // رمادي غامق افتراضي
    }
  }

  static Color getDriverStatusTextColor(String status) {
    switch (status.trim()) {
      case 'New job':
        return const Color(0xFF1565C0); // أزرق غامق
      case 'Job Accepted':
        return const Color(0xFFF57F17); // أصفر/خردلي غامق
      case 'On The Way':
        return const Color(0xFFE65100); // برتقالي غامق
      case 'Arrived':
        return const Color(0xFF6A1B9A); // بنفسجي غامق
      case 'Service in Progress':
        return const Color(0xFF2E7D32); // أخضر غامق حاد (مثل الصورة)
      case 'Service Completed':
      case 'Completed':
        return const Color(0xFF1B5E20); // أخضر زيتي غامق
      case 'Awaiting Payment':
        return const Color(0xFFC62828); // أحمر غامق
      case 'Payment Received':
        return const Color(0xFF33691E); // أخضر ليموني غامق
      default:
        return const Color(0xFF424242); // رمادي غامق افتراضي
    }
  }

  static Color getDriverStatusBgColor(String status) {
    switch (status.trim()) {
      case 'New job':
        return const Color(0xFFE3F2FD); // أزرق فاتح جداً
      case 'Job Accepted':
        return const Color(0xFFFFF9C4); // أصفر فاتح
      case 'On The Way':
        return const Color(0xFFFFE0B2); // برتقالي فاتح
      case 'Arrived':
        return const Color(0xFFE1BEE7); // وردي/بنفسجي فاتح
      case 'Service in Progress':
        return const Color(0xFFE8F5E9); // أخضر فاتح (كما في التصميم)
      case 'Service Completed':
        return const Color(0xFFC8E6C9); // أخضر
      case 'Awaiting Payment':
        return const Color(0xFFFFCDD2); // أحمر فاتح
      case 'Payment Received':
        return const Color(0xFFDCEDC8); // أخضر مصفر
      case 'Completed':
        return const Color(0xFFA5D6A7); // أخضر غامق قليلاً
      default:
        return const Color(0xFFF5F5F5); // رمادي افتراضي
    }
  }

  static const Color scaffoldColor = Color(0xFFE9EFFE);
  static const Color dialogColor = Color(0xFFF0F4FE);
  static const Color tabBarColor = Color(0xFFE8F6FF);

  static const Color primary = Color(0xFF1E71A3); //#1E71A3
  static const Color greyText = Color(0xFF7C7F88); //#7C7F88
  static const Color blackText = Color(0xFF363A46); // #363A46
  static const Color blueTitle = Color(0xFF1E7BE2); //#1E7BE2
  static const Color blueText = Color(0xFF1E71A3); //#1E71A3
  static const Color lightBlueText = Color(0xFF85B2CD); //#85B2CD
  static const Color greenText = Color(0xFF0BA366); //#0BA366

  static const Color red = Color(0xFFF0453F);
  static const Color unSelectedText = Color(0xFF878787); //#878787
  static const Color unSelectedGrey = Color(0xFFDCE6EC); //##DCE6EC
  static const Color selectedBlue = Color(0xFF003A5D); //#003A5D
  static const Color tabsBackground = Color(0xFFCDCDCD);
  static const Color disabledButtonBackground = Color(0xB871A3B2);
  static const Color backArrow = Color(0xB8034C78);
  static const Color dividerGrey = Color(0xffC2C2C2);

  static const Color statusGreenBg = Color(0xFFEAF6EC);
  static const Color statusGreenText = Color(0xFF1B9B49);
  static const Color statusGreenDot = Color(0xFF20A14F);
  static const Color serviceTypeBg = Color(0xFFE4DAFF);
  static const Color serviceTypeText = Color(0xFF6F46DB);
  static const Color labelGrey = Color(0xFF767676);
  static const Color dividerColor = Color(0xFFD8D8D8);
  static const Color borderGrey = Color(0xFFA1A1A1);
  static const Color iconBg = Color(0xFFEEF6FF);

  static const Color darkText = Color(0xFF27272A);
  static const Color locationBg = Color(0xFFFFEFF3);
  static const Color locationRed = Color(0xFFCF1515);
  static const Color shiftBg = Color(0xFFE4F0FF);

  //////////////////////////////////*

  static const Color primaryLight = Color(0x6E6A43BC);
  static const Color warningPayText = Color(0xFF808285);
  static const Color cardGrey = Color(0xFFDEDEDE);

  static const Color profileName = Color(0xFFD1D3D4);

  static Color hexToColor(String? hex) {
    // Remove the '#' character if it exists
    // Prepend 'FF' to represent full opacity if there is no alpha component
    if (hex == null) return primary;
    return Color(int.parse(hex.replaceAll("#", "0xff")));
  }
  //===================================================================
  //===================================================================
  //===================================================================

  static const MaterialColor primarySwatch = MaterialColor(
    0xFF1E71A3,
    <int, Color>{
      50: Color(0xFFE3F2F9),
      100: Color(0xFFB3DCF0),
      200: Color(0xFF81C6E6),
      300: Color(0xFF4EAFDC),
      400: Color(0xFF289DD4),
      500: Color(0xFF1E71A3), // Base color
      600: Color(0xFF1A6594),
      700: Color(0xFF165683),
      800: Color(0xFF124873),
      900: Color(0xFF0A2F56),
    },
  );

  static const Color white = Color(0xFFFFFFFF);
  static const Color gray = Color(0xFFAAAAAA);
  static const Color rose = Color(0xFFF8D5CC);
  static const Color darkRed = Color(0xFFBC0000);
  static const Color black900 = Color(0xFF484848);
  static const Color lightGray = Color(0xFFE5E5E5);
  static const Color grey600 = Color(0xFF757575);
  static const Color green = Color(0xFF69A94B);
  static const Color mediumGray = Color(0xFFD7D7D7);
  static const Color grayBorder = Color(0xFFCCCCCC);
  static const Color darkGray = Color(0xFF727272);
  static const Color lightGray01 = Color(0xFFF1F1F1);
  static const Color lightGray02 = Color(0xFFD9D9D9); // A7A9A
  static const Color gray02 = Color(0xFF888888);
  static const Color black800 = Color(0xFF444444);
  static const Color stoneGray = Color(0xFF949494);
  static const Color offWhite = Color(0xFFF6F6F6);
  static const Color lightPeach = Color(0xFFFFF5F1);
  static const Color dimGray = Color(0xFF555555);
  static const Color grayishCharcoal = Color(0xFF595959);
}
