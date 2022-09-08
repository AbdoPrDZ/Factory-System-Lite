import 'package:get/get.dart';

import '../services/main.service.dart';
import 'model.dart';

class ClothType extends Model {
  final int id;
  final String name, machine;
  // final List<String> requiredThreads;

  ClothType(
    this.id,
    this.name,
    this.machine,
    // this.requiredThreads,
  );

  static initListiner() async {
    final mainService = Get.find<MainService>();
    final doc =
        mainService.storageDatabase.collection('data').document('cloth_types');
    mainService.firebaseDatabase.ref('cloth_types').onValue.listen((event) {
      doc.set(event.snapshot.value, keepData: false);
    });
  }

  static ClothType fromMap(Map data) => ClothType(
        data['id'],
        data['name'],
        data['machine'],
        // List<String>.from(data['required_threads']),
      );

  static List<ClothType> allFromMap(List<Map> items) =>
      [for (Map data in items) fromMap(data)];

  static Future<ClothType?> fromId(int id) async {
    Map? data = (await Get.find<MainService>()
            .firebaseDatabase
            .ref('cloth_types/$id')
            .get())
        .value as Map?;
    if (data != null) return fromMap(data);
    return null;
  }

  static Future<List<ClothType>> allFromFirebase() async {
    List? data = (await Get.find<MainService>()
            .firebaseDatabase
            .ref('cloth_types')
            .get())
        .value as List?;
    if (data != null) return allFromMap(List<Map>.from(data));
    return [];
  }
}
