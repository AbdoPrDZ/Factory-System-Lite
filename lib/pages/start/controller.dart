import 'package:get/get.dart';

import '../../services/main.service.dart';

class StartController extends GetxController {
  late MainService mainService;

  StartController() {
    mainService = Get.find<MainService>();
  }
}
