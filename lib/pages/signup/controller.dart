import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/auth.service.dart';
import '../../services/main.service.dart';
import '../../views/dialogs.view.dart';

class SignupController extends GetxController {
  late MainService mainService;
  late AuthService authService;

  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmController;

  SignupController() {
    mainService = Get.find<MainService>();
    authService = Get.find<AuthService>();

    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmController = TextEditingController();
  }

  signup() {
    DialogsView.loading().show();
    String? errorMessage;
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmController.text.isEmpty) {
      errorMessage = 'Please fill all data';
    } else if (!emailController.text.isEmail) {
      errorMessage = 'Invalid email';
    } else if (passwordController.text != confirmController.text) {
      errorMessage = 'Password and conform must be equals';
    }
    if (errorMessage != null) {
      Get.back();
      DialogsView.message(
        'Signup error',
        errorMessage,
        actions: [
          DialogAction(
            text: 'Ok',
            onPressed: () {
              Get.back();
            },
          )
        ],
      ).show();
      return;
    }
    authService.signup(
      usernameController.text,
      emailController.text,
      passwordController.text,
      (message) {
        Get.back();
        DialogsView.message(
          'Signup Error',
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
