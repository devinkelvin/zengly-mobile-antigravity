import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view.dart';
import 'widgets/widgets.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(dashboardVm);
    return Scaffold(
      body: IndexedStack(index: vm.currentIndex, children: vm.pages),
      bottomNavigationBar: DashboardBottomBar(),
    );
  }
}
