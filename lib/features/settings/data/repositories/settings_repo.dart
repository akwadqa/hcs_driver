// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hcs/src/network/network_service.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'settings_repo.g.dart';

// @Riverpod(keepAlive: true)
// SettingsRepository settingsRepository(Ref ref) =>
//     SettingsRepository(ref.watch(networkServiceProvider()));

// class SettingsRepository {
//   final NetworkService _networkService;

//   SettingsRepository(this._networkService);

//   // Future<ProfileModel> getProfile() async {
//   //   final response = await _networkService.get(ApiConstance.profile);
//   //   if (response.statusCode == 200) {
//   //     return ProfileModel.fromJson(response.data);
//   //   } else {
//   //     throw Exception(response.message ?? 'Failed to load home blocks');
//   //   }
//   // }

//   // Future<ProfileModel> updateProfile({required ProfileParams params}) async {
//   //   var dataMap = <String, dynamic>{};

//   //   // Handle image file if imagePath is provided
//   //   if (params.imagePath != null) {
//   //     final file = await MultipartFile.fromFile(
//   //       params.imagePath!,
//   //       filename: params.imagePath!.split('/').last,
//   //     );
//   //     dataMap['file'] = [file];
//   //   }

//   //   if (params.name != null) dataMap['name'] = params.name;
//   //   if (params.mobileNo != null) dataMap['mobile_no'] = params.mobileNo;
//   //   if (params.password != null) dataMap['password'] = params.password;

//   //   var data = FormData.fromMap(dataMap);

//   //   debugPrint('oooooooooo2oooooooooo ${data.toString()}');

//   //   final response = await _networkService.put(ApiConstance.profile, data);

//   //   // final data = json.encode(response.data);

//   //   if (response.statusCode == 200) {
//   //     return ProfileModel.fromJson(response.data);
//   //   } else {
//   //     throw Exception(response.message ?? 'Failed to load home blocks');
//   //   }
//   // }

// }
