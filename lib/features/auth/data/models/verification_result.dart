import 'package:freezed_annotation/freezed_annotation.dart';

part 'verification_result.freezed.dart';
part 'verification_result.g.dart';

@freezed
class VerificationResult with _$VerificationResult {
  const factory VerificationResult({required String verificationId}) =
      _VerificationResult;

  factory VerificationResult.fromJson(Map<String, dynamic> json) =>
      _$VerificationResultFromJson(json);
}
