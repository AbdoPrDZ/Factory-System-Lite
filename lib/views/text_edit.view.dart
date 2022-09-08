import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../src/consts.dart';
import '../src/theme.dart';

class TextEditView extends StatefulWidget {
  final TextEditingController? controller;
  final String? hint, label;
  late TextInputType entryType;
  final EdgeInsets margin;
  final double? width, height, maxWidth, maxHeight;
  final Color backgroundColor;
  final IconData? prefixIcon, suffixIcon;
  final bool multiLine;

  TextEditView({
    Key? key,
    this.controller,
    this.entryType = TextInputType.text,
    this.hint,
    this.label,
    this.margin = const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
    this.width,
    this.height,
    this.maxWidth,
    this.maxHeight,
    this.backgroundColor = const Color(0XFFDCDCDC),
    this.prefixIcon,
    this.suffixIcon,
    this.multiLine = false,
  }) : super(key: key);

  @override
  State<TextEditView> createState() => _TextEditViewState();
}

class _TextEditViewState extends State<TextEditView> {
  bool hideText = false;

  late FocusNode focusNode;
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    hideText = widget.entryType == TextInputType.visiblePassword;
    focusNode = FocusNode();
    focusNode.addListener(() {
      setState(() {
        isFocused = focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.multiLine) widget.entryType = TextInputType.multiline;
    return Container(
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      constraints: BoxConstraints(
        maxWidth: widget.maxWidth ?? double.infinity,
        maxHeight: widget.maxHeight ?? double.infinity,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.label != null) ...[
            Text(
              widget.label!,
              style: TextStyle(
                color: UIThemeColors.text2,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(5),
          ],
          TextField(
            focusNode: focusNode,
            obscureText: hideText,
            controller: widget.controller,
            keyboardType: widget.entryType,
            maxLines: widget.multiLine ? null : 1,
            style: TextStyle(color: UIThemeColors.fieldText),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(
                color: UIThemeColors.field,
                fontFamily: Consts.fontFamily,
              ),
              fillColor: UIThemeColors.fieldBg,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: UIThemeColors.field),
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      color: isFocused
                          ? UIThemeColors.fieldFocus
                          : UIThemeColors.field,
                    )
                  : null,
              suffixIcon: widget.suffixIcon != null
                  ? Icon(
                      widget.suffixIcon,
                      color: UIThemeColors.field,
                    )
                  : (widget.entryType == TextInputType.visiblePassword
                      ? TextButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.resolveWith(
                              (states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                          onPressed: () => setState(() {
                            hideText = !hideText;
                          }),
                          child: Icon(
                            hideText ? Icons.visibility : Icons.visibility_off,
                            color: hideText
                                ? UIThemeColors.field
                                : UIThemeColors.fieldFocus,
                            size: 25,
                          ),
                        )
                      : null),
              contentPadding: widget.prefixIcon == null
                  ? const EdgeInsets.only(top: 15, left: 15)
                  : const EdgeInsets.only(top: 0),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: UIThemeColors.fieldFocus, width: 1.6),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: UIThemeColors.field, width: 1.6),
                borderRadius: BorderRadius.circular(10),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: UIThemeColors.fieldBg, width: 1.6),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
