import 'package:chatgpt_clone/constants/constants.dart';
import 'package:chatgpt_clone/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String label;
  final Color? bgcolor;
  final Color? textColor;
  final Color? borderColor;
  const ButtonWidget(
      {super.key,
      required this.label,
      this.bgcolor,
      this.textColor,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56.00,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? Colors.transparent),
        color: bgcolor ?? buttonColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: TextWidget(
          label: label,
          color: textColor ?? whiteColor,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
