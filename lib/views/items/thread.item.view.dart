import 'package:flutter/material.dart';

import '../../models/thread.model.dart';
import '../../src/theme.dart';
import '../button.view.dart';

class ThreadItemView extends StatelessWidget {
  final ThreadModel thread;
  final Function(ThreadModel thred) onDelete;
  const ThreadItemView({
    Key? key,
    required this.thread,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget divider = Container(
      width: 0.5,
      height: double.infinity,
      color: UIColors.grey,
    );
    Text getText(String text) => Text(
          text,
          style: TextStyle(
            color: UIThemeColors.text3,
            fontSize: 14,
          ),
        );
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: UIThemeColors.cardBg,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          getText(
            thread.type,
          ),
          divider,
          getText(thread.color),
          divider,
          getText('${thread.count} unit'),
          divider,
          getText('${thread.weight} Kg'),
          ButtonView(
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            borderColor: Colors.transparent,
            width: 15,
            onPressed: () => onDelete(thread),
            child: const Icon(
              Icons.close,
              color: UIColors.danger,
              size: 10,
            ),
          )
        ],
      ),
    );
  }
}
