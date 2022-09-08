import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../src/theme.dart';
import '../../views/button.view.dart';
import '../../views/text_edit.view.dart';
import '../page.dart' as page;
import 'controller.dart';

class SignupPage extends page.Page<SignupController> {
  SignupPage({Key? key}) : super(SignupController(), key: key);

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
                color: UIThemeColors.text5,
                size: 45,
              ),
            ),
          ),
          const Gap(30),
          Text(
            'Signup',
            style: TextStyle(
              color: UIThemeColors.text2,
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(30),
          TextEditView(
            controller: controller.usernameController,
            prefixIcon: Icons.person,
            hint: 'Username',
          ),
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
          TextEditView(
            controller: controller.confirmController,
            prefixIcon: Icons.password,
            hint: 'Confirm',
            entryType: TextInputType.visiblePassword,
          ),
          ButtonView.text(
            onPressed: controller.signup,
            text: 'Signup',
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
