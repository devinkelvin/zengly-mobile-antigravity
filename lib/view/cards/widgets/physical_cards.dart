import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../view.dart';

class PhysicalCards extends ConsumerStatefulWidget {
  const PhysicalCards({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PhysicalCardsState();
}

class _PhysicalCardsState extends ConsumerState<PhysicalCards> {
  @override
  Widget build(BuildContext context) {
    return EmptyCards(isPhysicalCards: true);
  }
}
