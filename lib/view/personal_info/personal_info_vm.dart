import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalInfoModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String dateOfBirth;
  final String state;
  final String? avatarPath;

  const PersonalInfoModel({
    this.firstName = "Kelvin",
    this.lastName = "Ekuhoho",
    this.email = "kelvin@zengly.app",
    this.phone = "08123456789",
    this.dateOfBirth = "01 January 1992",
    this.state = "Lagos",
    this.avatarPath,
  });

  PersonalInfoModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? dateOfBirth,
    String? state,
    String? avatarPath,
  }) {
    return PersonalInfoModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      state: state ?? this.state,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }
}

class PersonalInfoNotifier extends StateNotifier<PersonalInfoModel> {
  PersonalInfoNotifier() : super(const PersonalInfoModel());

  void updateProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? dateOfBirth,
    String? userState,
    String? avatarPath,
  }) {
    state = state.copyWith(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      dateOfBirth: dateOfBirth,
      state: userState,
      avatarPath: avatarPath,
    );
  }
}

final personalInfoProvider =
    StateNotifierProvider<PersonalInfoNotifier, PersonalInfoModel>((ref) {
  return PersonalInfoNotifier();
});
