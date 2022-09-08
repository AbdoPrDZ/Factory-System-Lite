import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth.service.dart';
import '../src/pages_info.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (route == PagesInfo.initialPage.pageName) return null;

    AuthService authService = Get.find<AuthService>();

    if (authService.firebaseAuth.currentUser != null &&
        PagesInfo.unAuthPages.contains(route)) {
      return RouteSettings(name: PagesInfo.onAuthPage.pageName);
    } else if (authService.firebaseAuth.currentUser == null &&
        !PagesInfo.unAuthPages.contains(route)) {
      return RouteSettings(name: PagesInfo.onUnAuthPage.pageName);
    }

    return null;
  }
}
