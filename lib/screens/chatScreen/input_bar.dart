import 'package:chatgpt_clone/constants/constants.dart';
import 'package:chatgpt_clone/providers/prompt_provider.dart';
import 'package:chatgpt_clone/widgets/text_field_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class InputBar extends StatelessWidget {
  late FocusNode? focusNodeController;
  InputBar({super.key, this.focusNodeController});

  @override
  Widget build(BuildContext context) {
    PromptProvider promptProvider = Provider.of<PromptProvider>(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40), color: inputColor),
      child: Row(
        children: [
          Expanded(
            child: Selector<PromptProvider, TextEditingController>(
              selector: (_, provider) => provider.controller,
              builder: (context, controller, child) {
                return TextFieldWidget(
                  focusNode: focusNodeController,
                  style: const TextStyle(color: Colors.black),
                  controller: controller,
                  onChanged: (val) {
                    // Handle changes without causing a full rebuild
                    promptProvider.onSubmit(val);
                  },
                  isCollapsed: true,
                  hintText: "Enter a prompt here",
                  hintStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black.withOpacity(0.5)),
                );
              },
            ),
          ),
          IconButton(
              onPressed: () async {
                try {
                  var inputTxt = {
                    "idx": 0,
                    "msg": promptProvider.controller.text,
                    "date": DateTime.now()
                  };

                  promptProvider.addPrompt(inputTxt);

                  await promptProvider.sendPrompt();

                  focusNodeController!.unfocus();
                } catch (e) {
                  if (kDebugMode) {
                    print(e.toString());
                  }
                }
              },
              icon: const Icon(
                Icons.send,
                color: Colors.black,
              )),
        ],
      ),
    );
  }
}
