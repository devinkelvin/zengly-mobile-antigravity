import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../data/data.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class ConfirmTransactionScreen extends ConsumerStatefulWidget {
  final TransferResult transfer;

  const ConfirmTransactionScreen({super.key, required this.transfer});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfirmTransactionScreenState();
}

class _ConfirmTransactionScreenState
    extends ConsumerState<ConfirmTransactionScreen> {
  String _pin = "";

  void _onDigit(String digit) {
    if (_pin.length >= 4) return;
    setState(() => _pin += digit);
    if (_pin.length == 4) {
      Future.delayed(const Duration(milliseconds: 200), _submit);
    }
  }

  void _onDelete() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  Future<void> _submit() async {
    AppOverlays.showLoadingDialog(context: context);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    context.pop();
    final now = DateTime.now();
    final reference = "TRF${now.millisecondsSinceEpoch}";
    final t = widget.transfer;
    context.goNamed(
      AppRouter.transferSuccess,
      extra: TransferResult(
        recipientName: t.recipientName,
        recipientAccountNumber: t.recipientAccountNumber,
        recipientBank: t.recipientBank,
        sourceBank: t.sourceBank,
        sourceAccountNumber: t.sourceAccountNumber,
        amount: t.amount,
        note: t.note,
        fee: t.fee,
        date: now,
        transactionReference: reference,
        providerReference: "PRV$reference",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFFB57510);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF16130E) : const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          color: Theme.of(context).colorScheme.onSurface,
          icon: const Icon(Icons.close_rounded),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppDimensions.viewPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Authorize Transfer",
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: isDark ? Colors.white : const Color(0xFF1E1A14),
                ),
              ),
              const SizedBox(height: 8),
              // Transfer context summary pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF262017) : const Color(0xFFEDE5D8),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.25),
                  ),
                ),
                child: Text(
                  "₦${NumberFormat("#,##0.00").format(widget.transfer.amount)} to ${widget.transfer.recipientName}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1E1A14),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              IntrinsicWidth(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF241F18) : const Color(0xFFEBE4D8),
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(
                      4,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        width: 16.0,
                        height: 16.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              index < _pin.length
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(context).colorScheme.surfaceDim,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                child: Text(
                  "I forgot my PIN",
                  style: GoogleFonts.inter(fontSize: 12, letterSpacing: 0),
                ),
              ),
              SizedBox(height: 32),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    String buttonText;
                    if (index < 9) {
                      buttonText = "${index + 1}";
                    } else if (index == 9) {
                      buttonText = "";
                    } else if (index == 10) {
                      buttonText = "0";
                    } else {
                      buttonText = "";
                    }

                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        if (index == 9) {
                          _onDelete();
                        } else if (index == 11) {
                          if (_pin.length == 4) _submit();
                        } else if (buttonText.isNotEmpty) {
                          _onDigit(buttonText);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              index == 11
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(
                                    context,
                                  ).colorScheme.outlineVariant,
                        ),
                        child: Center(
                          child:
                              index == 9
                                  ? SvgPicture.asset(AppImages.deleteIcon)
                                  : index == 11
                                  ? SvgPicture.asset(AppImages.arrowForwardIcon)
                                  : Text(
                                    buttonText,
                                    style: GoogleFonts.albertSans(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                    ),
                                  ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
