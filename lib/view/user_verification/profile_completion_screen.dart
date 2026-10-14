import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class ProfileCompletionScreen extends ConsumerStatefulWidget {
  const ProfileCompletionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState
    extends ConsumerState<ProfileCompletionScreen> {
  final _tagController = TextEditingController(text: "@kelvin_zengly");
  final _kinNameController = TextEditingController(text: "Jane Ekuhoho");
  final _kinPhoneController = TextEditingController(text: "08031234567");
  final _kinRelationController = TextEditingController(text: "Sibling");
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _tagController.dispose();
    _kinNameController.dispose();
    _kinPhoneController.dispose();
    _kinRelationController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    AppOverlays.bottomSheet(
      context: context,
      isSuccess: true,
      action: () {
        context.pop();
        context.pop();
      },
      title: 'Profile Completed!',
      content: 'Your Zengly Usertag and next of kin information have been saved.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF14120E) : const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Complete Profile",
          style: GoogleFonts.raleway(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: AppDimensions.viewPadding,
          width: double.infinity,
          child: AppButton(
            onPressed: _submit,
            actionText: "Save Profile",
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Personalize Your Identity",
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Choose a unique Zengly Usertag so friends can find and spray you instantly.",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
              const SizedBox(height: 24),

              // Usertag
              AppTextField(
                controller: _tagController,
                labelText: "Your Zengly Usertag",
                keyboardType: TextInputType.text,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return "Please enter a valid usertag";
                  }
                  if (!val.startsWith("@")) {
                    return "Usertag must begin with @";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 28),

              Text(
                "Next of Kin Information",
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Required by central banking regulations to protect your assets.",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
              const SizedBox(height: 16),

              AppTextField(
                controller: _kinNameController,
                labelText: "Full Name of Next of Kin",
                validator: (v) => v!.isEmpty ? "Enter full name" : null,
              ),

              const SizedBox(height: 14),

              AppTextField(
                controller: _kinRelationController,
                labelText: "Relationship (e.g. Sibling, Spouse, Parent)",
                validator: (v) => v!.isEmpty ? "Enter relationship" : null,
              ),

              const SizedBox(height: 14),

              AppTextField(
                controller: _kinPhoneController,
                labelText: "Phone Number of Next of Kin",
                keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? "Enter phone number" : null,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
