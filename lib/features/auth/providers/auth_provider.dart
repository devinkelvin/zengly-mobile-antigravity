import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../controller/storage/storage.dart';
import '../../../core/network/api_response.dart';
import '../data/models/auth_session.dart';
import '../data/models/user_model.dart';
import '../data/models/verification_result.dart';
import '../data/services/auth_service.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  final _service = AuthService();
  final _storage = LocalStorage();

  @override
  Future<UserModel?> build() => _loadPersistedUser();

  Future<UserModel?> _loadPersistedUser() async {
    final userJson = await _storage.readData(LocalStorage.user);
    if (userJson == null) return null;
    return UserModel.fromRawJson(userJson);
  }

  Future<ApiResponse<VerificationResult>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNo,
  }) {
    return _service.signUp(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      phoneNo: phoneNo,
    );
  }

  Future<ApiResponse<AuthSession>> login({
    required String email,
    required String password,
  }) async {
    final response = await _service.login(email: email, password: password);
    if (response is ApiSuccess<AuthSession>) {
      await _persistSession(response.data);
    }
    return response;
  }

  Future<ApiResponse<AuthSession>> verifyEmail({
    required String verificationId,
    required String otpCode,
  }) async {
    final response = await _service.verifyEmail(
      verificationId: verificationId,
      otpCode: otpCode,
    );
    if (response is ApiSuccess<AuthSession>) {
      await _persistSession(response.data);
    }
    return response;
  }

  Future<void> _persistSession(AuthSession session) async {
    state = AsyncData(session.user);
    await Future.wait([
      _storage.writeData(LocalStorage.token, session.accessToken),
      _storage.writeData(LocalStorage.refreshToken, session.refreshToken),
      _storage.writeData(LocalStorage.user, session.user.toRawJson()),
    ]);
    await setIsFirstTimeUserToTrue();
  }

  Future<ApiResponse<dynamic>> resendOtp({required String email}) {
    return _service.resendOtp(email: email);
  }

  Future<ApiResponse<dynamic>> resendOtpForgotPassword({
    required String email,
  }) {
    return _service.resendOtpForgotPassword(email: email);
  }

  Future<ApiResponse<VerificationResult>> forgotPassword({
    required String email,
  }) {
    return _service.forgotPassword(email: email);
  }

  Future<ApiResponse<dynamic>> resetPassword({
    required String verificationId,
    required String otp,
    required String password,
  }) {
    return _service.resetPassword(
      verificationId: verificationId,
      otp: otp,
      password: password,
    );
  }

  Future<bool> isFirstTimeUser() async {
    return (await _storage.readData(LocalStorage.isFirstTimeUser)) == null;
  }

  Future<bool> isFirstOpen() async {
    return (await _storage.readData(LocalStorage.isFirstOpen)) == null;
  }

  Future<void> setIsFirstOpenToFalse() {
    return _storage.writeData(LocalStorage.isFirstOpen, false);
  }

  Future<void> setIsFirstTimeUserToTrue() {
    return _storage.writeData(LocalStorage.isFirstTimeUser, true);
  }

  Future<bool> doesUserExist() async {
    final user = await _loadPersistedUser();
    state = AsyncData(user);
    return user != null;
  }

  Future<void> clearCurrentUser() async {
    await Future.wait([
      _storage.deleteData(LocalStorage.refreshToken),
      _storage.deleteData(LocalStorage.token),
      _storage.deleteData(LocalStorage.user),
    ]);
    state = const AsyncData(null);
  }

  Future<void> markBiometricsEnabled() async {
    final user = state.value;
    if (user == null) return;
    final updated = user.copyWith(hasLocalAuth: true);
    state = AsyncData(updated);
    await _storage.writeData(LocalStorage.user, updated.toRawJson());
  }
}
