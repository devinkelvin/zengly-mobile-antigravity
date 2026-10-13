import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CardDropDown extends ConsumerWidget {
  final String title;
  final Widget child;
  const CardDropDown({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ExpansionTile(
      childrenPadding: EdgeInsets.all(0),
      backgroundColor: Theme.of(context).colorScheme.outlineVariant,
      collapsedBackgroundColor: Theme.of(context).colorScheme.outlineVariant,
      collapsedIconColor: Theme.of(context).colorScheme.onSurface,
      iconColor: Theme.of(context).colorScheme.onSurface,
      tilePadding: EdgeInsets.all(0),
      controlAffinity: ListTileControlAffinity.trailing,
      showTrailingIcon: true,
      title: Text(
        title,
        style: GoogleFonts.inter(fontWeight: FontWeight.w600, letterSpacing: 0),
      ),
      children: [child],
    );
  }
}
