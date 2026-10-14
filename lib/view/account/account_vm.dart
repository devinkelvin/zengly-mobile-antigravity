import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountProfileState {
  final String username;
  final String fullName;
  final String email;
  final String phone;
  final String accountNumber;
  final String tier;
  final bool isBiometricEnabled;
  final bool pushNotifications;
  final bool emailAlerts;
  final bool smsAlerts;

  const AccountProfileState({
    this.username = "@ability007",
    this.fullName = "Kelvin Ekuhoho",
    this.email = "kelvin@zengly.app",
    this.phone = "+234 812 345 6789",
    this.accountNumber = "54674778965",
    this.tier = "Tier 1",
    this.isBiometricEnabled = true,
    this.pushNotifications = true,
    this.emailAlerts = true,
    this.smsAlerts = false,
  });

  AccountProfileState copyWith({
    String? username,
    String? fullName,
    String? email,
    String? phone,
    String? accountNumber,
    String? tier,
    bool? isBiometricEnabled,
    bool? pushNotifications,
    bool? emailAlerts,
    bool? smsAlerts,
  }) {
    return AccountProfileState(
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      accountNumber: accountNumber ?? this.accountNumber,
      tier: tier ?? this.tier,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailAlerts: emailAlerts ?? this.emailAlerts,
      smsAlerts: smsAlerts ?? this.smsAlerts,
    );
  }
}

class AccountNotifier extends StateNotifier<AccountProfileState> {
  AccountNotifier() : super(const AccountProfileState());

  void toggleBiometrics() {
    state = state.copyWith(isBiometricEnabled: !state.isBiometricEnabled);
  }

  void togglePushNotifications() {
    state = state.copyWith(pushNotifications: !state.pushNotifications);
  }

  void updateProfile({String? fullName, String? phone, String? email}) {
    state = state.copyWith(
      fullName: fullName ?? state.fullName,
      phone: phone ?? state.phone,
      email: email ?? state.email,
    );
  }
}

final accountProvider =
    StateNotifierProvider<AccountNotifier, AccountProfileState>((ref) {
  return AccountNotifier();
});
