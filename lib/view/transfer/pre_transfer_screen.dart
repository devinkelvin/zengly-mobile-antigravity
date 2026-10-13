import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../data/data.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import 'widgets/widgets.dart';

class PreTransferScreen extends ConsumerStatefulWidget {
  const PreTransferScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PreTransferScreenState();
}

class _PreTransferScreenState extends ConsumerState<PreTransferScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        automaticallyImplyLeading: false,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              )
            : null,
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              "Transfer",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Select your preferred method for sending.",
              style: GoogleFonts.inter(fontSize: 12, letterSpacing: 0),
            ),
            SizedBox(height: 24),
            PreTransferTile(
              onTap: () {
                context.pushNamed(
                  AppRouter.selectRecipient,
                  pathParameters: AppRouter.selectRecipientParameters(
                    isZenglyTransfer: true,
                  ),
                );
              },
              image: AppImages.accountBalance,
              title: "Send to Zengly User",
              subTitle: "Seamless and free transfers",
            ),
            PreTransferTile(
              onTap: () {
                context.pushNamed(
                  AppRouter.selectRecipient,
                  pathParameters: AppRouter.selectRecipientParameters(
                    isZenglyTransfer: false,
                  ),
                );
              },
              image: AppImages.swap,
              title: "Bank Transfer",
              subTitle: "Send money to other banks",
            ),
            PreTransferTile(
              onTap: () {
                AppOverlays.showToast(
                  context: context,
                  title: "Notice",
                  message:
                      "This feature is coming soon and currently not available",
                  toastType: ToastificationType.custom(
                    "Notice",
                    Theme.of(context).colorScheme.primary,
                    Icons.warning_amber_outlined,
                  ),
                );
              },
              image: AppImages.scan,
              title: "Pay with QR code",
              isComingSoon: true,
              subTitle: "Pay someone using the QR Code",
            ),
            PreTransferTile(
              onTap: () {
                AppOverlays.showToast(
                  context: context,
                  title: "Notice",
                  message:
                      "This feature is coming soon and currently not available",
                  toastType: ToastificationType.custom(
                    "Notice",
                    Theme.of(context).colorScheme.primary,
                    Icons.warning_amber_outlined,
                  ),
                );
              },
              image: AppImages.createLink,
              title: "Share link",
              isComingSoon: true,
              subTitle: "Send a link for some to pay you",
            ),
            PreTransferTile(
              onTap: () {
                AppOverlays.showToast(
                  context: context,
                  title: "Notice",
                  message:
                      "This feature is coming soon and currently not available",
                  toastType: ToastificationType.custom(
                    "Notice",
                    Theme.of(context).colorScheme.primary,
                    Icons.warning_amber_outlined,
                  ),
                );
              },
              image: AppImages.location,
              title: "Transfer internationally",
              isComingSoon: true,
              subTitle: "Send money abroad",
            ),
          ],
        ),
      ),
    );
  }
}
