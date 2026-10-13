import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

class LoginBottom extends StatelessWidget {
  const LoginBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.pagePadding,
        vertical: 5,
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: 50),
        child: Row(
          children: [
            TextButton(
              onPressed: () {
                context.pushNamed(AppRouter.resetPassword);
              },
              child: Text(
                AppLocalizations.of(context).forgotPassword,
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            Spacer(),
            LiveChatWidget(),
          ],
        ),
      ),
    );
  }
}
