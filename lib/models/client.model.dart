import 'package:get/get.dart';

import '../services/main.service.dart';
import 'model.dart';

class ClientModel extends Model {
  final int id;
  final String fullname, phone;
  final DateTime createdAt;

  ClientModel(
    this.id,
    this.fullname,
    this.phone,
    this.createdAt,
  );

  static initListiner() async {
    final mainService = Get.find<MainService>();
    final doc =
        mainService.storageDatabase.collection('data').document('clients');
    mainService.firebaseDatabase.ref('clients').onValue.listen((event) {
      doc.set(event.snapshot.value, keepData: false);
    });
  }

  static Future<ClientModel?> fromId(int id) async {
    Map? data = (await Get.find<MainService>()
            .firebaseDatabase
            .ref('clients/$id')
            .get())
        .value as Map?;
    if (data != null) return fromMap(data);
    return null;
  }

  static Future<List<ClientModel>> allFromFirebase() async {
    List? data =
        (await Get.find<MainService>().firebaseDatabase.ref('clients').get())
            .value as List?;
    if (data != null) return allFromMap(List<Map>.from(data));
    return [];
  }

  static Stream<List<ClientModel>> stream() => Get.find<MainService>()
          .storageDatabase
          .document('data/clients')
          .stream()
          .asyncExpand<List<ClientModel>>((event) async* {
        // if (event.snapshot.value != null) {
        //   List data = event.snapshot.value as List;
        if (event != null) {
          List data = event as List;
          if (data.isNotEmpty) {
            yield allFromMap(data);
          }
        }
      });

  static List<ClientModel> allFromMap(List items) =>
      [for (Map data in items) fromMap(data)];

  static ClientModel fromMap(Map data) => ClientModel(
        data['id'],
        data['fullname'],
        data['phone'],
        DateTime.fromMillisecondsSinceEpoch(data['created_at']),
      );

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'fullname': fullname,
        'phone': phone,
        'created_at': createdAt,
      };
}
