import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../view.dart';

class VirtualCards extends ConsumerStatefulWidget {
  const VirtualCards({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VirtualCardsState();
}

class _VirtualCardsState extends ConsumerState<VirtualCards> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [ZenglyCard()]);
    //EmptyCards(isPhysicalCards: false);
  }
}
