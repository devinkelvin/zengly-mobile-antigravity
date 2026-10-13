import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/widgets.dart';

class LogoutConfirmSheet extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutConfirmSheet({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.error.withValues(
                alpha: 0.1,
              ),
            ),
            child: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Log out?",
            style: GoogleFonts.raleway(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Are you sure you want to log out of your account?",
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(
              fontSize: 13,
              color: Theme.of(context).colorScheme.scrim,
            ),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  onPressed: () => Navigator.of(context).pop(),
                  actionText: "Cancel",
                  backgroundColor: Theme.of(context).colorScheme.outlineVariant,
                  textColor: Theme.of(context).colorScheme.onSurface,
                  borderRadius: 50,
                  height: 50,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  onPressed: onConfirm,
                  actionText: "Log out",
                  backgroundColor: Theme.of(context).colorScheme.error,
                  textColor: Colors.white,
                  borderRadius: 50,
                  height: 50,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
