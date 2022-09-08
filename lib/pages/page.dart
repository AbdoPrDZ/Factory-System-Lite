import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../src/theme.dart';

abstract class Page<T extends GetxController> extends StatefulWidget {
  final T _controller;

  Page(this._controller, {Key? key}) : super(key: key);

  T get controller => _controller;

  Function? setState;

  Widget? buildDrawer() => null;
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;
  Widget? buildFloatingActionButton(BuildContext context) => null;

  Widget? bottomNavigationBar() => null;

  // List<Widget> tabs = [];
  // TabController setTabBar(PreferredSizeWidget appBar, List<Widget> _tabs) {
  //   TabController tabController = TabController(
  //     length: tabs.length,
  //     vsync: tickerProviderStateMixin,
  //   );
  //   tabs = _tabs;
  //   appBar = buildAppBar(TabBar(
  //     tabs: tabs,
  //     controller: tabController,
  //   ));
  //   return tabController;
  // }

  @protected
  Widget buildBody(BuildContext context);
  late TickerProviderStateMixin tickerProviderStateMixin;

  Widget _build(
    BuildContext context,
    TickerProviderStateMixin tickerProviderStateMixin,
  ) {
    tickerProviderStateMixin = tickerProviderStateMixin;
    return GetBuilder<T>(
      init: _controller,
      builder: (controller) {
        return Scaffold(
          drawer: buildDrawer(),
          backgroundColor: UIThemeColors.pageBackground,
          bottomNavigationBar: bottomNavigationBar(),
          appBar: buildAppBar(context),
          body: SizedBox.expand(child: buildBody(context)),
          floatingActionButton: buildFloatingActionButton(context),
        );
      },
    );
  }

  void initState() {}

  void dispose() {}

  PageHeaders _pageHeaders = PageHeaders();
  PageHeaders get pageHeaders => _pageHeaders;

  void setPageHeaders(PageHeaders pageHeaders) {
    _pageHeaders = pageHeaders;
  }

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> with TickerProviderStateMixin {
  @override
  initState() {
    widget.setState = setState;
    widget.initState();
    super.initState();
    // widget.setPageHeaders(PageHeaders());
  }

  @override
  void dispose() {
    widget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget._build(context, this);
}

class PageHeaders {
  String? title;
  bool? participatesInRootNavigator;
  double Function(BuildContext)? gestureWidth;
  bool maintainState;
  Curve curve;
  Alignment? alignment;
  Map<String, String>? parameters;
  bool opaque;
  Duration? transitionDuration;
  bool? popGesture;
  Bindings? binding;
  List<Bindings> bindings = const [];
  Transition? transition;
  CustomTransition? customTransition;
  bool fullscreenDialog;
  bool showCupertinoParallax;
  bool preventDuplicates;

  PageHeaders({
    this.title,
    this.participatesInRootNavigator,
    this.gestureWidth,
    this.maintainState = true,
    this.curve = Curves.linear,
    this.alignment,
    this.parameters,
    this.opaque = true,
    this.transitionDuration,
    this.popGesture,
    this.binding,
    this.transition,
    this.customTransition,
    this.fullscreenDialog = false,
    this.showCupertinoParallax = true,
    this.preventDuplicates = true,
  });
}
