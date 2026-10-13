import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view.dart';
import 'widgets/widgets.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  // final _controller = PageController();
  int _currentPage = 0;
  Timer? _timer;

  int _animationKey = 0;

  @override
  void initState() {
    super.initState();
    _startAutoSwitch();
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }

  void _startAutoSwitch() {
    final vm = ref.read(onboardingVm);
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        if (_currentPage < 2) {
          _currentPage++;
          vm.updateCurrentPage(_currentPage);
        } else {
          _currentPage = 0;
          vm.updateCurrentPage(_currentPage);
          _animationKey++;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(onboardingVm);
    return Scaffold(
      backgroundColor: vm.onboardingModelList[vm.currentPage].backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 600),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: OnboardingWidget(
                key: ValueKey(_currentPage),
                model: vm.onboardingModelList[_currentPage],
              ),
            ),

            Positioned(top: 60, left: 0, right: 0, child: _buildProgressBar()),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: List.generate(3, (index) {
          final isActive = index == _currentPage;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TweenAnimationBuilder<double>(
                key: index == 0 ? ValueKey(_animationKey) : null,
                tween: Tween<double>(
                  begin: 0.0,
                  end: isActive ? 1.0 : (_currentPage > index ? 1.0 : 0.0),
                ),
                duration: Duration(seconds: isActive ? 3 : 0),
                builder: (context, value, child) {
                  return Stack(
                    children: [
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),

                      FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: value,
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Color(0xFFCE722C),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}
