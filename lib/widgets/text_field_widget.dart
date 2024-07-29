import 'package:chatgpt_clone/constants/constants.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextFieldWidget extends StatelessWidget {
  final String? hintText;
  final bool? isObScureText;
  final TextStyle? hintStyle;
  final bool? isCollapsed;
  void Function(String)? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  TextStyle? style;

  TextFieldWidget(
      {super.key,
      this.hintText,
      this.isObScureText,
      this.controller,
      this.focusNode,
      this.hintStyle,
      this.isCollapsed,
      this.onChanged,
      this.style});

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      onChanged: onChanged,
      controller: controller,
      obscureText: isObScureText != null ? true : false,
      style: style,
      decoration: isCollapsed != null
          ? InputDecoration.collapsed(hintText: hintText, hintStyle: hintStyle)
          : InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: hintTextColor, fontSize: 15),
              filled: true,
              fillColor: fillColor,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor),
                  borderRadius: BorderRadius.circular(8)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor),
                  borderRadius: BorderRadius.circular(8)),
            ),
    );
  }
}

// TextField(
//                     focusNode: focusNodeController,
//                     style: const TextStyle(color: Colors.black),
//                     controller: value.controller,
//                     onChanged: (val) {
//                       value.onSubmit(val);
//                     },
//                     decoration: InputDecoration.collapsed(
//                       hintText: "Enter a prompt here",
//                       hintStyle: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w400,
//                           color: Colors.black.withOpacity(0.5)),
//                     ));