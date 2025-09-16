
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hcs_driver/features/Auth/application/auth_service.dart';
import 'package:hcs_driver/firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hcs_driver/src/core/notifications/services/notifications_service.dart';
import 'package:hcs_driver/src/riverpod_observer.dart';

abstract class AppInitializer {
  static Future<void> init() async {
    //-- Flutter init --
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    
    // -- FIREBASE INIT -- //
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // -- Initialize Notifications -- //
    // Initialize the notification service (singleton)
    // await NotificationService().initialize();
    
    
    // Note: Socket and location services will be initialized when driver logs in
    // with their auth token and driver ID
    
    //-- ENV FILE LOAD  --
    // await dotenv.load(fileName: '.env');
    // //-- Hive initialize --
    // await Hive.initFlutter();
    // await HiveInitializer.initialize();
    
    //-- Load base URL's  --
    // ServicesUrls.init();
    
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    //-- Localization init  --
    await EasyLocalization.ensureInitialized();
  }
}
Future<ProviderContainer> initializeProviders() async {
  final container = ProviderContainer(observers: [RiverpodObserver()]);
  await container.read(sharedPreferencesProvider.future);
  await container.read(notificationsServiceProvider).init();
  // await NotificationService().initialize();

    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  analytics.setAnalyticsCollectionEnabled(true);
  return container;
}
Future<void> handleSplashScreen(ProviderContainer container) async {
  const minSplashDuration = 2000;
  final startTime = DateTime.now();
  // await container.read(homeProvider.future);
  final loadDuration = DateTime.now().difference(startTime).inMilliseconds;

  if (loadDuration < minSplashDuration) {
    await Future.delayed(
      Duration(milliseconds: minSplashDuration - loadDuration),
    );
  }
  await Future.delayed(Duration(milliseconds: 2000));

  FlutterNativeSplash.remove();
}
