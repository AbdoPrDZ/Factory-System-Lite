import 'package:factory_system_lite/models/client.model.dart';
import 'package:factory_system_lite/src/theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/main.service.dart';
import '../../views/dialogs.view.dart';

class AddEditClientController extends GetxController {
  late MainService mainService;

  late TextEditingController fullnameController;
  late TextEditingController phoneController;

  @override
  void onInit() {
    mainService = Get.find<MainService>();

    fullnameController = TextEditingController();
    phoneController = TextEditingController();

    Map? args = Get.arguments;
    action.value = args?['action'] ?? 'Add';
    if (args != null && action.value == 'Edit' && args.containsKey('client')) {
      oldClient = args['client'];
      fullnameController.text = oldClient!.fullname;
      phoneController.text = oldClient!.phone;
      update();
    }
    super.onInit();
  }

  RxString action = 'Add'.obs;
  ClientModel? oldClient;

  bool checkValues() {
    DialogsView.loading().show();
    String? error;
    if (fullnameController.text.isEmpty || phoneController.text.isEmpty) {
      error = 'Please fill all data';
    } else if (!phoneController.text.isPhoneNumber) {
      error = 'Invalid phone';
    }
    if (error != null) {
      Get.back();
      DialogsView.message(
        'Add client error',
        error,
        actions: [
          DialogAction(
            text: 'Ok',
            onPressed: () {
              Get.back();
            },
          )
        ],
      ).show();
      return false;
    }
    return true;
  }

  addClient() async {
    if (!checkValues()) return;

    DatabaseReference clientsRef = mainService.firebaseDatabase.ref('clients');
    int id = ((await clientsRef.get()).value as List?)?.length ?? 0;
    await clientsRef.child(id.toString()).set({
      'id': id,
      'fullname': fullnameController.text,
      'phone': phoneController.text,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });

    Map data = {'success': true, 'message': 'successfully adding client'};
    Get.back();
    DialogsView.message(
      'Add client ${data['success'] ? '' : ' error'}',
      data['message'],
      actions: [
        DialogAction(
          text: 'Ok',
          onPressed: () {
            Get.back();
          },
        ),
      ],
    ).show();
  }

  editClient() async {
    if (!checkValues()) return;

    bool save = false;
    await DialogsView.message(
      'Edit Client',
      'Are you sure you want to save changes?',
      actions: [
        DialogAction(
          text: 'Yes',
          onPressed: () {
            save = true;
            Get.back();
          },
        ),
        DialogAction(
          text: 'No',
          actionColor: UIColors.danger,
          onPressed: () {
            Get.back();
          },
        ),
      ],
    ).show();

    if (!save) {
      Get.back();
      return;
    }

    DatabaseReference clientsRef = mainService.firebaseDatabase.ref('clients');
    await clientsRef.child(oldClient!.id.toString()).update({
      'fullname': fullnameController.text,
      'phone': phoneController.text,
    });

    Get.back();
    DialogsView.message(
      'Edit client',
      'Successfully editing client',
      actions: [
        DialogAction(
          text: 'OK',
          onPressed: () {
            Get.back();
          },
        )
      ],
    ).show();
  }
}
