import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../view.dart';

class SprayRadarScreen extends ConsumerStatefulWidget {
  const SprayRadarScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SprayRadarScreenState();
}

class _SprayRadarScreenState extends ConsumerState<SprayRadarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        centerTitle: true,
        title: Text(
          "Search Nearby Users",
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ),
      body: SprayRadar(),
    );
  }
}
