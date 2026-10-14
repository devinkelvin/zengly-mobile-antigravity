import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/data.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import '../../view.dart';

class ConfirmCardDetailsScreen extends ConsumerStatefulWidget {
  const ConfirmCardDetailsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfirmCardDetailsScreenState();
}

class _ConfirmCardDetailsScreenState
    extends ConsumerState<ConfirmCardDetailsScreen> {
  final List<String> _benefits = [
    "Aliexpress",
    "AWS",
    "Alibaba",
    "Google",
    "ASOS",
    "Namecheap",
    "Facebook",
    "Digital Ocean",
    "And Many More",
  ];
  bool _isAgreedToTerms = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        title: Text(
          "Master Card",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppDimensions.viewPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Platinum",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0,
                          ),
                        ),
                        Spacer(),
                        SvgPicture.asset(AppImages.mastercard),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "With the Visa Platinum, you can make international payments on numerous platforms like:",
                      style: GoogleFonts.inter(fontSize: 12, letterSpacing: 0),
                    ),
                    SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 15,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _benefits.length,
                      itemBuilder: (context, index) {
                        return Text(
                          _benefits[index],
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            letterSpacing: 0,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(AppImages.cardCreation),
                        SizedBox(width: 10),
                        Text(
                          "Card Creation Fee",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            letterSpacing: 0,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "\$2",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            letterSpacing: 0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        SvgPicture.asset(AppImages.arrowDownward),
                        SizedBox(width: 10),
                        Text(
                          "Initial Deposit",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            letterSpacing: 0,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "\$5",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            letterSpacing: 0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        SvgPicture.asset(AppImages.verification),
                        SizedBox(width: 10),
                        Text(
                          "Verification",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            letterSpacing: 0,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "Required",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            letterSpacing: 0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Card limits & fees",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    CardDropDown(
                      title: "Limits",
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Maximum single deposit",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "\$10,000",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Maximum single transaction",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "\$10,000",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Maximum card balance",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "\$10,000",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Monthly transaction limit",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "\$40,000",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Minimum card balance",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "\$1",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Maximum cards creation",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "5",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    CardDropDown(
                      title: "Usage & Acceptance",
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "International Payments",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "Supported (150+ Countries)",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                "Supported Merchants",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "Amazon, Apple, Netflix, AWS",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                "Security Protocol",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "3D Secure 2.0 (OTP)",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                "Settlement Currency",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "USD (\$)",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    CardDropDown(
                      title: "Rates & Conversion",
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Benchmark FX Rate",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "₦1,500.00 / \$1.00",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                "FX Conversion Markup",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "0.0% (Zero hidden fee)",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                "Settlement Speed",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "Instant",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    CardDropDown(
                      title: "Fees & Pricing",
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Card Creation Fee",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "\$2.00",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                "Monthly Maintenance",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "\$0.00 (Free)",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                "Funding Fee",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "\$0.00 (Free)",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                "Inactivity Fee",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "\$0.00",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _isAgreedToTerms,
                    activeColor: Theme.of(context).colorScheme.primary,
                    checkColor: Theme.of(context).colorScheme.surface,
                    onChanged: (val) {
                      setState(() {
                        _isAgreedToTerms = val ?? !_isAgreedToTerms;
                      });
                    },
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "I have read and understood the above card terms & conditions and accept the above terms and conditions.",
                      style: GoogleFonts.inter(fontSize: 12, letterSpacing: 0),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  onPressed: () {
                    context.goNamed(AppRouter.cardCreatedStatus);
                  },
                  actionText: "Continue",
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
