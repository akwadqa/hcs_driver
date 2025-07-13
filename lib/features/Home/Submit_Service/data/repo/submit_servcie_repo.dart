import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hcs_driver/features/Home/Submit_Service/data/models/submit_service_params.dart';
import 'package:hcs_driver/src/constants/api_constance.dart';
import 'package:hcs_driver/src/network/network_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'submit_servcie_repo.g.dart';

@Riverpod(keepAlive: true)
SubmitServiceRepository submitServiceRepository(Ref ref) =>
    SubmitServiceRepository(ref.watch(networkServiceProvider()));

class SubmitServiceRepository {
  final NetworkService _networkService;

  SubmitServiceRepository(this._networkService);

  Future<bool> submitService(SubmitServiceParams params) async {


    final response = await _networkService.post(
      ApiConstance.submitService(),
      params.toMap(),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(response.message ?? 'Failed to Get Drivers');
    }
  }
}
