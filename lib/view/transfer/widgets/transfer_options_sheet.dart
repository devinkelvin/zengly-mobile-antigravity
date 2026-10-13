import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../../data/data.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import './pre_transfer_tile.dart';

class TransferOptionsSheet extends StatelessWidget {
  const TransferOptionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Transfer",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: 0,
              ),
            ),
            IconButton(
              onPressed: () => context.pop(),
              icon: Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        PreTransferTile(
          onTap: () {
            context.pop();
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
            context.pop();
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
      ],
    );
  }
}
