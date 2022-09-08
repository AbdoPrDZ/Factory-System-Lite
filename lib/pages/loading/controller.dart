import 'package:factory_system_lite/services/notifications.service.dart';
import 'package:get/get.dart';

import '../../pkgs/route.pkg.dart';
import '../../services/main.service.dart';
import '../../services/auth.service.dart';
import '../../src/pages_info.dart';

class LoadingController extends GetxController {
  late MainService mainService;
  late AuthService authService;
  late NotificationsService notificationsService;

  LoadingController() {
    mainService = Get.find<MainService>();
    authService = Get.put(AuthService());
    notificationsService = Get.put(NotificationsService());
  }

  Future loading() async {
    await mainService.init();
    authService.init();
    await notificationsService.init();
    if (authService.firebaseAuth.currentUser != null) {
      authService.onAuth();
    }
    RoutePkg.to(PagesInfo.start, clearHeaders: true);
  }
}
