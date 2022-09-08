import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../src/theme.dart';
import '../../views/button.view.dart';
import '../../views/text_edit.view.dart';
import '../page.dart' as page;
import 'controller.dart';

class LoginPage extends page.Page<LoginController> {
  LoginPage({Key? key}) : super(LoginController(), key: key);

  @override
  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back,
                color: UIThemeColors.text1,
                size: 45,
              ),
            ),
          ),
          const Gap(30),
          Text(
            'Login',
            style: TextStyle(
              color: UIThemeColors.text2,
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(30),
          TextEditView(
            controller: controller.emailController,
            prefixIcon: Icons.email,
            hint: 'Email',
          ),
          TextEditView(
            controller: controller.passwordController,
            prefixIcon: Icons.password,
            hint: 'Password',
            entryType: TextInputType.visiblePassword,
          ),
          ButtonView.text(
            onPressed: controller.login,
            text: 'Login',
          ),
          const Spacer(),
          Text(
            'Factory-System-Lite 2022\nⒸ Powred By Abdo Pr',
            style: TextStyle(
              color: UIThemeColors.text3,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
