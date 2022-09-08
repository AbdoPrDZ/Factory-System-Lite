import 'package:flutter/material.dart';

class BorderdBoxView extends StatelessWidget {
  final EdgeInsets margin, padding;
  final Widget? child;

  const BorderdBoxView({
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).viewPadding.top + padding.top,
        bottom: MediaQuery.of(context).viewPadding.bottom + padding.bottom,
        left: padding.left,
        right: padding.right,
      ),
      child: child,
    );
  }
}
