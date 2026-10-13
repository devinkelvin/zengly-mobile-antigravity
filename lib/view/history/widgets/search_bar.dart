import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/data.dart';
import '../../../utils/utils.dart';

class HistorySearchBar extends ConsumerStatefulWidget {
  final ValueChanged<String>? onChanged;
  final bool hasActiveFilters;
  final ValueChanged<TransactionFilterResult?>? onFilterChanged;

  const HistorySearchBar({
    super.key,
    this.onChanged,
    this.hasActiveFilters = false,
    this.onFilterChanged,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HistorySearchBarState();
}

class _HistorySearchBarState extends ConsumerState<HistorySearchBar> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color:
                    _isFocused
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppImages.search,
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.scrim,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    focusNode: _focusNode,
                    onChanged: widget.onChanged,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isCollapsed: true,
                      hintText: "Search...",
                      hintStyle: GoogleFonts.inter(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.scrim,
                      ),
                    ),
                    style: GoogleFonts.inter(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12),
        GestureDetector(
          onTap: () async {
            final result = await context.pushNamed<TransactionFilterResult>(
              AppRouter.transactionFilter,
            );
            if (result != null) widget.onFilterChanged?.call(result);
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.tune,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              if (widget.hasActiveFilters)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.error,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.surface,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
