import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../models/kyc_status_model.dart';

// NOTE: All network calls in this service are temporarily commented out and
// replaced with mock success responses while the UI is being built out.
// Re-enable the real ApiClient calls once backend integration starts.
class KycService {
  KycService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  // ignore: unused_field
  final ApiClient _apiClient;

  Future<ApiResponse<KycStatusModel>> getKycStatus() async {
    // return _apiClient.get('kyc/status', (json) => KycStatusModel.fromJson(json));
    return const ApiResponse.success(
      KycStatusModel(overallStatus: 'PENDING', verifications: []),
    );
  }

  Future<ApiResponse<KycStatusModel>> verifyBvn({required String bvn}) async {
    // return _apiClient.post(
    //   'kyc/bvn',
    //   (json) => KycStatusModel.fromJson(json),
    //   data: {'bvn': bvn},
    // );
    return const ApiResponse.success(
      KycStatusModel(
        overallStatus: 'PENDING',
        verifications: [
          KycVerification(type: 'BVN', status: 'VERIFIED'),
        ],
      ),
    );
  }

  Future<ApiResponse<KycStatusModel>> verifyNin({
    required String nin,
    required String selfieBase64,
  }) async {
    // return _apiClient.post(
    //   'kyc/nin',
    //   (json) => KycStatusModel.fromJson(json),
    //   data: {'nin': nin, 'selfieImage': selfieBase64},
    // );
    return const ApiResponse.success(
      KycStatusModel(
        overallStatus: 'PENDING',
        verifications: [
          KycVerification(type: 'NIN', status: 'VERIFIED'),
        ],
      ),
    );
  }
}
