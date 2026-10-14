import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/data.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/widgets.dart';

class _SplitFriend {
  final String name;
  final String accountNumber;
  final String? photo;
  final String? avatarInitial;
  final Color avatarColor;

  const _SplitFriend({
    required this.name,
    required this.accountNumber,
    this.photo,
    this.avatarInitial,
    this.avatarColor = Colors.blue,
  });
}

class InputSplitScreen extends ConsumerStatefulWidget {
  const InputSplitScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InputSplitScreenState();
}

class _InputSplitScreenState extends ConsumerState<InputSplitScreen> {
  static const double _totalBillAmount = 500000;

  static final _friends = [
    const _SplitFriend(
      name: "You",
      accountNumber: "028764637",
      avatarInitial: "M",
    ),
    _SplitFriend(
      name: "Amara Williams",
      accountNumber: "028764637",
      photo: AppImages.splitImage,
    ),
    const _SplitFriend(
      name: "Alice Ferguson",
      accountNumber: "028764637",
      avatarColor: Colors.red,
    ),
    const _SplitFriend(
      name: "Alia Sandra",
      accountNumber: "028764637",
      avatarColor: Colors.green,
    ),
    _SplitFriend(
      name: "Alakija Dove",
      accountNumber: "028764637",
      photo: AppImages.splitImage,
    ),
    _SplitFriend(
      name: "Sandra Kristella",
      accountNumber: "028764637",
      photo: AppImages.splitImage,
    ),
  ];

  bool _splitEqually = true;
  late final List<TextEditingController> _amountControllers = List.generate(
    _friends.length,
    (_) => TextEditingController(),
  );

  double get _equalShare => _totalBillAmount / _friends.length;

  double get _totalAllocated {
    if (_splitEqually) return _totalBillAmount;
    return _amountControllers.fold<double>(0, (sum, controller) {
      final cleaned = controller.text.replaceAll(",", "");
      return sum + (double.tryParse(cleaned) ?? 0);
    });
  }

  @override
  void initState() {
    super.initState();
    _applyEqualSplit();
  }

  void _applyEqualSplit() {
    for (final controller in _amountControllers) {
      controller.text = _plainAmount(_equalShare.round());
    }
  }

  static String _plainAmount(num value) =>
      CurrencyFormatter.format(value).replaceFirst("₦", "").trim();

  @override
  void dispose() {
    for (final controller in _amountControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _avatar(_SplitFriend friend) {
    if (friend.photo != null) {
      return ClipOval(
        child: Image.asset(
          friend.photo!,
          height: 40,
          width: 40,
          fit: BoxFit.cover,
        ),
      );
    }
    return Container(
      height: 40,
      width: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: friend.avatarColor,
      ),
      child: Text(
        friend.avatarInitial ?? friend.name[0],
        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        title: Text(
          "Split Bill",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Balance ",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.scrim,
                      ),
                    ),
                    TextSpan(
                      text: "₦345,778.90",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: AppDimensions.viewPadding,
          width: double.infinity,
          child: AppButton(
            onPressed: () {
              AppOverlays.showToast(
                context: context,
                title: "Split Requests Sent!",
                message: "Requests sent to 6 friends successfully.",
              );
              context.pushNamed(AppRouter.splitBillDetailScreen);
            },
            actionText: "Send Split Requests",
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.smartphone_outlined,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Track unpaid bills amounts",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.scrim,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    "${CurrencyFormatter.format(_totalAllocated.round())} ",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "of ${CurrencyFormatter.format(_totalBillAmount.round())}",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).colorScheme.scrim,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "Split equally",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                Switch(
                  value: _splitEqually,
                  onChanged: (value) {
                    setState(() {
                      _splitEqually = value;
                      if (value) _applyEqualSplit();
                    });
                  },
                  activeThumbColor: Theme.of(context).colorScheme.onPrimary,
                  activeTrackColor: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            SizedBox(height: 12),
            ...List.generate(_friends.length, (i) {
              final friend = _friends[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      _avatar(friend),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              friend.name,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              friend.accountNumber,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.scrim,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "₦",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 6),
                            IntrinsicWidth(
                              child: TextField(
                                controller: _amountControllers[i],
                                enabled: !_splitEqually,
                                textAlign: TextAlign.right,
                                keyboardType: TextInputType.number,
                                onChanged: (_) => setState(() {}),
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
