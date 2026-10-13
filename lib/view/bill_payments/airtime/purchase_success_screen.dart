import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/data.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

class PurchaseSuccessScreen extends StatefulWidget {
  final PurchaseReceiptData receipt;

  const PurchaseSuccessScreen({super.key, required this.receipt});

  @override
  State<PurchaseSuccessScreen> createState() => _PurchaseSuccessScreenState();
}

class _PurchaseSuccessScreenState extends State<PurchaseSuccessScreen> {
  bool _saveBeneficiary = false;

  @override
  Widget build(BuildContext context) {
    final receipt = widget.receipt;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: _PillButton(
            imageIcon: AppImages.arrowDownloadIcon,
            label: "Download",
            onPressed: () {},
          ),
        ),
        actions: [
          _PillButton(
            imageIcon: AppImages.shareAndroidIcon,
            label: "Share",
            onPressed: () {},
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: AppDimensions.viewPadding,
          child: Column(
            children: [
              SizedBox(height: 24),
              RotatingCoinIcon(size: 210),
              SizedBox(height: 16),
              Text(
                "${receipt.type} purchase successful",
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.scrim,
                  ),
                  children: [
                    TextSpan(text: "You have successfully purchased "),
                    TextSpan(
                      text: receipt.amount,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(text: " ${receipt.type.toLowerCase()} for "),
                    TextSpan(
                      text: receipt.phoneNumber,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 4, 8, 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Save this beneficiary number",
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Switch(
                            value: _saveBeneficiary,
                            onChanged:
                                (val) => setState(() => _saveBeneficiary = val),
                            activeThumbColor:
                                Theme.of(context).colorScheme.onPrimary,
                            activeTrackColor:
                                Theme.of(context).colorScheme.tertiary,
                            inactiveThumbColor:
                                Theme.of(context).colorScheme.onPrimary,
                            inactiveTrackColor:
                                Theme.of(context).colorScheme.surfaceDim,
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(
                          AppRouter.purchaseReceipt,
                          extra: receipt,
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          "View Receipt",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  onPressed: () {
                    context.goNamed(AppRouter.dashboard);
                  },
                  actionText: "Back to Home",
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final IconData? icon;
  final String? svgIcon;
  final String? imageIcon;
  final String label;
  final VoidCallback onPressed;

  const _PillButton({
    this.icon,
    this.svgIcon,
    this.imageIcon,
    required this.label,
    required this.onPressed,
  }) : assert(icon != null || svgIcon != null || imageIcon != null);

  @override
  Widget build(BuildContext context) {
    final Widget iconWidget =
        imageIcon != null
            ? Image.asset(imageIcon!, width: 14, height: 14)
            : svgIcon != null
            ? SvgPicture.asset(
              svgIcon!,
              width: 14,
              height: 14,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface,
                BlendMode.srcIn,
              ),
            )
            : Icon(
              icon,
              size: 14,
              color: Theme.of(context).colorScheme.onSurface,
            );
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 6),
            iconWidget,
          ],
        ),
      ),
    );
  }
}
