// import 'package:hcs/features/settings/presentation/controller/settings_state.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'settings_controller.g.dart';

// @riverpod
// class SettingsController extends _$SettingsController {
//   @override
//   SettingsState build() => ProfileInitial();

//   // Future<void> getProfile() async {
//   //   state = ProfileLoading();

//   //   try {
//   //     final profileRepo = ref.read(settingsRepositoryProvider);
//   //     final profileData = await profileRepo.getProfile();

//   //     state = ProfileLoaded(
//   //       profileModel: profileData,
//   //       message: profileData.message,
//   //     );
//   //   } catch (e) {
//   //     debugPrint("statement catch error is :$e");

//   //     state = ProfileError(message: e.toString());
//   //   }
//   // }

//   // Future<void> updateProfile({required ProfileParams params}) async {
//   //   state = ProfileLoading();

//   //   try {
//   //     final profileRepo = ref.read(settingsRepositoryProvider);
//   //     final profileData = await profileRepo.updateProfile(params: params);

//   //     state = ProfileLoaded(
//   //       profileModel: profileData,
//   //       message: profileData.message,
//   //     );
//   //   } catch (e) {
//   //     debugPrint("statement catch error is :$e");

//   //     state = ProfileError(message: e.toString());
//   //   }
//   // }
// }
