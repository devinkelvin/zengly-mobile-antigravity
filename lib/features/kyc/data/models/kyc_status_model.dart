import 'package:freezed_annotation/freezed_annotation.dart';

part 'kyc_status_model.freezed.dart';
part 'kyc_status_model.g.dart';

@freezed
class KycStatusModel with _$KycStatusModel {
  const KycStatusModel._();

  const factory KycStatusModel({
    String? overallStatus,
    @Default([]) List<KycVerification> verifications,
  }) = _KycStatusModel;

  factory KycStatusModel.fromJson(Map<String, dynamic> json) =>
      _$KycStatusModelFromJson(json);

  bool _isTypeVerified(String type) => verifications.any(
    (v) =>
        v.type?.toUpperCase() == type.toUpperCase() &&
        v.status?.toUpperCase() == 'VERIFIED',
  );

  bool get isBvnVerified => _isTypeVerified('BVN');
  bool get isNinVerified => _isTypeVerified('NIN');
  bool get isAddressVerified => _isTypeVerified('ADDRESS');
  bool get isSelfieVerified => _isTypeVerified('SELFIE');

  bool get isFullyVerified =>
      isBvnVerified && isNinVerified && isAddressVerified && isSelfieVerified;
}

@freezed
class KycVerification with _$KycVerification {
  const factory KycVerification({
    String? type,
    String? status,
    DateTime? updatedAt,
    dynamic reason,
    String? reference,
  }) = _KycVerification;

  factory KycVerification.fromJson(Map<String, dynamic> json) =>
      _$KycVerificationFromJson(json);
}
