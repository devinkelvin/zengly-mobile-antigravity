import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/data.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/widgets.dart';

class GiftCardBottomSheetList extends ConsumerStatefulWidget {
  final String title;
  final List<GiftCardChoiceModel> options;
  final GiftCardChoiceModel? selectedOption;
  final void Function(String) onPressed;
  const GiftCardBottomSheetList({
    super.key,
    required this.title,
    required this.options,
    required this.onPressed,
    this.selectedOption,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GiftCardBottomSheetListState();
}

class _GiftCardBottomSheetListState
    extends ConsumerState<GiftCardBottomSheetList> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.title,
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0,
          ),
        ),
        SizedBox(height: 16),
        AppTextField(
          controller: _searchController,
          labelText: "Search",
          prefixIcon: SvgPicture.asset(
            AppImages.search,
            width: 18,
            height: 18,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.scrim,
              BlendMode.srcIn,
            ),
          ),
          prefixContraints: BoxConstraints(maxWidth: 42, maxHeight: 42),
        ),
        SizedBox(height: 16),
        SizedBox(
          height:
              Responsive.height(context) > 750
                  ? 650 - 112
                  : (Responsive.height(context) * 0.7 - 112),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.options.length,

            itemBuilder: (context, i) {
              final option = widget.options[i];
              return GestureDetector(
                onTap: () {
                  context.pop();
                  widget.onPressed(option.id);
                },
                child: Container(
                  height: option.amount != null ? 56 : null,
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.outlineVariant,
                    border:
                        option.id == widget.selectedOption?.id
                            ? Border.all(
                              color: Theme.of(context).colorScheme.scrim,
                              width: 1,
                            )
                            : null,
                  ),
                  child: Row(
                    children: [
                      if (option.image != null)
                        Row(
                          children: [
                            Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.inverseSurface,
                                shape: BoxShape.circle,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(50),
                                child: Image.asset(
                                  option.image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                      Text(
                        option.name ?? option.amount ?? "No Title",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0,
                        ),
                      ),
                      Spacer(),
                      if (option.id == widget.selectedOption?.id)
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          child: Icon(
                            Icons.check,
                            size: 16,
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
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
  }
}
