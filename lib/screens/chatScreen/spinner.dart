import 'package:chatgpt_clone/providers/prompt_provider.dart';
import 'package:chatgpt_clone/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class Spinner extends StatelessWidget {
  const Spinner({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    PromptProvider promptProvider = Provider.of<PromptProvider>(context);
    return promptProvider.isLoading
        ? Container(
            padding: const EdgeInsets.only(bottom: 10),
            child: SpinKitThreeInOut(
              color: themeProvider.themeMode == ThemeMode.light
                  ? Colors.black
                  : Colors.white,
              size: 20,
            ),
          )
        : const SizedBox.shrink();
  }
}
