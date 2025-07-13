// import 'dart:developer';

// import 'package:dio/dio.dart';
// import 'package:get_it/get_it.dart';
// import 'package:hcs/features/Auth/data/datasources/auth_service.dart';
// import 'package:hcs/features/Auth/data/models/user_info.dart';
// import 'package:hcs/features/Auth/presentation/bloc/auth_controller.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:hcs/features/Auth/data/datasources/auth_remote_datasource.dart';
// import 'package:hcs/features/Auth/domain/repositories/auth_base_repo.dart';
// import 'package:hcs/features/Auth/domain/usecases/change_pass_usecase.dart';
// import 'package:hcs/features/Auth/domain/usecases/forgot_pass_usecase.dart';
// import 'package:hcs/features/Auth/domain/usecases/get_user_info_usecse.dart';
// import 'package:hcs/features/Auth/domain/usecases/login_usecase.dart';
// import 'package:hcs/features/Auth/domain/usecases/logout_usecase.dart';
// import 'package:hcs/features/Auth/domain/usecases/otp_usecsae.dart';
// import 'package:hcs/features/Auth/domain/usecases/register_usecase.dart';
// import 'package:hcs/features/Auth/domain/usecases/resend_otp_usecase.dart';
// import 'package:hcs/features/Auth/domain/usecases/update_user_usecase.dart';

// import 'package:hcs/src/constants/api_constance.dart';

// import '../../features/Auth/data/repositories/auth_repo.dart';

// final GetIt sl = GetIt.instance;

// class ServicesLocator {
//   static setup() async {
//     // await _setupLocalStorage();
//     // _injectNetworkingDependencies();

//     _injectBlocProviders();

//     await _core();

//     _injectUseCases();

//     _injectRepositories();

//     _injectDataSources();
//   }

//   static _injectBlocProviders() {
//     sl.registerLazySingleton(() => AuthNotifier(
//           loginUseCase: sl<LoginUseCase>(),
//           // checkLoginUseCase: sl<CheckLoginUseCase>(),
//           registerUseCase: sl<RegisterUseCase>(),
//           forgotPassUseCase: sl<ForgotPassUseCase>(),
//           changePassUseCase: sl<ChangePassUseCase>(),
//           confirmationOTPUseCase: sl<ConfirmationOTPUseCase>(),
//           logoutUseCase: sl<LogoutUseCase>(),
//           getUserUseCase: sl<GetUserUseCase>(),
//           updateUserUseCase: sl<UpdateUserUseCase>(),
//           resendOTPUseCase: sl<ResendOTPUseCase>(),
//           // dataStore: sl<DataStore>()
//         ));

//     // sl.registerLazySingleton(() => PostsBloc(
//     //     getPropertiesFilteredUseCase: sl<GetPropertiesFilteredUseCase>(),
//     //     getCarsFilteredUseCase: sl<GetCarsFilteredUseCase>(),
//     //     getMyPropertiesUseCase: sl<GetMyPropertiesUseCase>(),
//     //     deleteMyCarUseCase: sl<DeleteMyCarUseCase>(),
//     //     getMyCarsUseCase: sl<GetMyCarsUseCase>(),
//     //     postCarUseCase: sl<PostCarUseCase>(),
//     //     deleteMyPropertyUseCase: sl<DeleteMyPropertyUseCase>(),
//     //     postPropertyUseCase: sl<PostPropertyUseCase>(),
//     //     getNotificationsUseCase: sl<GetNotificationsUseCase>()));
//   }

//   static _injectRepositories() {
//     sl.registerLazySingleton<AuthBaseRepo>(() => AuthRepo(
//           authBaseRemoteDatasource: sl<AuthBaseRemoteDatasource>(),
//           // dataStore: sl<DataStore>()
//         ));


//   }

//   static _injectDataSources() async {
//     sl.registerLazySingleton<AuthBaseRemoteDatasource>(
//         () => AuthRemoteDatasource(
//             // dataStore: sl<DataStore>()
//             ));


//   }

//   static _injectUseCases() {
//     //* Auth UseCases
//     sl.registerLazySingleton(
//         () => LoginUseCase(authBaseRepo: sl<AuthBaseRepo>()));
//     // sl.registerLazySingleton(
//     //     () => CheckLoginUseCase(authBaseRepo: sl<AuthBaseRepo>()));
//     sl.registerLazySingleton(
//         () => RegisterUseCase(authBaseRepo: sl<AuthBaseRepo>()));
//     sl.registerLazySingleton(
//         () => ForgotPassUseCase(authBaseRepo: sl<AuthBaseRepo>()));
//     sl.registerLazySingleton(
//         () => ChangePassUseCase(authBaseRepo: sl<AuthBaseRepo>()));
//     sl.registerLazySingleton(
//         () => ConfirmationOTPUseCase(authBaseRepo: sl<AuthBaseRepo>()));
//     sl.registerLazySingleton(
//         () => ResendOTPUseCase(authBaseRepo: sl<AuthBaseRepo>()));
//     sl.registerLazySingleton(
//         () => LogoutUseCase(authBaseRepo: sl<AuthBaseRepo>()));
//     sl.registerLazySingleton(
//         () => GetUserUseCase(authBaseRepo: sl<AuthBaseRepo>()));
//     sl.registerLazySingleton(
//         () => UpdateUserUseCase(authBaseRepo: sl<AuthBaseRepo>()));

   
//   }

//   static _core() async {
//     // sl.registerLazySingleton(() => DataStore());

//     final SharedPreferences sharedPreferences =
//         await SharedPreferences.getInstance();
//     sl.registerLazySingleton(() => sharedPreferences);

//     //Dio injection
//     sl.registerLazySingleton<Dio>(() {
//       final BaseOptions baseOptions = BaseOptions(
//         validateStatus: (_) => true,
//         baseUrl: ApiConstance.baseUrl, //! Set your base URL
//         connectTimeout:
//             const Duration(seconds: 25), //! Set your connect timeout
//         receiveTimeout:
//             const Duration(seconds: 25), //! Set your receive timeout
//       );

//       final Dio dio = Dio(baseOptions);

//       //! Add Bearer token interceptor
//       dio.interceptors.add(PrettyDioLogger(
//         requestHeader: true,
//         requestBody: true,
//         responseBody: true,
//         responseHeader: false,
//         error: true,
//         compact: true,
//         maxWidth: 50,
//       ));
//       dio.interceptors.add(InterceptorsWrapper(
//         onRequest:
//             (RequestOptions options, RequestInterceptorHandler handler) async {
//           //! Retrieve and set the user's bearer token
//           // final DataStore dataStore = DataStore();
//           // UserInfo? userInfo = await dataStore.getUserInfo();
//               // final userData = ref.watch(userDataProvider);

//           UserInfo? userInfo = await 

//            sl.get<DataStore>().getUserInfo();

//           String? token;

//           //! Replace with your actual auth service
//           if (userInfo != null) {
//             token = userInfo.token;
//             options.headers["Content-Type"] = "application/json";
//             options.headers['Authorization'] = 'Bearer $token';
//             log("token is: $token");
//           }

//           return handler.next(options);
//         },
//       ));

//       return dio;
//     });
//   }
// }
