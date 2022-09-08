import 'package:get/get.dart';

import '../modes/mode.dart';
import '../services/main.service.dart';
import 'model.dart';
import 'order.model.dart';
import 'worker.model.dart';

class UnitModel extends Model {
  final String id;
  final OrderModel? order;
  final String? productedBy;
  final double weight;
  final bool isInvoiced;
  final String? invoiceId;

  UnitModel(
    this.id,
    this.order,
    this.productedBy,
    this.weight,
    this.isInvoiced,
    this.invoiceId,
  );

  static initListiner() async {
    final mainService = Get.find<MainService>();
    final doc =
        mainService.storageDatabase.collection('data').document('units');
    mainService.firebaseDatabase.ref('units').onValue.listen((event) {
      doc.set(event.snapshot.value, keepData: false);
    });
  }

  DateTime get createdAt =>
      DateTime.fromMillisecondsSinceEpoch(int.parse(id.split('-')[2]));

  static Future<UnitModel> fromMap(Map data) async => UnitModel(
        data['id'],
        await OrderModel.fromId(int.parse(data['id'].split('-')[1])),
        (await WorkerModel.fromId(data['producted_by']))?.username,
        double.parse(data['weight'].toString()),
        data['is_invoiced'] ?? false,
        data['invoice_id'],
      );

  // static Future<List<UnitModel>> allFromFirebase({
  //   UnitsTarget target = UnitsTarget.onStock,
  //   String? invoiceId,
  // }) {

  // }

  static Stream<List<UnitModel>> stream({
    String? orderId,
    UnitsTarget target = UnitsTarget.onStock,
    String? targetInvoiceId,
  }) =>
      Get.find<MainService>()
          // .firebaseDatabase
          .storageDatabase
          // .ref(
          .document('data/units'
              // 'units${orderId != null ? '/$orderId' : ''}${orderId != null ? '/${target.mode}' : ''}${orderId != null && target.isInvoiced && targetInvoiceId != null ? '/$targetInvoiceId' : ''}',
              // 'units',
              )
          // .onValue
          .stream()
          .asyncExpand<List<UnitModel>>(
        (event) async* {
          // if (event.snapshot.value != null) {
          //   Map data = event.snapshot.value as Map;
          if (event != null) {
            Map data = event as Map;
            List<UnitModel> units = [];
            for (String _orderId in data.keys) {
              if ((orderId == null || orderId == _orderId) &&
                  data[_orderId][target.mode] != null) {
                if (target == UnitsTarget.onStock) {
                  for (int id = 0;
                      id < data[_orderId][target.mode].length;
                      id++) {
                    data[_orderId][target.mode][id]['order_id'] =
                        int.parse(_orderId.replaceAll('o-', ''));
                    units.add(await fromMap(data[_orderId][target.mode][id]));
                  }
                } else if (target == UnitsTarget.invoiced) {
                  for (String invoiceId in data[_orderId][target.mode]) {
                    for (int id = 0;
                        id < data[_orderId][target.mode][invoiceId].length;
                        id++) {
                      if (targetInvoiceId == null ||
                          invoiceId == targetInvoiceId) {
                        data[_orderId][target.mode][invoiceId][id]['order_id'] =
                            int.parse(_orderId.replaceAll('o-', ''));
                        data[_orderId][target.mode][invoiceId][id]
                            ['is_invoiced'] = true;
                        data[_orderId][target.mode][invoiceId][id]
                            ['invoice_id'] = invoiceId;
                        units.add(
                          await fromMap(
                            data[_orderId][target.mode][invoiceId][id],
                          ),
                        );
                      }
                    }
                  }
                }
              }
            }
            if (units.isNotEmpty) yield units;
          }
        },
      );

  static Future<List<UnitModel>> allFromMap(List items) async =>
      [for (Map data in items) await fromMap(data)];

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'producted_by': productedBy ?? '',
        'weight': weight,
        'created_at': createdAt,
        'client':
            "${order?.client?.fullname ?? '--'} (${order?.clothType?.name ?? '--'})",
      };
}

class UnitsTarget extends Mode<String> {
  const UnitsTarget._(String mode) : super(mode);

  static const UnitsTarget onStock = UnitsTarget._('on-stock');
  static const UnitsTarget invoiced = UnitsTarget._('invoiced');

  bool get isOnStock => this == UnitsTarget.onStock;
  bool get isInvoiced => this == UnitsTarget.invoiced;
}
