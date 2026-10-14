import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/widgets.dart';
import '../../../view.dart';

class SplitBillHistoryScreen extends ConsumerStatefulWidget {
  const SplitBillHistoryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SplitBillHistoryScreenState();
}

class _SplitBillHistoryScreenState extends ConsumerState<SplitBillHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        title: Text(
          "Split Bill History",
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
        actions: const [
          BalanceWidget(),
        ],
        bottom: AppTab2(
          tabController: _tabController,
          titles: ["Pending Request", "My Request"],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [PendingRequests(), MyRequets()],
      ),
    );
  }
}
