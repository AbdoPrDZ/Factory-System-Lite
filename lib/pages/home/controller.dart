import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/unit.model.dart';
import '../../models/worker_status.model.dart';
import '../../services/auth.service.dart';
import '../../services/main.service.dart';
import '../../src/theme.dart';
import '../../views/button.view.dart';
import '../../views/dialogs.view.dart';
import '../../views/text_edit.view.dart';

class HomeController extends GetxController {
  late MainService mainService;
  late AuthService authService;

  HomeController() {
    mainService = Get.find<MainService>();
    authService = Get.find<AuthService>();
  }

  editImg(String target) {
    TextEditingController imgController = TextEditingController();
    List<DialogAction> actions = [
      DialogAction(text: 'Edit', onPressed: () {}),
      DialogAction(
        text: 'Cancel',
        onPressed: () {
          Get.back();
        },
        actionColor: UIColors.danger,
      ),
    ];

    DialogsView(
      child: Flex(
        direction: Axis.vertical,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              'Edit $target image',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: UIThemeColors.text1,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 12,
              bottom: 16,
            ),
            child: TextEditView(label: 'Image url:', controller: imgController),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 3, right: 3),
            child: Flex(
              direction: Axis.horizontal,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: actions
                  .map((action) => ButtonView.text(
                        onPressed: action.onPressed,
                        text: action.text,
                        backgroundColor: action.actionColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    ).show();
  }
}
