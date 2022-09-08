import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/main.service.dart';
import 'model.dart';
import 'worker.model.dart';

class WorkerStatus extends Model {
  final String id;
  final WorkerModel? worker;
  final DateTime? enterDate, endDate;
  final List<int> unitsIds;
  final bool exceptedFromAdmin;

  WorkerStatus(
    this.id,
    this.worker,
    this.enterDate,
    this.endDate,
    this.unitsIds,
    this.exceptedFromAdmin,
  );

  static initListiner() async {
    final mainService = Get.find<MainService>();
    final doc = mainService.storageDatabase
        .collection('data')
        .document('workers_status');
    mainService.firebaseDatabase.ref('workers_status').onValue.listen((event) {
      doc.set(event.snapshot.value, keepData: false);
    });
  }

  static Future<WorkerStatus> fromMap(Map data) async => WorkerStatus(
        data['id'],
        await WorkerModel.fromId(data['worker_id']),
        data['enter_date'] != null
            ? DateTime.fromMillisecondsSinceEpoch(data['enter_date'])
            : null,
        data['end_date'] != null
            ? DateTime.fromMillisecondsSinceEpoch(data['end_date'])
            : null,
        List<int>.from(data['units'] ?? []),
        data['excepted_from_admin'],
      );

  static Future<List<WorkerStatus>> allFromMap(Map items) async =>
      [for (Map data in items.values) await fromMap(data)];

  static Stream<List<WorkerStatus>> stream() => Get.find<MainService>()
          .firebaseDatabase
          .ref('workers_status')
          .onValue
          .asyncExpand<List<WorkerStatus>>((event) async* {
        Map data = {};
        if (event.snapshot.value != null) data = event.snapshot.value as Map;
        yield await allFromMap(data);
      });

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'fullname': worker?.username ?? '--',
        'enter_time': enterDate,
        'end_time': endDate,
        'is_present': enterDate != null,
        'hour_count': enterDate != null
            ? DateTimeRange(end: endDate ?? DateTime.now(), start: enterDate!)
                .duration
                .inHours
            : 0,
        'units_count': unitsIds.length,
      };
}
