import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/src/di/app_initializer.dart';
import 'features/app/app.dart';

Future<void> main() async {
  await AppInitializer.init();

  final container = await initializeProviders();

  await handleSplashScreen(container);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (_, child) => UncontrolledProviderScope(
        container: container,
        child: EasyLocalization(
          supportedLocales: const [Locale('en'), Locale('ar')],
          path: 'assets/translations',
          child: const App(),
        ),
      ),
    ),
  );
}
