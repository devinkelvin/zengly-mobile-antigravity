import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/data.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/widgets.dart';

class _SplitPayer {
  final String name;
  final String accountNumber;
  final double amount;
  final bool isPaid;
  final String? photo;

  const _SplitPayer({
    required this.name,
    required this.accountNumber,
    required this.amount,
    required this.isPaid,
    this.photo,
  });
}

class SplitBillDetailScreen extends ConsumerStatefulWidget {
  const SplitBillDetailScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SplitBillDetailScreenState();
}

class _SplitBillDetailScreenState extends ConsumerState<SplitBillDetailScreen> {
  static const double _totalBillAmount = 500000;

  bool _splitEqually = false;

  static final _payers = [
    _SplitPayer(
      name: "Your share",
      accountNumber: "028764637",
      amount: 35000,
      isPaid: true,
      photo: AppImages.splitImage,
    ),
    _SplitPayer(
      name: "Amara Williams",
      accountNumber: "028764637",
      amount: 35000,
      isPaid: true,
      photo: AppImages.splitImage,
    ),
    _SplitPayer(
      name: "Alice Ferguson",
      accountNumber: "028764637",
      amount: 5000,
      isPaid: false,
      photo: AppImages.splitImage,
    ),
    _SplitPayer(
      name: "Alia Sandra",
      accountNumber: "028764637",
      amount: 105000,
      isPaid: false,
      photo: AppImages.splitImage,
    ),
    _SplitPayer(
      name: "Alakija Dove",
      accountNumber: "028764637",
      amount: 50000,
      isPaid: true,
      photo: AppImages.splitImage,
    ),
    _SplitPayer(
      name: "Sandra Kristella",
      accountNumber: "028764637",
      amount: 2000,
      isPaid: true,
      photo: AppImages.splitImage,
    ),
  ];

  double get _paidTotal => _payers
      .where((p) => p.isPaid)
      .fold<double>(0, (sum, p) => sum + p.amount);

  double get _progress => (_paidTotal / _totalBillAmount).clamp(0.0, 1.0);

  /// Inner surfaces need to read a step apart from the card they sit on, which
  /// inverts between themes.
  Color _innerFill(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Theme.of(context).brightness == Brightness.dark
        ? scheme.secondaryContainer
        : scheme.surface;
  }

  Widget _avatar(BuildContext context, _SplitPayer payer) {
    if (payer.photo != null) {
      return ClipOval(
        child: Image.asset(
          payer.photo!,
          height: 40,
          width: 40,
          fit: BoxFit.cover,
        ),
      );
    }
    // Fallback for payers without a photo: initial on the brand colour.
    return Container(
      height: 40,
      width: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Text(
        payer.name.isEmpty ? "?" : payer.name[0].toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back, color: scheme.onSurface),
        ),
        title: Text(
          "Split Bill",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: scheme.outlineVariant,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Balance ",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: scheme.scrim,
                      ),
                    ),
                    TextSpan(
                      text: "₦345,778.90",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: AppDimensions.viewPadding,
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.share_rounded, size: 18),
                  label: const Text("Share Link"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onPressed: () {
                    AppOverlays.showToast(
                      context: context,
                      title: "Link Copied",
                      message: "Bill payment link copied to clipboard",
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: AppButton(
                  onPressed: () {
                    AppOverlays.showToast(
                      context: context,
                      title: "Reminders Sent",
                      message: "Sent reminders to 2 unpaid friends",
                    );
                  },
                  actionText: "Remind Unpaid (2)",
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Unpaid summary + payment progress
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.outlineVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Track unpaid bills amounts",
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      letterSpacing: 0,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              "${CurrencyFormatter.format(_paidTotal.round())} ",
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0,
                            color: scheme.onSurface,
                          ),
                        ),
                        TextSpan(
                          text:
                              "of ${CurrencyFormatter.format(_totalBillAmount.round())}",
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0,
                            color: scheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Payment Status",
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      letterSpacing: 0,
                      color: scheme.scrim,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: LinearProgressIndicator(
                      value: _progress,
                      minHeight: 10,
                      backgroundColor: scheme.onSurface.withValues(alpha: 0.15),
                      valueColor: AlwaysStoppedAnimation(scheme.onSecondary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "Split equally",
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: _splitEqually,
                  onChanged: (value) => setState(() => _splitEqually = value),
                  activeThumbColor: scheme.onPrimary,
                  activeTrackColor: scheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._payers.map(
              (payer) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.outlineVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      _avatar(context, payer),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              payer.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              payer.accountNumber,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                letterSpacing: 0,
                                color: scheme.scrim,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Amount + paid/pending status share one pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: _innerFill(context),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              CurrencyFormatter.format(payer.amount.round()),
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Text(
                              payer.isPaid ? "Paid" : "Pending",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0,
                                color: payer.isPaid
                                    ? scheme.onSecondary
                                    : scheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
