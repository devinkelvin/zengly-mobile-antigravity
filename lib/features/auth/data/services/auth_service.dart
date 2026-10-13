import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../models/auth_session.dart';
import '../models/user_model.dart';
import '../models/verification_result.dart';

// NOTE: All network calls in this service are temporarily commented out and
// replaced with mock success responses while the UI is being built out.
// Re-enable the real ApiClient calls once backend integration starts.
class AuthService {
  AuthService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  // ignore: unused_field
  final ApiClient _apiClient;

  Future<ApiResponse<VerificationResult>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNo,
  }) async {
    // return _apiClient.post(
    //   'auth/signup',
    //   (json) => VerificationResult.fromJson(json),
    //   data: {
    //     'firstName': firstName,
    //     'lastName': lastName,
    //     'email': email,
    //     'password': password,
    //     'phoneNumber': phoneNo,
    //   },
    // );
    return const ApiResponse.success(
      VerificationResult(verificationId: 'mock-verification-id'),
    );
  }

  Future<ApiResponse<AuthSession>> login({
    required String email,
    required String password,
  }) async {
    // return _apiClient.post(
    //   'auth/login',
    //   (json) => AuthSession.fromJson(json),
    //   data: {'email': email, 'password': password},
    // );
    return ApiResponse.success(
      AuthSession(
        user: UserModel(
          userId: 'mock-user-id',
          email: email,
          firstName: 'Mock',
          lastName: 'User',
          phoneNumber: '',
          hasCreatedPin: true,
          hasLocalAuth: false,
        ),
        accessToken: 'mock-access-token',
        refreshToken: 'mock-refresh-token',
      ),
    );
  }

  Future<ApiResponse<AuthSession>> verifyEmail({
    required String verificationId,
    required String otpCode,
  }) async {
    // return _apiClient.post(
    //   'auth/email/verify',
    //   (json) => AuthSession.fromJson(json),
    //   data: {'varificationId': verificationId, 'otpCode': otpCode},
    // );
    return const ApiResponse.success(
      AuthSession(
        user: UserModel(
          userId: 'mock-user-id',
          hasCreatedPin: false,
          hasLocalAuth: false,
        ),
        accessToken: 'mock-access-token',
        refreshToken: 'mock-refresh-token',
      ),
    );
  }

  Future<ApiResponse<dynamic>> resendOtp({required String email}) async {
    // return _apiClient.post(
    //   'auth/resend-otp',
    //   (json) => json,
    //   data: {'email': email},
    // );
    return const ApiResponse.success(null);
  }

  Future<ApiResponse<dynamic>> resendOtpForgotPassword({
    required String email,
  }) async {
    // return _apiClient.post(
    //   'auth/resend-opt-reset-password',
    //   (json) => json,
    //   data: {'email': email},
    // );
    return const ApiResponse.success(null);
  }

  Future<ApiResponse<VerificationResult>> forgotPassword({
    required String email,
  }) async {
    // return _apiClient.post(
    //   'auth/forgot-password',
    //   (json) => VerificationResult.fromJson(json),
    //   data: {'email': email},
    // );
    return const ApiResponse.success(
      VerificationResult(verificationId: 'mock-verification-id'),
    );
  }

  Future<ApiResponse<dynamic>> resetPassword({
    required String verificationId,
    required String otp,
    required String password,
  }) async {
    // return _apiClient.post(
    //   'auth/reset-password',
    //   (json) => json,
    //   data: {
    //     'verificationId': verificationId,
    //     'otpCode': otp,
    //     'password': password,
    //   },
    // );
    return const ApiResponse.success(null);
  }

  Future<ApiResponse<dynamic>> logOut() async {
    // return _apiClient.get('auth/logout', (json) => json);
    return const ApiResponse.success(null);
  }
}
