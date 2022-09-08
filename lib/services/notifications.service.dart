import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NotificationsService extends GetxService {
  late FirebaseMessaging firebaseMessaging;

  @override
  void onInit() {
    firebaseMessaging = FirebaseMessaging.instance;
    super.onInit();
  }

  Future init() async {
    NotificationSettings settings =
        await firebaseMessaging.requestPermission(sound: false);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((message) {
        print(message.data);
      });
      // await firebaseMessaging.sendMessage(
      //   to: "QUv64ag9DOcjkjEievGQuXM0V5y2",
      //   data: {
      //     'title': 'message from user',
      //     'message': 'successfully sending message'
      //   },
      //   messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      // );
    }
  }

  Future sendNotification(String title, String message) async {}
}
