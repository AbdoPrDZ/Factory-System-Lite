import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../services/auth.service.dart';
import '../../services/main.service.dart';
import '../../views/dialogs.view.dart';

class LoginController extends GetxController {
  late MainService mainService;
  late AuthService authService;

  late TextEditingController emailController;
  late TextEditingController passwordController;

  LoginController() {
    mainService = Get.find<MainService>();
    authService = Get.find<AuthService>();

    emailController = TextEditingController(text: 'abdopr47@gmail.com');
    passwordController = TextEditingController(text: '123456');
  }

  login() {
    DialogsView.loading().show();
    String? errorMessage;
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      errorMessage = 'Please fill data';
    } else if (!emailController.text.isEmail) {
      errorMessage = 'Incorrect email';
    }
    if (errorMessage != null) {
      Get.back();
      DialogsView.message(
        'Login Error',
        errorMessage,
        actions: [
          DialogAction(
            text: 'OK',
            onPressed: () {
              Get.back();
            },
          )
        ],
      ).show();
      return;
    }

    authService.login(
      emailController.text,
      passwordController.text,
      (message) {
        Get.back();
        DialogsView.message(
          'Login Error',
          message,
          actions: [
            DialogAction(
              text: 'Ok',
              onPressed: () {
                Get.back();
              },
            )
          ],
        ).show();
      },
    );
  }
}
