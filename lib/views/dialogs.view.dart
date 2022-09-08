import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../src/theme.dart';
import 'button.view.dart';

class DialogsView extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin, padding;
  final double? width, height;
  final bool isDismissible;

  const DialogsView({
    Key? key,
    required this.child,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.all(16),
    this.width,
    this.height,
    this.isDismissible = true,
  }) : super(key: key);

  factory DialogsView.message(
    String title,
    String message, {
    List<DialogAction>? actions,
    bool isDismissible = true,
  }) {
    return DialogsView(
      isDismissible: isDismissible,
      child: Flex(
        direction: Axis.vertical,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: UIThemeColors.text1,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 12,
              bottom: 16,
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: UIThemeColors.text2,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          if (actions != null && actions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 3, right: 3),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: actions
                    .map((action) => ButtonView.text(
                          onPressed: action.onPressed,
                          text: action.text,
                          backgroundColor: action.actionColor,
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  factory DialogsView.loading({
    Key? key,
    String? title,
    String message = 'Loading...',
    EdgeInsets? margin,
    EdgeInsets? padding,
    double? width,
    double? height,
  }) {
    return DialogsView(
      isDismissible: false,
      child: Flex(
        direction: Axis.vertical,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (title != null)
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: UIThemeColors.text1,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 16),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                CircularProgressIndicator(color: UIThemeColors.primary),
                const Gap(10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: UIThemeColors.text2,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future show() => Get.dialog(this, barrierDismissible: isDismissible);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => isDismissible,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: UIThemeColors.cardBg,
        child: Container(
          margin: margin,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: UIThemeColors.cardBg,
          ),
          child: child,
        ),
      ),
    );
  }
}

class DialogAction {
  final String text;
  final VoidCallback onPressed;
  final Color? actionColor;

  DialogAction({
    required this.text,
    required this.onPressed,
    this.actionColor,
  });
}
