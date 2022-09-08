import 'package:factory_system_lite/views/network_image.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../modes/ui_theme.mode.dart';
import '../pkgs/size_config.pkg.dart';
import '../src/assets.dart';
import '../src/theme.dart';
import 'button.view.dart';

class CustomDrawerView extends StatefulWidget {
  final List<DrawerItem> tabsItems;
  final PageController pageController;
  final Function(DrawerItem drawerItem)? onTabItemSelected;
  final String text;
  final String? imageUrl;
  final UIThemeMode themeMode;
  final Function(UIThemeMode themeMode) onThemeModeChanged;
  final List<DrawerLanguageItem> languages;
  late DrawerLanguageItem language;
  final bool Function(DrawerLanguageItem language)? onLanguageChange;

  CustomDrawerView({
    super.key,
    required this.tabsItems,
    required this.pageController,
    required this.onTabItemSelected,
    required this.text,
    this.imageUrl,
    this.themeMode = UIThemeMode.light,
    required this.onThemeModeChanged,
    this.languages = const [
      DrawerLanguageItem('Ar', backgroundColor: UIColors.success),
      DrawerLanguageItem('En'),
      DrawerLanguageItem('Fr', backgroundColor: UIColors.danger),
    ],
    this.language = const DrawerLanguageItem('En'),
    this.onLanguageChange,
  });

  @override
  createState() => _CustomDrawerViewState();
}

class _CustomDrawerViewState extends State<CustomDrawerView> {
  late DrawerItem currentDrawerItem;

  @override
  void initState() {
    super.initState();
    currentDrawerItem =
        widget.tabsItems[widget.pageController.page?.toInt() ?? 0];
    // widget.pageController.addListener(() {
    //   setState(() {
    //     currentDrawerItem =
    //         widget.tabsItems[widget.pageController.page?.toInt() ?? 0];
    //   });
    // });
  }

  onTabItemSelected(DrawerItem drawerItem) {
    if (!drawerItem.isAction) {
      widget.pageController.animateToPage(
        widget.tabsItems.indexOf(drawerItem),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      Get.back();
    }
    if (widget.onTabItemSelected != null) {
      widget.onTabItemSelected!(drawerItem);
      setState(() {
        currentDrawerItem = drawerItem;
      });
    }
  }

  changeLanguage(int index) {
    // if (widget.onLanguageChange != null &&
    //     widget.onLanguageChange!(widget.languages[index])) {
    setState(() {
      widget.language = widget.languages[index];
    });
    Get.back();
    // }
  }

  TextButton _buildItem(DrawerItem drawerItem) {
    return TextButton(
      onPressed: () => onTabItemSelected(drawerItem),
      style: ButtonStyle(
        alignment: Alignment.centerLeft,
        padding: MaterialStateProperty.resolveWith(
          (states) => const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        ),
      ),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Icon(
            drawerItem.icon,
            color: currentDrawerItem == drawerItem
                ? UIThemeColors.primary
                : UIThemeColors.text3,
          ),
          const Gap(10),
          Flexible(
            child: Text(
              drawerItem.text,
              style: TextStyle(
                color: currentDrawerItem == drawerItem
                    ? UIThemeColors.primary
                    : UIThemeColors.text3,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig sizeConfig = SizeConfig(context);
    return Theme(
      data: Theme.of(context).copyWith(
          canvasColor: Colors.transparent, shadowColor: Colors.transparent),
      child: Drawer(
        child: SingleChildScrollView(
          child: Container(
            width: 280,
            height: sizeConfig.realScreenHeight * 0.9,
            margin: EdgeInsets.symmetric(
              vertical: sizeConfig.screenHeight * 0.05,
            ),
            decoration: BoxDecoration(
              color: UIThemeColors.pageBackground,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 2,
                  spreadRadius: 2,
                  offset: Offset(2, 1),
                  color: Color(0X77333333),
                )
              ],
            ),
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: UIThemeColors.primary,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(19),
                    ),
                  ),
                  child: Flex(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      NetworkImageView(
                        widget.imageUrl ?? '',
                        width: 65,
                        height: 65,
                        borderRadius: 50,
                      ),
                      const Gap(5),
                      Text(
                        widget.text,
                        style: const TextStyle(
                          color: LightTheme.pageBackground,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Flex(
                      direction: Axis.vertical,
                      children: List<Widget>.generate(
                        widget.tabsItems.length,
                        (index) => _buildItem(
                          widget.tabsItems[index],
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.light_mode_outlined,
                      color: widget.themeMode == UIThemeMode.light
                          ? UIThemeColors.primary
                          : UIThemeColors.text2,
                    ),
                    Switch(
                      value: widget.themeMode == UIThemeMode.dark,
                      onChanged: (value) {
                        widget.onThemeModeChanged(
                          value ? UIThemeMode.dark : UIThemeMode.light,
                        );
                        Get.back();
                      },
                    ),
                    Icon(
                      Icons.dark_mode_outlined,
                      color: widget.themeMode == UIThemeMode.dark
                          ? UIThemeColors.primary
                          : UIThemeColors.text2,
                    )
                  ],
                ),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.languages.length,
                    (index) {
                      bool isCurrentLanguage =
                          widget.language == widget.languages[index];
                      return ButtonView(
                        backgroundColor:
                            widget.languages[index].backgroundColor,
                        onPressed: isCurrentLanguage
                            ? null
                            : () => changeLanguage(index),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        // borderColor:
                        //     Color(isCurrentLanguage ? 0X0FFF : 0XFF115056),
                        child: Text(
                          widget.languages[index].language,
                          style: TextStyle(
                            color: isCurrentLanguage
                                ? (widget.languages[index].disabledTextColor)
                                : widget.languages[index].textColor,
                            fontSize: 15,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: UIThemeColors.primary,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(19),
                    ),
                  ),
                  child: Flex(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            Assets.logo,
                            color: LightTheme.pageBackground,
                            width: 60,
                            height: 60,
                          ),
                          const Gap(10),
                          Text(
                            'Factory System',
                            style: TextStyle(
                              color: LightTheme.pageBackground,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Gap(5),
                      Text(
                        'Factory-System 2022\nⒸ Powred By Abdo Pr',
                        style: TextStyle(
                          color: LightTheme.pageBackground,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerItem {
  final IconData icon;
  final String name, text;
  final bool isAction;

  const DrawerItem(this.name, this.icon, this.text, {this.isAction = false});
}

class DrawerLanguageItem {
  final String language;
  final Color? backgroundColor;
  final Color textColor, disabledTextColor;

  const DrawerLanguageItem(
    this.language, {
    this.backgroundColor,
    this.textColor = const Color(0XFFFFFFFF),
    this.disabledTextColor = const Color(0XFF707070),
  });
}
