import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../src/theme.dart';

class DetialsItemView extends StatelessWidget {
  final String name;
  final dynamic value;
  final Color? textColor;
  final List<Widget>? subWidgets;

  const DetialsItemView(
    this.name,
    this.value, {
    Key? key,
    this.textColor,
    this.subWidgets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(color: UIColors.grey, width: 0.2),
        borderRadius: BorderRadius.circular(5),
        color: UIThemeColors.cardBg,
      ),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Text(
            '$name:',
            style: TextStyle(
              color: UIThemeColors.text2,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(10),
          Flexible(
            child: Text(
              (value ?? '--').toString(),
              style: TextStyle(
                color: textColor ?? UIThemeColors.text3,
                fontSize: 20,
              ),
            ),
          ),
          if (subWidgets != null) ...subWidgets!
        ],
      ),
    );
  }
}
