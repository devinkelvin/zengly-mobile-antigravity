import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../data/data.dart';

class WalletPreview extends StatefulWidget {
  const WalletPreview({super.key});

  @override
  State<WalletPreview> createState() => _WalletPreviewState();
}

class _WalletPreviewState extends State<WalletPreview> {
  final _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(width: double.infinity),
        SingleChildScrollView(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                height: 174,
                width: 194,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    SvgPicture.asset(AppImages.cardBg, fit: BoxFit.cover),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            AppImages.nigerianFlag,
                            height: 40,
                            width: 40,
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "NGN\n",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.scrim,
                                  ),
                                ),
                                TextSpan(
                                  text: "252,865,342.00",
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Container(
                height: 174,
                width: 194,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(2),
                          minimumSize: Size(45, 45),
                          backgroundColor: const Color(0xffE7E7E7),
                          foregroundColor: Colors.black,
                        ),
                        label: SvgPicture.asset(
                          AppImages.addIcon,
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            Colors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      Text(
                        "Add Wallet",
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        SmoothPageIndicator(
          controller: _controller,
          count: 2,
          effect: WormEffect(
            activeDotColor: Theme.of(context).colorScheme.onTertiaryContainer,
            dotColor: Theme.of(context).colorScheme.outlineVariant,
            dotHeight: 8,
            dotWidth: 8,
          ),
        ),
      ],
    );
  }
}
