import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileCoverEffect {
  final String id;
  final String name;
  final List<Color> colors;
  final bool enableAvatarBlur;
  final String? customImagePath;

  const ProfileCoverEffect({
    required this.id,
    required this.name,
    required this.colors,
    this.enableAvatarBlur = true,
    this.customImagePath,
  });

  ProfileCoverEffect copyWith({
    String? id,
    String? name,
    List<Color>? colors,
    bool? enableAvatarBlur,
    String? customImagePath,
  }) {
    return ProfileCoverEffect(
      id: id ?? this.id,
      name: name ?? this.name,
      colors: colors ?? this.colors,
      enableAvatarBlur: enableAvatarBlur ?? this.enableAvatarBlur,
      customImagePath: customImagePath ?? this.customImagePath,
    );
  }

  static const ProfileCoverEffect defaultEffect = ProfileCoverEffect(
    id: "sunset_azure",
    name: "Sunset & Azure",
    colors: [Color(0xFFEA9F41), Color(0xFF3971B0)],
    enableAvatarBlur: true,
  );

  static const List<ProfileCoverEffect> presets = [
    defaultEffect,
    ProfileCoverEffect(
      id: "obsidian_gold",
      name: "Obsidian 24K",
      colors: [Color(0xFF14120E), Color(0xFFB57510), Color(0xFF382709)],
      enableAvatarBlur: false,
    ),
    ProfileCoverEffect(
      id: "aurora_emerald",
      name: "Aurora Emerald",
      colors: [Color(0xFF042E1B), Color(0xFF00C06D), Color(0xFF021B10)],
      enableAvatarBlur: true,
    ),
    ProfileCoverEffect(
      id: "royal_velvet",
      name: "Royal Velvet",
      colors: [Color(0xFF4A0E4E), Color(0xFF8A2BE2), Color(0xFF1F0038)],
      enableAvatarBlur: true,
    ),
    ProfileCoverEffect(
      id: "crimson_pulse",
      name: "Crimson Pulse",
      colors: [Color(0xFF800E13), Color(0xFFD90429), Color(0xFF38040E)],
      enableAvatarBlur: false,
    ),
    ProfileCoverEffect(
      id: "cyber_twilight",
      name: "Cyber Twilight",
      colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
      enableAvatarBlur: true,
    ),
    ProfileCoverEffect(
      id: "vaniti_champagne",
      name: "Vaniti Champagne",
      colors: [Color(0xFFFBF5EC), Color(0xFFD4AF37), Color(0xFFE5D5BD)],
      enableAvatarBlur: true,
    ),
  ];
}

class AccountProfileState {
  final String username;
  final String fullName;
  final String email;
  final String phone;
  final String accountNumber;
  final String bankName;
  final String tier;
  final bool isBiometricEnabled;
  final bool pushNotifications;
  final bool emailAlerts;
  final bool smsAlerts;
  final ProfileCoverEffect coverEffect;
  final String? customAvatarPath;

  const AccountProfileState({
    this.username = "@kelvin_zengly",
    this.fullName = "Kelvin Ekuhoho",
    this.email = "kelvin@zengly.app",
    this.phone = "+234 812 345 6789",
    this.accountNumber = "0287646370",
    this.bankName = "Sterling Bank",
    this.tier = "Tier 1",
    this.isBiometricEnabled = true,
    this.pushNotifications = true,
    this.emailAlerts = true,
    this.smsAlerts = false,
    this.coverEffect = ProfileCoverEffect.defaultEffect,
    this.customAvatarPath,
  });

  AccountProfileState copyWith({
    String? username,
    String? fullName,
    String? email,
    String? phone,
    String? accountNumber,
    String? bankName,
    String? tier,
    bool? isBiometricEnabled,
    bool? pushNotifications,
    bool? emailAlerts,
    bool? smsAlerts,
    ProfileCoverEffect? coverEffect,
    String? customAvatarPath,
  }) {
    return AccountProfileState(
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      accountNumber: accountNumber ?? this.accountNumber,
      bankName: bankName ?? this.bankName,
      tier: tier ?? this.tier,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailAlerts: emailAlerts ?? this.emailAlerts,
      smsAlerts: smsAlerts ?? this.smsAlerts,
      coverEffect: coverEffect ?? this.coverEffect,
      customAvatarPath: customAvatarPath ?? this.customAvatarPath,
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

  void setCoverEffect(ProfileCoverEffect effect) {
    state = state.copyWith(coverEffect: effect);
  }

  void setCustomCoverImage(String path) {
    state = state.copyWith(
      coverEffect: state.coverEffect.copyWith(
        id: "custom_image",
        name: "Custom Wallpaper",
        customImagePath: path,
      ),
    );
  }

  void toggleAvatarBlur(bool enable) {
    state = state.copyWith(
      coverEffect: state.coverEffect.copyWith(enableAvatarBlur: enable),
    );
  }

  void setCustomAvatar(String path) {
    state = state.copyWith(customAvatarPath: path);
  }

  void updateProfile({
    String? fullName,
    String? username,
    String? phone,
    String? email,
  }) {
    state = state.copyWith(
      fullName: fullName ?? state.fullName,
      username: username ?? state.username,
      phone: phone ?? state.phone,
      email: email ?? state.email,
    );
  }
}

final accountProvider =
    StateNotifierProvider<AccountNotifier, AccountProfileState>((ref) {
  return AccountNotifier();
});
