import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';

// NOTE: All network calls in this service are temporarily commented out and
// replaced with mock success responses while the UI is being built out.
// Re-enable the real ApiClient calls once backend integration starts.
class PinService {
  PinService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  // ignore: unused_field
  final ApiClient _apiClient;

  Future<ApiResponse<dynamic>> createPin({required String pin}) async {
    // return _apiClient.post(
    //   'user/pin/create',
    //   (json) => json,
    //   data: {'pin': pin},
    // );
    return const ApiResponse.success(null);
  }
}
