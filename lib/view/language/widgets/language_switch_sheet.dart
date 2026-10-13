import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/widgets.dart';

class LanguageSwitchSheet extends StatelessWidget {
  final String currentFlag, newFlag, newLanguageName;
  final VoidCallback onConfirm;

  const LanguageSwitchSheet({
    super.key,
    required this.currentFlag,
    required this.newFlag,
    required this.newLanguageName,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset(
                  currentFlag,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16),
              Icon(
                Icons.swap_horiz,
                color: Theme.of(context).colorScheme.scrim,
              ),
              SizedBox(width: 16),
              ClipOval(
                child: Image.asset(
                  newFlag,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            "Switch to $newLanguageName",
            style: GoogleFonts.raleway(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "You're about to set $newLanguageName as your default language.",
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(
              fontSize: 13,
              color: Theme.of(context).colorScheme.scrim,
            ),
          ),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              onPressed: onConfirm,
              actionText: "Set As Default",
              backgroundColor: Colors.white,
              textColor: Colors.black,
              borderRadius: 50,
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}
