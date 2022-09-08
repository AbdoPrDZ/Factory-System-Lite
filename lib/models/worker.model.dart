import 'package:get/get.dart';

import '../services/main.service.dart';

class WorkerModel {
  final String id, username, email, backgroundimgUrl, profileImgUrl;
  final int workedDays, payedDays, startWorkHour, workHours;
  final Duration extraTime;

  const WorkerModel(
    this.id,
    this.username,
    this.email,
    this.backgroundimgUrl,
    this.profileImgUrl,
    this.workedDays,
    this.payedDays,
    this.extraTime,
    this.startWorkHour,
    this.workHours,
  );

  static initListiner() async {
    final mainService = Get.find<MainService>();
    final doc =
        mainService.storageDatabase.collection('data').document('workers');
    mainService.firebaseDatabase.ref('workers').onValue.listen((event) {
      doc.set(event.snapshot.value, keepData: false);
    });
  }

  static WorkerModel? fromCash() {
    Map<String, dynamic>? workerData = Get.find<MainService>()
        .storageDatabase
        .document('settings/worker')
        .get();
    if (workerData != null && workerData.isNotEmpty) {
      return fromMap(workerData);
    }
    return null;
  }

  static Future<WorkerModel?> fromId(String id) async {
    Map? data = (await Get.find<MainService>()
            .firebaseDatabase
            .ref('workers/$id')
            .get())
        .value as Map?;
    if (data != null) return fromMap(data);
    return null;
  }

  static WorkerModel fromMap(Map data) {
    return WorkerModel(
      data['id'],
      data['username'],
      data['email'],
      data['background_img_url'],
      data['profile_img_url'],
      data['worked_days'],
      data['payed_days'],
      Duration(minutes: data['extra_time']),
      data['start_work_hour'],
      data['work_hours'],
    );
  }

  Map toMap() => {
        'id': id,
        'username': username,
        'email': email,
        'background_img_url': backgroundimgUrl,
        'profile_img_url': profileImgUrl,
        'worked_days': workedDays,
        'payed_days': payedDays,
        'extra_time': extraTime,
      };
}
