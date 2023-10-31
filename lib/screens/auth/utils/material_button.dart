import 'package:flutter/material.dart';

class CustomMaterialButton extends StatelessWidget {
  final void Function() onTap;
  final Widget child;
  const CustomMaterialButton({
    required this.onTap,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
          borderRadius: BorderRadius.circular(15),
          splashColor: Colors.greenAccent,
          onTap: onTap,
          child: child),
    );
  }
}
