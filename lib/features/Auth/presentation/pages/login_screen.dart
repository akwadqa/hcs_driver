import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hcs_driver/features/Auth/data/models/login_params.dart';
import 'package:hcs_driver/features/Auth/presentation/controller/auth_controller.dart';
import 'package:hcs_driver/src/manager/validator.dart';
import 'package:hcs_driver/src/shared_widgets/custom_button.dart';
import 'package:hcs_driver/gen/assets.gen.dart';
import 'package:hcs_driver/src/manager/app_strings.dart';
import 'package:hcs_driver/src/shared_widgets/notify_snackbar.dart';
import 'package:hcs_driver/src/theme/app_colors.dart';
import 'package:hcs_driver/src/theme/app_sizes.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true; // 👈 control password visibility

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        height: screenHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: AppColors.splashGradientColors,
            stops: AppColors.splashGradientStops,
            transform: GradientRotation(138.65 * 3.14159265359 / 180),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 40.h),
                      Center(
                        child: Assets.images.logo.image(
                          fit: BoxFit.contain,
                          width: 231.w,
                          height: 231.h,
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerLeft,

                        child: Text(
                          tr(
                            context: context,
                            AppStrings.pleaseSignInToContinue,
                          ),
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      SizedBox(height: 30.h),

                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Username",

                          prefixIcon: Assets.images.userIcon.svg(
                            width: 18,
                            height: 18,
                            fit: BoxFit.scaleDown,
                          ),
                        ),

                        validator: (name) =>
                            Validator.validateUserName(name, context),
                      ),
                      SizedBox(height: AppSizes.betweenTextFields.h),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        obscuringCharacter: '*',
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: Assets.images.luckIcon.svg(
                            width: 18,
                            height: 18,
                            fit: BoxFit.scaleDown,
                          ),
                          // 👇 Suffix eye icon
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (pass) =>
                            Validator.validatePassword(pass, context),
                      ),
                      SizedBox(height: 32.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Consumer(
                          builder: (context, ref, child) {
                            var state = ref.watch(authControllerProvider);

                            return TextButton(
                              onPressed: state is AsyncLoading
                                  ? null
                                  : () {
                                      if (_emailController.text.isNotEmpty) {
                                        ref
                                            .watch(
                                              authControllerProvider.notifier,
                                            )
                                            .forgotPassword(
                                              _emailController.text,
                                            );
                                      }
                                    },
                              child: Text(
                                tr(context: context, AppStrings.forgotPassword),
                                style: Theme.of(context)
                                    .inputDecorationTheme
                                    .hintStyle!
                                    .copyWith(
                                      decoration: TextDecoration.underline,
                                      decorationStyle:
                                          TextDecorationStyle.solid,
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                      const Spacer(),
                      Consumer(
                        builder: (context, ref, child) {
                          ref.listen(authControllerProvider, (prev, next) {
                            if (prev is AsyncLoading && next is AsyncData) {
                              notifyUser(
                                context: context,
                                message: 'Request has been sent successfully',
                                success: true,
                              );
                            } else if (next is AsyncError) {
                              notifyUser(
                                context: context,
                                message: next.error.toString(),
                                success: false,
                              );
                            }
                          });
                          final asyncLogin = ref.watch(authControllerProvider);

                          return CustomButton(
                            title: tr(context: context, AppStrings.login),
                            onPressed: asyncLogin is AsyncLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      ref
                                          .read(authControllerProvider.notifier)
                                          .login(
                                            LoginParams(
                                              email: _emailController.text,
                                              pass: _passwordController.text,
                                            ),
                                          );
                                    }
                                  },
                          );
                        },
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
