import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

class BlurBoxView extends StatelessWidget {
  final Widget? child;
  final Color color;
  final EdgeInsets? margin, padding;
  final double borderRadius, blur, height, width;

  const BlurBoxView({
    Key? key,
    this.child,
    this.color = Colors.transparent,
    this.margin,
    this.padding,
    this.borderRadius = 4,
    this.blur = 5,
    this.height = double.infinity,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blur,
            sigmaY: blur,
            tileMode: TileMode.repeated,
          ),
          child: Container(
            height: height,
            width: width,
            padding: padding,
            color: color,
            child: child,
          ),
        ),
      ),
    );
  }
}
