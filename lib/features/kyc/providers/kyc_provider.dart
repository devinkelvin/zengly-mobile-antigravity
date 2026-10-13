import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_response.dart';
import '../data/models/kyc_status_model.dart';
import '../data/services/kyc_service.dart';

part 'kyc_provider.g.dart';

@riverpod
class KycNotifier extends _$KycNotifier {
  final _service = KycService();

  @override
  Future<KycStatusModel?> build() async => null;

  Future<void> fetchStatus() async {
    state = const AsyncLoading();
    final response = await _service.getKycStatus();
    state = switch (response) {
      ApiSuccess(data: final data) => AsyncData(data),
      ApiError(message: final message) => AsyncError(message, StackTrace.current),
    };
  }

  Future<ApiResponse<KycStatusModel>> verifyBvn({required String bvn}) async {
    final response = await _service.verifyBvn(bvn: bvn);
    if (response is ApiSuccess<KycStatusModel>) {
      state = AsyncData(response.data);
    }
    return response;
  }

  Future<ApiResponse<KycStatusModel>> verifyNin({
    required String nin,
    required String selfieBase64,
  }) async {
    final response = await _service.verifyNin(nin: nin, selfieBase64: selfieBase64);
    if (response is ApiSuccess<KycStatusModel>) {
      state = AsyncData(response.data);
    }
    return response;
  }
}
