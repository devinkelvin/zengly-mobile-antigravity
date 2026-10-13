import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/data.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

class SelectDataPlanScreen extends StatefulWidget {
  final NetworkModel network;
  final void Function(DataPlanModel) onSelected;

  const SelectDataPlanScreen({
    super.key,
    required this.network,
    required this.onSelected,
  });

  @override
  State<SelectDataPlanScreen> createState() => _SelectDataPlanScreenState();
}

class _SelectDataPlanScreenState extends State<SelectDataPlanScreen> {
  final _searchController = TextEditingController();
  late List<DataPlanModel> _plans;

  @override
  void initState() {
    _plans = DataPlanModel.fullListForNetwork(widget.network.name);
    _searchController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredPlans =
        _searchController.text.isEmpty
            ? _plans
            : _plans
                .where(
                  (plan) => plan.duration.toLowerCase().contains(
                    _searchController.text.toLowerCase(),
                  ),
                )
                .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Data Plan",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppDimensions.viewPadding,
        child: Column(
          children: [
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
            Expanded(
              child: ListView.separated(
                itemCount: filteredPlans.length,
                separatorBuilder: (context, i) => SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final plan = filteredPlans[i];
                  return GestureDetector(
                    onTap: () {
                      widget.onSelected(plan);
                      context.pop();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                widget.network.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              plan.duration,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
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
        ),
      ),
    );
  }
}
