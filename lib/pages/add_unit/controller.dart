import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../models/order.model.dart';
import '../../services/auth.service.dart';
import '../../services/main.service.dart';
import '../../views/dialogs.view.dart';

class AddUnitController extends GetxController {
  late MainService mainService;
  late AuthService authService;

  late TextEditingController unitWeightController;

  @override
  void onInit() {
    mainService = Get.find<MainService>();
    authService = Get.find<AuthService>();
    unitWeightController = TextEditingController();

    getOrders();
    super.onInit();
  }

  getOrders() async {
    orders.value = [
      for (OrderModel order in await OrderModel.allFromFirebase())
        if (order.endProduct == null) order
    ];
    update();
  }

  RxList<OrderModel> orders = <OrderModel>[].obs;
  Rx<int> orderId = (-1).obs;
  RxBool isLast = false.obs;

  addUnit() async {
    DialogsView.loading().show();
    if (orderId.value == -1 || unitWeightController.text.isEmpty) {
      Get.back();
      DialogsView.message(
        'Add unit error',
        'Please fill all data',
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
    DatabaseReference unitsRef =
        mainService.firebaseDatabase.ref('units/o-${orderId.value}/on-stock');
    List? refData = (await unitsRef.get()).value as List?;
    int id = refData != null ? refData.length : 0;
    int createdAt = DateTime.now().millisecondsSinceEpoch;
    unitsRef.child('$id').set({
      'id': 'o-${orderId.value}-$createdAt',
      'producted_by': authService.firebaseAuth.currentUser!.uid,
      'weight': double.parse(unitWeightController.text),
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });

    DatabaseReference orderRef = mainService.firebaseDatabase.ref(
      'orders/${orderId.value}',
    );
    if ((await orderRef.child('start_product').get()).value == null) {
      orderRef
          .child('start_product')
          .set(DateTime.now().millisecondsSinceEpoch);
    }
    if (isLast.value) {
      orderRef.child('end_product').set(DateTime.now().millisecondsSinceEpoch);
    }
    await orderRef.child('total_weight').set(
          ((await orderRef.child('total_weight').get()).value as double) +
              double.parse(unitWeightController.text),
        );
    await orderRef.child('units_count').set(double.parse(
            (await orderRef.child('units_count').get()).value.toString()) +
        1);

    Get.back();
    DialogsView.message(
      'Add unit',
      'Successfully addding unit\nDo not forget to place id on the unit',
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
