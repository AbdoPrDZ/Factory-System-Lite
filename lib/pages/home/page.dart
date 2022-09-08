import 'package:factory_system_lite/models/worker.model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../pkgs/route.pkg.dart';
import '../../src/pages_info.dart';
import '../../src/theme.dart';
import '../../views/custom_drawer.view.dart';
import '../../views/dialogs.view.dart';
import '../page.dart' as page;
import 'controller.dart';
import 'tabs/clients.tab.dart';
import 'tabs/home.tab.dart';
import 'tabs/invoices.tab.dart';
import 'tabs/orders.tab.dart';
import 'tabs/profile.tab.dart';
import 'tabs/units.tab.dart';

class HomePage extends page.Page<HomeController> {
  HomePage({Key? key}) : super(HomeController(), key: key);

  late Map<String, PageTab> tabs;
  late Rx<PageTab> currentPageTab;
  late PageController pageController;

  @override
  void initState() {
    tabs = {
      'home': PageTab(
        name: 'home',
        tabWidget: HomeTab(controller),
        drawerItem: const DrawerItem('home', Icons.home, 'Home'),
      ),
      'clients': PageTab(
        name: 'clients',
        tabWidget: ClientsTab(controller),
        drawerItem: const DrawerItem('clients', Icons.groups, 'Clients'),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            RoutePkg.to(PagesInfo.addEditClient);
          },
          backgroundColor: UIThemeColors.iconBg,
          child: Icon(
            Icons.add,
            size: 20,
            color: UIThemeColors.iconFg,
          ),
        ),
      ),
      'orders': PageTab(
        name: 'orders',
        tabWidget: OrdersTab(controller),
        drawerItem: const DrawerItem('orders', Icons.view_list, 'Orders'),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            RoutePkg.to(PagesInfo.addEditOrder);
          },
          backgroundColor: UIThemeColors.iconBg,
          child: Icon(
            Icons.add,
            size: 20,
            color: UIThemeColors.iconFg,
          ),
        ),
      ),
      'units': PageTab(
        name: 'units',
        tabWidget: UnitsTab(controller),
        drawerItem: const DrawerItem('units', Icons.category_outlined, 'Units'),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            RoutePkg.to(PagesInfo.addUnit);
          },
          backgroundColor: UIThemeColors.iconBg,
          child: Icon(
            Icons.add,
            size: 20,
            color: UIThemeColors.iconFg,
          ),
        ),
      ),
      'invoices': PageTab(
        name: 'invoices',
        tabWidget: InvoicesTab(controller),
        drawerItem: const DrawerItem(
          'invoices',
          Icons.shopping_cart_checkout,
          'Invoices',
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            RoutePkg.to(PagesInfo.addInvoice);
          },
          backgroundColor: UIThemeColors.iconBg,
          child: Icon(
            Icons.add,
            size: 20,
            color: UIThemeColors.iconFg,
          ),
        ),
      ),
      'profile': PageTab(
        name: 'profile',
        tabWidget: ProfileTab(controller),
        drawerItem: const DrawerItem(
          'profile',
          Icons.account_circle_outlined,
          'Profile',
        ),
      ),
      'settings': PageTab(
        name: 'settings',
        tabWidget: const Center(child: Text('tab')),
        drawerItem: const DrawerItem('settings', Icons.settings, 'Settings'),
      ),
      'about': PageTab(
        name: 'about',
        tabWidget: const Center(child: Text('tab')),
        drawerItem: const DrawerItem('about', Icons.info_outline, 'About'),
      ),
      'support': PageTab(
        name: 'support',
        tabWidget: const Center(child: Text('tab')),
        drawerItem: const DrawerItem(
          'support',
          Icons.support_outlined,
          'Support',
        ),
      ),
      'logout': PageTab(
        name: 'logout',
        tabWidget: null,
        drawerItem: const DrawerItem(
          'logout',
          Icons.logout,
          'Logout',
          isAction: true,
        ),
      ),
    };
    currentPageTab = tabs['home']!.obs;
    pageController = PageController(initialPage: 0, keepPage: false);
    pageController.addListener(() {
      if (pageController.page != null) {
        currentPageTab.value =
            tabs[tabs.keys.toList()[pageController.page!.toInt()]]!;
      }
      controller.update();
    });
    controller.update();
    super.initState();
  }

  onDrawerTabSelected(DrawerItem drawerItem) {
    if (drawerItem.name == 'logout' && drawerItem.isAction) {
      DialogsView.message(
        'Logout',
        'Are you sure you want to logout?',
        actions: [
          DialogAction(
            onPressed: () => Get.back(),
            text: 'Cancel',
            actionColor: UIThemeColors.danger,
          ),
          DialogAction(
            onPressed: controller.authService.logout,
            text: 'Yes',
            actionColor: UIThemeColors.primary,
          ),
        ],
      ).show();
    } else {
      currentPageTab.value = tabs[drawerItem.name]!;
      controller.update();
    }
  }

  @override
  Widget? buildDrawer() => CustomDrawerView(
        tabsItems: tabs.entries.map((tab) => tab.value.drawerItem).toList(),
        pageController: pageController,
        onTabItemSelected: onDrawerTabSelected,
        text: controller.authService.currentWorker?.username ?? '',
        imageUrl: controller.authService.currentWorker != null
            ? controller.authService.currentWorker!.profileImgUrl
            : null,
        themeMode: controller.mainService.themeMode.value,
        onThemeModeChanged: controller.mainService.changeTheme,
      );

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: UIThemeColors.primary,
      title: Obx(() => Text(currentPageTab.value.drawerItem.text)),
    );
  }

  @override
  Widget? buildFloatingActionButton(BuildContext context) {
    return Obx(() => Container(
          child: currentPageTab.value.floatingActionButton,
        ));
  }

  @override
  Widget buildBody(BuildContext context) => PageView(
        controller: pageController,
        children: [
          for (String key in tabs.keys)
            if (tabs[key]!.tabWidget != null) tabs[key]!.tabWidget!,
        ],
      );
}

class PageTab {
  final String name;
  final Widget? tabWidget, floatingActionButton;
  final String? pageTitle;
  final DrawerItem drawerItem;

  PageTab({
    required this.name,
    required this.tabWidget,
    required this.drawerItem,
    this.floatingActionButton,
    this.pageTitle,
  });
}
