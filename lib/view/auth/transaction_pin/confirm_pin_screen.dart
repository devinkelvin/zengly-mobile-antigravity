import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../../controller/storage/storage.dart';
import '../../../core/network/api_response.dart';
import '../../../data/data.dart';
import '../../../features/transaction_pin/providers/pin_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

class ConfirmPinScreen extends ConsumerStatefulWidget {
  final String enteredPin;
  const ConfirmPinScreen({super.key, required this.enteredPin});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfirmPinScreenState();
}

class _ConfirmPinScreenState extends ConsumerState<ConfirmPinScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _confirmedPin = "";

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
    setState(() => _confirmedPin = clamped);
    if (clamped.length == 6) _createPin();
  }

  Future<void> _createPin() async {
    if (widget.enteredPin != _confirmedPin) {
      AppOverlays.showToast(
        context: context,
        message: AppLocalizations.of(context).pinsDoNotMatch,
        toastType: ToastificationType.error,
      );
      _controller.clear();
      return;
    }
    AppOverlays.showLoadingDialog(context: context);
    final response = await ref
        .read(pinNotifierProvider.notifier)
        .createPin(pin: widget.enteredPin);
    if (!mounted) return;
    context.pop();

    if (response is ApiSuccess) {
      await LocalStorage().writeData(LocalStorage.loginPin, widget.enteredPin);
      if (!mounted) return;
      context.goNamed(AppRouter.biometrics);
    } else {
      _controller.clear();
      AppOverlays.infoDialog(
        context: context,
        message: (response as ApiError).message,
        overlayType: OverlayType.failure,
      );
    }
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
                  l10n.greatNowConfirmPin,
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
                            color: i < _confirmedPin.length
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context).colorScheme.surfaceDim,
                          ),
                        ),
                      ),
                    ),
                  ),
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
