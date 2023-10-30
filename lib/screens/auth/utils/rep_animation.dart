import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RepAnimation extends StatefulWidget {
  final String name;
  const RepAnimation({super.key, required this.name});

  @override
  State<RepAnimation> createState() => _RepAnimationState();
}

class _RepAnimationState extends State<RepAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    controller = AnimationController(vsync: this);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(widget.name, onLoaded: (state) {
      controller.duration = state.duration;
      controller.forward();
    }, controller: controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
