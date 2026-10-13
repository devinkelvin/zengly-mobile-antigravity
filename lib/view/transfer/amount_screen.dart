import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/data.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class AmountScreen extends ConsumerStatefulWidget {
  final TransferResult? transfer;

  const AmountScreen({super.key, this.transfer});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AmountScreenState();
}

class _AmountScreenState extends ConsumerState<AmountScreen> {
  late TransferResult _transfer;
  String _amountInput = "";
  String _noteInput = "";

  static const double _fee = 100;

  @override
  void initState() {
    super.initState();
    _transfer =
        widget.transfer ??
        TransferResult(
          recipientName: "Ability Elijah",
          recipientAccountNumber: "5673658653",
          recipientBank: "GTBank",
          sourceBank: "Zengly Wallet",
          sourceAccountNumber: "",
          amount: 0,
          note: "",
          fee: _fee,
          date: DateTime.now(),
          transactionReference: "",
          providerReference: "",
        );
  }

  void _continue() {
    final amount = double.tryParse(_amountInput.replaceAll(",", "")) ?? 0;
    context.pushNamed(
      AppRouter.confirmTransfer,
      extra: _transfer.copyWith(amount: amount, note: _noteInput, fee: _fee),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              "Amount",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Enter transfer amount for this recipient/beneficiary.",
              style: GoogleFonts.inter(fontSize: 12, letterSpacing: 0),
            ),
            SizedBox(height: 32),
            AccountDetailsCard(
              accountNumber: _transfer.recipientAccountNumber,
              name: _transfer.recipientName,
              bankName: _transfer.recipientBank,
            ),
            SizedBox(height: 16),
            AmountTextField(
              fee: _fee,
              onAmountChanged: (value) => _amountInput = value,
              onNoteChanged: (value) => _noteInput = value,
            ),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: AppButton(onPressed: _continue, actionText: "Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
