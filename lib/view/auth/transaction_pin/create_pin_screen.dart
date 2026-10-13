import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

class CreatePinScreen extends ConsumerStatefulWidget {
  const CreatePinScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreatePinScreenState();
}

class _CreatePinScreenState extends ConsumerState<CreatePinScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _enteredPin = "";

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onPinChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onPinChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onPinChanged() {
    final digits = _controller.text.replaceAll(RegExp(r'[^0-9]'), '');
    final clamped = digits.length > 6 ? digits.substring(0, 6) : digits;
    if (clamped != _controller.text) {
      _controller.value = TextEditingValue(
        text: clamped,
        selection: TextSelection.collapsed(offset: clamped.length),
      );
      return;
    }
    setState(() => _enteredPin = clamped);
    if (clamped.length == 6) _tryProceed();
  }

  bool get _noRepeatedDigits =>
      _enteredPin.isEmpty || _enteredPin.split('').toSet().length > 1;

  bool get _noSequentialDigits {
    if (_enteredPin.length < 6) return true;
    final digits = _enteredPin.codeUnits;
    bool asc = true, desc = true;
    for (int i = 1; i < digits.length; i++) {
      if (digits[i] != digits[i - 1] + 1) asc = false;
      if (digits[i] != digits[i - 1] - 1) desc = false;
    }
    return !asc && !desc;
  }

  String? _pinError() {
    if (!_noRepeatedDigits) return "Passcode cannot use the same digit repeatedly";
    if (!_noSequentialDigits) return "Passcode cannot be a simple sequence";
    return null;
  }

  void _tryProceed() {
    final error = _pinError();
    if (error != null) {
      AppOverlays.showToast(
        context: context,
        message: error,
        toastType: ToastificationType.error,
      );
      _controller.clear();
      return;
    }
    context.pushNamed(
      AppRouter.confirmPin,
      pathParameters: AppRouter.confirmPinParameters(pin: _enteredPin),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.pop(),
          ),
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: AppDimensions.viewPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Hidden system keyboard driver
                SizedBox(
                  height: 0,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    autofocus: true,
                    showCursor: false,
                    style: const TextStyle(height: 0, color: Colors.transparent),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  l10n.setYourPasscode,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.create6DigitPin,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 12, letterSpacing: 0),
                ),
                const SizedBox(height: 40),
                // PIN dots
                IntrinsicWidth(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    height: 44,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: const BorderRadius.all(Radius.circular(100)),
                    ),
                    child: Row(
                      children: List.generate(
                        6,
                        (i) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i < _enteredPin.length
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context).colorScheme.surfaceDim,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _PinReqRow(
                  label: "No repeated digits (e.g. 111111)",
                  met: _noRepeatedDigits && _enteredPin.isNotEmpty,
                ),
                const SizedBox(height: 6),
                _PinReqRow(
                  label: "No sequential digits (e.g. 123456)",
                  met: _noSequentialDigits && _enteredPin.length == 6,
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PinReqRow extends StatelessWidget {
  final String label;
  final bool met;

  const _PinReqRow({required this.label, required this.met});

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF00C27C);
    final muted = Theme.of(context).colorScheme.scrim;
    return Row(
      children: [
        Text(
          met ? "✓" : "–",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: met ? green : muted,
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 12, color: muted)),
      ],
    );
  }
}
