import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/data.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import '../account/account_vm.dart';
import 'personal_info_vm.dart';

class PersonalInfoScreen extends ConsumerStatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends ConsumerState<PersonalInfoScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _avatarFile;

  // String _phoneNumber = "";

  void _updatePhoneNumber(String newPhoneNumber) {
    // _phoneNumber = newPhoneNumber;
  }

  Future<void> _pickAvatar() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxHeight: 500,
      maxWidth: 500,
    );
    if (pickedFile == null) return;
    setState(() => _avatarFile = File(pickedFile.path));
  }

  @override
  void initState() {
    super.initState();
    final profile = ref.read(personalInfoProvider);
    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.lastName;
    _emailController.text = profile.email;
    _phoneController.text = profile.phone;
    _dateOfBirthController.text = profile.dateOfBirth;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
    _dateOfBirthController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.personalInfo,
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppDimensions.viewPadding,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 16),
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                        child:
                            _avatarFile != null
                                ? ClipOval(
                                  child: Image.file(
                                    _avatarFile!,
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100,
                                  ),
                                )
                                : Icon(
                                  Icons.person,
                                  size: 56,
                                  color: Theme.of(context).colorScheme.scrim,
                                ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickAvatar,
                          child: Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.primary,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.surface,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.edit,
                              size: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                AppDropdownTextField(
                  labelText: l10n.gender,
                  items:
                      [l10n.male, l10n.female]
                          .map(
                            (String gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(
                                gender,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (val) {},
                ),
                SizedBox(height: 16),
                AppTextField(
                  controller: _firstNameController,
                  labelText: l10n.firstName,
                  keyboardType: TextInputType.name,
                  validator: AppValidators.validateName,
                  autofillHints: [AutofillHints.givenName],
                ),
                SizedBox(height: 16),
                AppTextField(
                  controller: _lastNameController,
                  labelText: l10n.lastName,
                  keyboardType: TextInputType.name,
                  validator: AppValidators.validateName,
                  autofillHints: [AutofillHints.familyName],
                ),
                SizedBox(height: 16),
                PhoneNumberTextField(
                  controller: _phoneController,
                  updatePhone: _updatePhoneNumber,
                ),

                SizedBox(height: 16),
                AppTextField(
                  controller: _dateOfBirthController,
                  isCalendar: true,
                  isReadOnly: true,
                  labelText: l10n.dateOfBirth,
                  icon: AppImages.calendar,
                  autofillHints: [AutofillHints.birthday],
                ),
                SizedBox(height: 16),
                AppTextField(
                  controller: _emailController,
                  labelText: l10n.emailAddressLower,
                  keyboardType: TextInputType.emailAddress,
                  validator: AppValidators.validateEmail,
                  autofillHints: [AutofillHints.email],
                ),
                SizedBox(height: 16),
                AppDropdownTextField(
                  labelText: l10n.currentState,
                  items:
                      Constants.states
                          .map(
                            (String gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(
                                gender,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (val) {},
                ),
                SizedBox(height: 36),

                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: AppButton(
                    height: 50,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ref.read(personalInfoProvider.notifier).updateProfile(
                              firstName: _firstNameController.text.trim(),
                              lastName: _lastNameController.text.trim(),
                              email: _emailController.text.trim(),
                              phone: _phoneController.text.trim(),
                              dateOfBirth: _dateOfBirthController.text.trim(),
                              avatarPath: _avatarFile?.path,
                            );
                        ref.read(accountProvider.notifier).updateProfile(
                              fullName:
                                  "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}",
                              email: _emailController.text.trim(),
                              phone: _phoneController.text.trim(),
                            );
                        if (_avatarFile != null) {
                          ref
                              .read(accountProvider.notifier)
                              .setCustomAvatar(_avatarFile!.path);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Profile updated successfully!",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: const Color(0xFF2E7D32),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    actionText: l10n.saveChanges,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
