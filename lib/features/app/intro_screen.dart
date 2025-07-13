import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hcs_driver/features/Auth/application/auth_service.dart';
import 'package:hcs_driver/src/routing/app_router.gr.dart';

@RoutePage()
class IntroScreen extends ConsumerWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthinticatedProvider);
    final profileRouter = AutoRouter.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isAuthenticated) {
        profileRouter.replace(const MainRoute());
      } else {
        profileRouter.replace(const LoginRoute());
      }
    });

    return const AutoRouter();
  }
}
