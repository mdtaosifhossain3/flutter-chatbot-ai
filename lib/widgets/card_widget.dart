import 'package:chatgpt_clone/constants/constants.dart';
import 'package:chatgpt_clone/services/assets_manager.dart';
import 'package:chatgpt_clone/widgets/box_widget.dart';
import 'package:chatgpt_clone/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({super.key, required this.msg, required this.idx});

  final String msg;
  final int idx;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.all(1),
            child: ListTile(
              title: Align(
                alignment:
                    idx == 0 ? Alignment.centerRight : Alignment.centerLeft,
                child: idx == 0
                    ? BoxWidget(
                        margin: const EdgeInsets.only(left: 100),
                        bgColor: chatTextColor,
                        topLeft: const Radius.circular(15),
                        child: TextWidget(
                          label: msg,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(AssetsManager.botUrl),
                          const SizedBox(
                            height: 8.00,
                          ),
                          BoxWidget(
                            margin: const EdgeInsets.only(right: 50),
                            bgColor: cardColor,
                            topRight: const Radius.circular(15),
                            child: TextWidget(
                              label: msg,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
              ),
            )),
      ],
    );
  }
}
