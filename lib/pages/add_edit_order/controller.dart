import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/client.model.dart';
import '../../models/cloth_type.model.dart';
import '../../models/order.model.dart';
import '../../models/thread.model.dart';
import '../../services/main.service.dart';
import '../../src/theme.dart';
import '../../views/dialogs.view.dart';

class AddEditOrderController extends GetxController {
  late MainService mainService;

  late TextEditingController threadTypeController;
  late TextEditingController threadColorController;
  late TextEditingController threadCountController;
  late TextEditingController threadWeightController;

  RxString action = 'Add'.obs;

  @override
  void onInit() async {
    super.onInit();
    mainService = Get.find<MainService>();
    ClothType.allFromFirebase().then((value) {
      clothTypes.value = value;
      update();
    });
    ClientModel.allFromFirebase().then((value) {
      clients.value = value;
      update();
    });

    threadTypeController = TextEditingController();
    threadColorController = TextEditingController();
    threadCountController = TextEditingController();
    threadWeightController = TextEditingController();

    Map? args = Get.arguments;
    action.value = args?['action'] ?? 'Add';
    if (args != null && action.value == 'Edit' && args.containsKey('order')) {
      oldOrder = args['order'];
      clientId.value = oldOrder!.client!.id;
      clothTypeId.value = oldOrder!.clothType!.id;
      threads.value = oldOrder!.threads;
      update();
    }
  }

  OrderModel? oldOrder;

  RxList<ClothType> clothTypes = <ClothType>[].obs;
  RxList<ClientModel> clients = <ClientModel>[].obs;
  RxList<ThreadModel> threads = <ThreadModel>[].obs;

  RxInt clothTypeId = (-1).obs;
  RxInt clientId = (-1).obs;

  addThread() {
    if (threadTypeController.text.isNotEmpty &&
        threadColorController.text.isNotEmpty &&
        threadCountController.text.isNotEmpty &&
        threadWeightController.text.isNotEmpty) {
      threads.add(ThreadModel(
        threadTypeController.text,
        threadColorController.text,
        int.parse(threadCountController.text),
        double.parse(threadWeightController.text),
      ));
      threadTypeController.clear();
      threadColorController.clear();
      threadCountController.clear();
      threadWeightController.clear();
      update();
    } else {
      DialogsView.message(
        'Add thread error',
        'please fill all data to add thread',
        actions: [
          DialogAction(
            text: 'Ok',
            onPressed: () => Get.back(),
          )
        ],
      ).show();
    }
  }

  onThreadDelete(ThreadModel thread) {
    threads.remove(thread);
    update();
  }

  bool checkValues() {
    DialogsView.loading().show();
    if (threads.isEmpty || clientId.value == -1 || clothTypeId.value == -1) {
      Get.back();
      DialogsView.message(
        '${action.value} order error',
        'Please fill all data',
        actions: [
          DialogAction(
            text: 'Ok',
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ).show();
      return false;
    }
    return true;
  }

  addOrder() async {
    if (!checkValues()) return;

    DatabaseReference ordersRef = mainService.firebaseDatabase.ref('orders');
    int id = ((await ordersRef.get()).value as List?)?.length ?? 0;
    await ordersRef.child('$id').set({
      'id': id,
      'client_id': clientId.value,
      'cloth_type_id': clothTypeId.value,
      'start_product': null,
      'end_product': null,
      'threads': [for (ThreadModel thread in threads) thread.toMap()],
      'total_weight': 0,
      'units_count': 0,
    });

    DatabaseReference clientOrdersRef = mainService.firebaseDatabase.ref(
      'clients/${clientId.value}/orders',
    );
    List clientOrders = [];
    var val = (await clientOrdersRef.get()).value as List?;
    if (val != null) clientOrders.addAll(val);
    clientOrders.add(id);
    await clientOrdersRef.set(clientOrders);

    Get.back();
    DialogsView.message(
      'Add order',
      'Successfully addding order',
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

  editOrder() async {
    if (!checkValues()) return;

    bool save = false;
    await DialogsView.message(
      'Edit Order',
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
    DatabaseReference orderRef = mainService.firebaseDatabase.ref(
      'order/${oldOrder!.id}',
    );
    await orderRef.update({
      'client_id': clientId.value,
      'cloth_type_id': clothTypeId.value,
      'threads': [for (ThreadModel thread in threads) thread.toMap()],
    });

    Get.back();
    DialogsView.message(
      'Edit order',
      'Successfully editing order',
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
