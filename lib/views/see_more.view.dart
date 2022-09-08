import 'package:flutter/material.dart';

class SeeMoreView extends StatefulWidget {
  final Widget child;
  final double openHeight, closeHeight;
  final bool see;
  final EdgeInsets margin;

  const SeeMoreView({
    Key? key,
    required this.child,
    this.see = false,
    this.openHeight = 500,
    this.closeHeight = 100,
    this.margin = EdgeInsets.zero,
  }) : super(key: key);

  @override
  createState() => _SeeMoreViewState();
}

class _SeeMoreViewState extends State<SeeMoreView> {
  late bool see;

  @override
  void initState() {
    super.initState();
    see = widget.see;
  }

  @override
  Widget build(BuildContext context) {
    Widget contentWidget = GestureDetector(
      onTap: () => setState(() => see = !see),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: widget.child,
      ),
    );
    return Container(
      constraints: BoxConstraints(
        maxHeight: see ? widget.openHeight : widget.closeHeight,
      ),
      margin: widget.margin,
      child: see
          ? SingleChildScrollView(
              child: contentWidget,
            )
          : contentWidget,
    );
  }
}
