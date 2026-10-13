import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../view.dart';

class PendingRequests extends ConsumerStatefulWidget {
  const PendingRequests({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PendingRequestsState();
}

class _PendingRequestsState extends ConsumerState<PendingRequests> {
  @override
  Widget build(BuildContext context) {
    return EmptySplitBill(
      detail:
          "Your pending requests will appear here once you begin using the Split Bill feature.",
      isInitiateSplit: false,
    );
  }
}
