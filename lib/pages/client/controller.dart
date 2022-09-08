import 'package:get/get.dart';

import '../../services/main.service.dart';

class ClietnController extends GetxController {
  late MainService mainService;

  @override
  void onInit() {
    mainService = Get.find<MainService>();
    super.onInit();
  }
}
