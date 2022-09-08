import 'package:factory_system_lite/models/invoice.model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/unit.model.dart';
import '../../pkgs/route.pkg.dart';
import '../../services/auth.service.dart';
import '../../services/main.service.dart';
import '../../src/pages_info.dart';
import '../../views/dialogs.view.dart';

class AddInvoiceController extends GetxController {
  late MainService mainService;
  late AuthService authService;

  late TextEditingController trasportNameController;
  late TextEditingController trasportPhoneController;

  RxList orders = [].obs;
  Rx<int> orderId = (-1).obs;
  RxList<UnitModel> orderUnits = <UnitModel>[].obs;
  RxList<UnitModel> invoiceUnits = <UnitModel>[].obs;
  double get totalInvoicedWeight {
    double total = 0;
    for (var unit in invoiceUnits) {
      total += unit.weight;
    }
    return total;
  }

  @override
  void onInit() async {
    mainService = Get.find<MainService>();
    authService = Get.find<AuthService>();
    trasportNameController = TextEditingController();
    trasportPhoneController = TextEditingController();

    orderId.listen(getOrderUnits);

    super.onInit();
  }

  getOrderUnits(int orderId) async {
    if (orderId == -1) return;
    List? items = (await mainService.firebaseDatabase
            .ref('units/o-$orderId/on-stock')
            .get())
        .value as List?;

    if (items != null) {
      orderUnits.value = await UnitModel.allFromMap(items);
      update();
    }
  }

  addInvoce() async {
    DialogsView.loading().show();
    if (orderId.value == -1 ||
        trasportNameController.text.isEmpty ||
        trasportPhoneController.text.isEmpty) {
      Get.back();
      DialogsView.message(
        'Add invoice error',
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

    DatabaseReference invoicesRef =
        mainService.firebaseDatabase.ref('invoices');
    int invoiceId = ((await invoicesRef.get()).value as List?)?.length ?? 0;

    DatabaseReference orderUnitsRef =
        mainService.firebaseDatabase.ref('units/o-${orderId.value}');

    int id = ((await orderUnitsRef.get()).value as List?)?.length ?? 0;
    for (UnitModel unit in invoiceUnits) {
      Map unitData =
          (await orderUnitsRef.child('on-stock/${unit.id}').get()).value as Map;
      unitData['id'] = id;
      unitData['invoiced_at'] = DateTime.now().millisecondsSinceEpoch;
      unitData['invoice_id'] = invoiceId;
      await orderUnitsRef.child('${unit.id}').remove();
      orderUnitsRef.child('invoiced/$id').set(unitData);
      id++;
    }

    await invoicesRef.child('$invoiceId').set({
      'id': invoiceId,
      'order_id': orderId.value,
      'invoiced_by': authService.firebaseAuth.currentUser!.uid,
      'total_weight': totalInvoicedWeight,
      'units_count': invoiceUnits.length,
      'transport_name': trasportNameController.text,
      'transport_phone': trasportPhoneController.text,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });

    Get.back();
    await DialogsView.message(
      'Add invoice ',
      'Successfully addding invoice',
      actions: [
        DialogAction(
          text: 'OK',
          onPressed: () {
            Get.back();
          },
        ),
      ],
    ).show();

    Map? data = (await mainService.firebaseDatabase.ref('invoices/$id').get())
        .value as Map?;
    if (data != null) {
      await RoutePkg.to(
        PagesInfo.invoice,
        arguments: InvoiceModel.fromMap(data),
        // arguments: InvoiceModel.fromMap(data),
      );
      Get.back();
    }
  }
}
