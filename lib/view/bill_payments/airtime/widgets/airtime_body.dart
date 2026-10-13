import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../data/data.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/widgets.dart';
import '../../../view.dart';

class AirtimeBody extends ConsumerStatefulWidget {
  const AirtimeBody({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AirtimeBodyState();
}

class _AirtimeBodyState extends ConsumerState<AirtimeBody> {
  final List<int> amounts = [100, 200, 500, 1000, 2000, 2500];
  final _amountController = TextEditingController();
  final _phoneController = TextEditingController();

  void _updateAmount(int newAmount) {
    // Bare number only — the ₦ is rendered beside the field, not inside it.
    _amountController.text = NumberFormat.decimalPattern().format(newAmount);
  }

  updatePhoneNumber(String phone) {
    _phoneController.text = PhoneNumberFormatter.format(
      phone.replaceAll(RegExp(r'[^0-9]'), ''),
    );
    setState(() {});
  }

  @override
  void initState() {
    ref.read(airtimeVm).initalizeFunction(updatePhone: updatePhoneNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppDimensions.viewPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Text(
            "Select network provider",
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
            ),
          ),
          SizedBox(height: 10),
          AirtimeNumberTextfield(controller: _phoneController),
          SizedBox(height: 16),
          AirtimeTextField(controller: _amountController),
          SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 2.5,
            ),
            itemCount: amounts.length,
            itemBuilder: (context, i) {
              final amount = amounts[i];
              return InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  _updateAmount(amount);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  child: Text(
                    "₦${NumberFormat.decimalPattern().format(amount)}",
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 24),
          _RecentContacts(
            onSelect: (number) => ref
                .read(airtimeVm)
                .updatePhoneNumber(number: number, context: context),
          ),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              onPressed: () {
                final amount = _amountController.text.trim();
                ref
                    .read(airtimeVm)
                    .startPurchase(
                      context: context,
                      type: "Airtime",
                      // Receipts render this verbatim, so re-attach the ₦ here.
                      amount: amount.isEmpty ? "" : "₦$amount",
                      phoneNumber: _phoneController.text.replaceAll('-', ''),
                    );
              },
              actionText: "Continue",
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentContact {
  final String name;
  final String number;

  /// Falls back to an initial-letter avatar when null.
  final String? image;
  final Color? avatarColor;

  const _RecentContact({
    required this.name,
    required this.number,
    this.image,
    this.avatarColor,
  });
}

class _RecentContacts extends ConsumerWidget {
  final void Function(String number) onSelect;

  const _RecentContacts({required this.onSelect});

  static final _contacts = [
    _RecentContact(
      name: "Amara Williams",
      number: "08055159451",
      image: AppImages.dummyPerson,
    ),
    const _RecentContact(
      name: "You",
      number: "08055159451",
      avatarColor: Color(0xFF1B62D8),
    ),
    const _RecentContact(
      name: "Chidi Okafor",
      number: "08123456789",
      avatarColor: Color(0xFF7A4CC4),
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Contacts",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
              ),
            ),
            GestureDetector(
              onTap: () => AppOverlays.contactSheet(context: context),
              child: Text(
                "View all",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _contacts.length,
            separatorBuilder: (_, _) => const SizedBox(width: 24),
            itemBuilder: (context, i) {
              final contact = _contacts[i];
              return GestureDetector(
                onTap: () => onSelect(contact.number),
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    _ContactAvatar(contact: contact),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact.name,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          contact.number,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            letterSpacing: 0,
                            color: Theme.of(context).colorScheme.scrim,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ContactAvatar extends StatelessWidget {
  final _RecentContact contact;
  const _ContactAvatar({required this.contact});

  @override
  Widget build(BuildContext context) {
    if (contact.image != null) {
      return ClipOval(
        child: Image.asset(
          contact.image!,
          height: 44,
          width: 44,
          fit: BoxFit.cover,
        ),
      );
    }
    return Container(
      height: 44,
      width: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: contact.avatarColor ?? Theme.of(context).colorScheme.primary,
      ),
      child: Text(
        contact.name.characters.first.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: Colors.white,
        ),
      ),
    );
  }
}
