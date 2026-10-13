import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/utils.dart';
import '../../../../view/view.dart';
import '../../../../data/data.dart';
import '../../../../widgets/widgets.dart';

class SprayCashForm3 extends ConsumerStatefulWidget {
  const SprayCashForm3({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SprayCashForm3State();
}

class _SprayCashForm3State extends ConsumerState<SprayCashForm3> {
  final _accountNumberController = TextEditingController();

  @override
  void dispose() {
    _accountNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        AppTextField(
          controller: _accountNumberController,
          labelText: "Enter Account, Phone number or Usertag",
        ),
        SizedBox(height: 20),
        AccountDetailsCard(),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: Divider()),
            SizedBox(width: 10),
            Text(
              "OR",
              style: GoogleFonts.inter(
                fontSize: 12,
                letterSpacing: 0,
                fontWeight: FontWeight.w500,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            SizedBox(width: 10),
            Expanded(child: Divider()),
          ],
        ),
        SizedBox(height: 20),
        AlternativeOption(
          image: AppImages.search,
          isBluetooth: true,
          title: "Search Nearby Users",
          onPressed: () {
            context.pushNamed(AppRouter.sprayRadar);
          },
        ),
        SizedBox(height: 20),
        AlternativeOption(
          image: AppImages.qrCode,
          isBluetooth: false,
          title: "Scan QR Code",
          onPressed: () {},
        ),
        //   SprayRadar(),
      ],
    );
  }
}
