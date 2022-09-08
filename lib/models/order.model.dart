import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modes/order_status.mode.dart';
import '../services/main.service.dart';
import 'client.model.dart';
import 'cloth_type.model.dart';
import 'model.dart';
import 'thread.model.dart';

class OrderModel extends Model {
  final int id;
  final ClientModel? client;
  final ClothType? clothType;
  final DateTime? startProduct, endProduct;
  final List<ThreadModel> threads;
  final double totalWeight;
  final int unitsCount;

  OrderModel(
    this.id,
    this.client,
    this.clothType,
    this.startProduct,
    this.endProduct,
    this.threads,
    this.totalWeight,
    this.unitsCount,
  );

  static initListiner() async {
    final mainService = Get.find<MainService>();
    final doc =
        mainService.storageDatabase.collection('data').document('orders');
    mainService.firebaseDatabase.ref('orders').onValue.listen((event) {
      doc.set(event.snapshot.value, keepData: false);
    });
  }

  OrderStatus get status => startProduct == null
      ? OrderStatus.waiting
      : endProduct == null
          ? OrderStatus.inProgress
          : OrderStatus.ended;

  Duration get productionTime => startProduct != null
      ? DateTimeRange(start: startProduct!, end: endProduct ?? DateTime.now())
          .duration
      : const Duration();

  static Future<OrderModel> fromMap(Map data) async => OrderModel(
        data['id'],
        await ClientModel.fromId(data['client_id']),
        await ClothType.fromId(data['cloth_type_id']),
        data['start_product'] != null
            ? DateTime.fromMillisecondsSinceEpoch(data['start_product'])
            : null,
        data['end_product'] != null
            ? DateTime.fromMillisecondsSinceEpoch(data['end_product'])
            : null,
        List<ThreadModel>.generate(
          data['threads'].length,
          (index) => ThreadModel.fromMap(data['threads'][index]),
        ),
        double.parse(data['total_weight'].toString()),
        data['units_count'],
      );

  static Future<OrderModel?> fromId(int id) async {
    Map? data =
        (await Get.find<MainService>().firebaseDatabase.ref('orders/$id').get())
            .value as Map?;
    if (data != null) return fromMap(data);
    return null;
  }

  static Future<List<OrderModel>> allFromFirebase() async {
    List? data =
        (await Get.find<MainService>().firebaseDatabase.ref('orders').get())
            .value as List?;
    if (data != null) return allFromMap(List<Map>.from(data));
    return [];
  }

  static Stream<List<OrderModel>> stream() => Get.find<MainService>()
          .firebaseDatabase
          .ref('orders')
          .onValue
          .asyncExpand<List<OrderModel>>((event) async* {
        if (event.snapshot.value != null) {
          List data = event.snapshot.value as List;
          if (data.isNotEmpty) {
            yield await allFromMap(data);
          }
        }
      });

  static Future<List<OrderModel>> allFromMap(List items) async =>
      [for (Map data in items) await fromMap(data)];

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'client': client?.fullname ?? '',
        'cloth_type': '${clothType?.name} (${clothType?.machine})',
        'start_product': startProduct,
        'end_product': endProduct,
        'threads': threads.map((e) => e.type).toList().join(' - '),
        'units_count': unitsCount,
        'total_weight': totalWeight,
        'status': status.mode,
      };
}
