import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../view.dart';

class MyRequets extends ConsumerStatefulWidget {
  const MyRequets({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyRequetsState();
}

class _MyRequetsState extends ConsumerState<MyRequets> {
  @override
  Widget build(BuildContext context) {
    return EmptySplitBill(
      detail:
          "Your Requests will appear here once you begin using the Split Bill feature.",
      isInitiateSplit: true,
    );
  }
}
