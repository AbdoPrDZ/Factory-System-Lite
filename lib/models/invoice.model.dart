import 'package:get/get.dart';

import '../services/main.service.dart';
import 'model.dart';
import 'order.model.dart';
import 'worker.model.dart';

class InvoiceModel extends Model {
  final int id;
  final OrderModel? order;
  final WorkerModel? invoicedBy;
  final double totalWeight;
  final int unitsCount;
  final String transportName, transportPhone;
  final DateTime createdAt;

  InvoiceModel(
    this.id,
    this.order,
    this.invoicedBy,
    this.unitsCount,
    this.totalWeight,
    this.transportName,
    this.transportPhone,
    this.createdAt,
  );

  static initListiner() async {
    final mainService = Get.find<MainService>();
    final doc =
        mainService.storageDatabase.collection('data').document('invoices');
    mainService.firebaseDatabase.ref('invoices').onValue.listen((event) {
      doc.set(event.snapshot.value, keepData: false);
    });
  }

  static Future<InvoiceModel> fromMap(Map data) async => InvoiceModel(
        data['id'],
        await OrderModel.fromId(data['order_id']),
        await WorkerModel.fromId(data['invoiced_by']),
        data['units_count'],
        double.parse((data['total_weight'] ?? 0).toString()),
        // List<int>.from(data['units'] as List? ?? []),
        data['transport_name'],
        data['transport_phone'],
        DateTime.fromMillisecondsSinceEpoch(data['created_at']),
      );

  static Stream<List<InvoiceModel>> stream() => Get.find<MainService>()
          .firebaseDatabase
          .ref('invoices')
          .onValue
          .asyncExpand<List<InvoiceModel>>((event) async* {
        if (event.snapshot.value != null) {
          List data = event.snapshot.value as List;
          if (data.isNotEmpty) {
            yield await allFromMap(data);
          }
        }
      });

  static Future<List<InvoiceModel>> allFromMap(List items) async =>
      [for (Map data in items) await fromMap(data)];
  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'invoiced_by': invoicedBy?.username ?? '',
        'client': order?.client?.fullname ?? '',
        'total_weight': totalWeight,
        'units_count': unitsCount,
        'created_at': createdAt,
      };
}
