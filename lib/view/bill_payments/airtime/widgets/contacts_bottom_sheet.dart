import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/utils.dart';
import '../../../../widgets/widgets.dart';
import '../../../view.dart';

class ContactsBottomSheet extends ConsumerStatefulWidget {
  const ContactsBottomSheet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ContactsBottomSheetState();
}

class _ContactsBottomSheetState extends ConsumerState<ContactsBottomSheet> {
  late Future<void> _getContacts;

  @override
  void initState() {
    final vm = ref.read(airtimeVm);
    _getContacts = vm.getContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(airtimeVm);
    return FutureBuilder(
      future: _getContacts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: AppLoader());
        }
        if (snapshot.hasError) {
          return Center(child: Text("An Error Occurred"));
        }
        return Column(
          children: [
            SizedBox(height: 8),
            Text(
              "Select Contact",
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: Responsive.height(context) * 0.45 - 50,
              child: ListView.builder(
                itemCount: vm.contacts.length,
                itemBuilder: (context, i) {
                  final contact = vm.contacts[i];
                  return GestureDetector(
                    onTap: () {
                      vm.updatePhoneNumber(
                        number: contact.phones[0].number,
                        context: context,
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child:
                                (contact.photo != null)
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.memory(
                                        contact.photo!,
                                        width: 45,
                                        height: 45,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    : Text(
                                      contact.displayName[0],
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0,
                                      ),
                                    ),
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(contact.displayName),
                              Text(
                                contact.phones.isNotEmpty
                                    ? contact.phones[0].number
                                    : "No Number",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.scrim,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
