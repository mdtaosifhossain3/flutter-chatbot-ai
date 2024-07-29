import 'package:flutter/material.dart';

class BoxWidget extends StatelessWidget {
  final Color? bgColor;
  final Radius? topRight;
  final Radius? topLeft;
  final EdgeInsetsGeometry? margin;
  final Widget? child;

  const BoxWidget({
    super.key,
    this.bgColor,
    this.topLeft,
    this.topRight,
    required this.child,
    required this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(0),
      decoration: BoxDecoration(
          color: bgColor ?? Colors.white,
          borderRadius: BorderRadius.only(
              topRight: topRight ?? const Radius.circular(0),
              topLeft: topLeft ?? const Radius.circular(0),
              bottomLeft: const Radius.circular(15),
              bottomRight: const Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 8),
        child: child,
      ),
    );
  }
}
