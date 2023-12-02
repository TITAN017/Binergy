import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLoading extends StatefulWidget {
  final String name;
  const CustomLoading({super.key, required this.name});

  @override
  State<CustomLoading> createState() => _CustomLoadingState();
}

class _CustomLoadingState extends State<CustomLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    controller = AnimationController(vsync: this);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset();
        controller.forward();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      widget.name,
      onLoaded: (state) {
        controller.duration = state.duration;
        controller.forward();
      },
      controller: controller,
      height: 250,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
