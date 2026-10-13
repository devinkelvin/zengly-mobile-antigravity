import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../../controller/storage/storage.dart';
import '../../../data/data.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

class LoginPinScreen extends ConsumerStatefulWidget {
  const LoginPinScreen({super.key});

  @override
  ConsumerState<LoginPinScreen> createState() => _LoginPinScreenState();
}

class _LoginPinScreenState extends ConsumerState<LoginPinScreen> {
  String _pin = "";
  bool _hasError = false;

  void _onNumberPressed(String number) {
    if (_pin.length < 6) {
      setState(() {
        _pin += number;
        _hasError = false;
      });
      if (_pin.length == 6) {
        _validatePin();
      }
    }
  }

  void _onDeletePressed() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
        _hasError = false;
      });
    }
  }

  Future<void> _validatePin() async {
    final savedPin = await LocalStorage().readData(LocalStorage.loginPin);
    if (!mounted) return;
    if (_pin == savedPin) {
      context.goNamed(AppRouter.dashboard);
    } else {
      setState(() {
        _hasError = true;
        _pin = "";
      });
      AppOverlays.showToast(
        context: context,
        message: "Incorrect passcode. Please try again.",
        toastType: ToastificationType.error,
      );
    }
  }


  void _changeUser() {
    context.goNamed(AppRouter.loginUnknown);
    ref.read(authNotifierProvider.notifier).clearCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authNotifierProvider).value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: AppDimensions.viewPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        AppImages.profilePicture,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _changeUser,
                    child: Text(
                      "Change account",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                "Welcome back,",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.scrim,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user?.firstName ?? "Enter your passcode",
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w700,
                  fontSize: 26,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Enter your 6-digit passcode to continue",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.scrim,
                ),
              ),
              const SizedBox(height: 32),

              // PIN dots
              IntrinsicWidth(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 44,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(100),
                    border: _hasError
                        ? Border.all(
                            color: Theme.of(context).colorScheme.error,
                            width: 1.5,
                          )
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(
                      6,
                      (i) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i < _pin.length
                              ? (_hasError
                                  ? Theme.of(context).colorScheme.error
                                  : Theme.of(context).colorScheme.onSurface)
                              : Theme.of(context).colorScheme.surfaceDim,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Numpad
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    String label;
                    if (index < 9) {
                      label = "${index + 1}";
                    } else if (index == 9) {
                      label = "del";
                    } else if (index == 10) {
                      label = "0";
                    } else {
                      label = "go";
                    }

                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        if (label == "del") {
                          _onDeletePressed();
                        } else if (label == "go") {
                          if (_pin.length == 6) _validatePin();
                        } else {
                          _onNumberPressed(label);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                        child: Center(
                          child: label == "del"
                              ? SvgPicture.asset(
                                  AppImages.deleteIcon,
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.onSurface,
                                    BlendMode.srcIn,
                                  ),
                                )
                              : label == "go"
                                  ? SvgPicture.asset(
                                      AppImages.arrowForwardIcon,
                                      colorFilter: ColorFilter.mode(
                                        Theme.of(context).colorScheme.onSurface,
                                        BlendMode.srcIn,
                                      ),
                                    )
                                  : Text(
                                      label,
                                      style: GoogleFonts.albertSans(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                    ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Center(
              //   child: TextButton(
              //     onPressed: _switchToPassword,
              //     child: Text(
              //       "Use password instead",
              //       style: GoogleFonts.inter(
              //         fontSize: 13,
              //         color: Theme.of(context).colorScheme.scrim,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
