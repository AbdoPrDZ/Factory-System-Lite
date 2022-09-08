import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../src/theme.dart';

class DropDownView<T> extends StatelessWidget {
  final T? value;
  final String? hint, label;
  final List<DropdownMenuItem<T>> items;
  final Function(T? value) onChanged;
  final EdgeInsets margin, padding;
  final double? width, heigth;

  const DropDownView({
    Key? key,
    this.value,
    this.margin = const EdgeInsets.symmetric(horizontal: 5),
    this.padding = const EdgeInsets.symmetric(horizontal: 15),
    this.width = double.infinity,
    this.heigth,
    required this.items,
    required this.onChanged,
    this.hint,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: heigth ?? (label != null ? 75 : 55),
      margin: margin,
      child: Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (label != null) ...[
            Text(
              label!,
              style: TextStyle(
                color: UIThemeColors.text2,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(5),
          ],
          Flexible(
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                color: UIThemeColors.fieldBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: UIThemeColors.field, width: 1.8),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: DropdownButton<T>(
                      value: value,
                      hint: hint != null
                          ? Text(
                              hint!,
                              style: TextStyle(
                                  fontSize: 16, color: UIThemeColors.field),
                              overflow: TextOverflow.ellipsis,
                            )
                          : null,
                      style: TextStyle(
                        fontSize: 16,
                        color: UIThemeColors.text3,
                      ),
                      items: items,
                      onChanged: onChanged,
                      dropdownColor: UIThemeColors.pageBackground,
                      borderRadius: BorderRadius.circular(8),
                      underline: Container(),
                      icon: Container(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: UIThemeColors.fieldText,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
