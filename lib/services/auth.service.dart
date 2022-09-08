import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/client.model.dart';
import '../models/cloth_type.model.dart';
import '../models/invoice.model.dart';
import '../models/order.model.dart';
import '../models/unit.model.dart';
import '../models/worker.model.dart';
import '../models/worker_status.model.dart';
import '../pkgs/route.pkg.dart';
import '../src/pages_info.dart';
import '../views/dialogs.view.dart';
import 'main.service.dart';

class AuthService extends GetxService {
  late MainService mainService;
  late FirebaseAuth firebaseAuth;

  @override
  onInit() {
    super.onInit();
    mainService = Get.find<MainService>();
    firebaseAuth = FirebaseAuth.instance;
  }

  init() {
    mainService.storageDatabase
        .collection('settings')
        .document('last_start_work')
        .stream()
        .listen((value) {
      if (value != null && value != -1) {
        lastStartWorkCall = DateTime.fromMillisecondsSinceEpoch(
          value as int,
        );
      }
    });
    mainService.storageDatabase
        .collection('settings')
        .document('last_end_work')
        .stream()
        .listen((value) {
      if (value != null && value != -1) {
        lastEndWorkCall = DateTime.fromMillisecondsSinceEpoch(
          value as int,
        );
      }
    });
  }

  onAuth() async {
    var workerData = (await mainService.firebaseDatabase
            .ref('workers/${firebaseAuth.currentUser!.uid}')
            .get())
        .value as Map?;
    mainService.storageDatabase
        .collection('settings')
        .set({'worker': workerData});

    // init models listeners
    WorkerModel.initListiner();
    WorkerStatus.initListiner();
    ClientModel.initListiner();
    OrderModel.initListiner();
    UnitModel.initListiner();
    InvoiceModel.initListiner();
    ClothType.initListiner();

    RoutePkg.to(PagesInfo.home, clearHeaders: true);
    await refreshTimer();
  }

  WorkerModel? get currentWorker => WorkerModel.fromCash();

  Timer? startTimer, endTimer;
  refreshTimer() async {
    DateTime now = DateTime.now();
    int startMS = DateTime(
          now.year,
          now.month,
          now.day,
          currentWorker!.startWorkHour,
        ).millisecondsSinceEpoch -
        now.millisecondsSinceEpoch;
    if (startTimer != null) startTimer!.cancel();
    startTimer = Timer.periodic(
      Duration(milliseconds: startMS < 0 ? (startMS + 86400000) : startMS),
      (timer) async => await startWork(),
    );
    if (startMS < 0) {
      await startWork(refresh: false);
    }

    int endMS = DateTime(
          now.year,
          now.month,
          now.day,
          currentWorker!.startWorkHour + currentWorker!.workHours,
        ).millisecondsSinceEpoch -
        now.millisecondsSinceEpoch;
    if (endTimer != null) endTimer!.cancel();
    endTimer = Timer.periodic(
      Duration(milliseconds: startMS < 0 ? (endMS + 86400000) : endMS),
      (timer) async => await startWork(),
    );
    if (endMS < 0) {
      await endWork(refresh: false);
    }
  }

  String get workerStatusId {
    DateTime now = DateTime.now();
    return 'd-${DateTime(
      now.year,
      now.month,
      now.day,
    ).millisecondsSinceEpoch}-u-${currentWorker!.id}';
  }

  DateTime? lastStartWorkCall;
  Future startWork({bool refresh = true}) async {
    DateTime now = DateTime.now();
    final workersStatusReff =
        mainService.firebaseDatabase.ref('workers_status');

    if (currentWorker == null ||
        (lastStartWorkCall != null &&
            now.year == lastStartWorkCall!.year &&
            now.month == lastStartWorkCall!.month &&
            now.day == lastStartWorkCall!.day) ||
        (await workersStatusReff.child(workerStatusId).get()).exists) return;

    workersStatusReff.child(workerStatusId).set({
      'id': workerStatusId,
      'worker_id': firebaseAuth.currentUser!.uid,
      'enter_date': now.millisecondsSinceEpoch,
      'excepted_from_admin': false,
      'units': [],
      'created_at': now.millisecondsSinceEpoch,
    });

    mainService.storageDatabase
        .collection('settings')
        .document('last_start_work')
        .set(now.millisecondsSinceEpoch);

    if (refresh) await refreshTimer();
  }

  DateTime? lastEndWorkCall;
  endWork({bool refresh = true}) async {
    DateTime now = DateTime.now();
    final workersStatusReff =
        mainService.firebaseDatabase.ref('workers_status');

    if (currentWorker == null ||
        (lastEndWorkCall != null &&
            now.year == lastEndWorkCall!.year &&
            now.month == lastEndWorkCall!.month &&
            now.day == lastEndWorkCall!.day) ||
        (await workersStatusReff.child(workerStatusId).get()).exists) return;

    TimeOfDay? extraTime;
    await DialogsView.message(
      'End Work',
      'Your work time is end.',
      isDismissible: false,
      actions: [
        DialogAction(
          text: 'OK',
          onPressed: () {
            Get.back();
          },
        ),
        DialogAction(
          text: 'Work extra time',
          onPressed: () async {
            extraTime = await showTimePicker(
              context: Get.context!,
              initialTime: TimeOfDay.now(),
            );
            if (extraTime != null && extraTime!.hour - now.hour > 0) Get.back();
          },
        ),
      ],
    ).show();
    if (extraTime != null) {
      if (endTimer != null) endTimer!.cancel();
      endTimer = Timer.periodic(
        Duration(minutes: extraTime!.minute - now.hour),
        (timer) => endWork(),
      );
    }
    workersStatusReff
        .child('$workerStatusId/end_date')
        .set(now.millisecondsSinceEpoch);

    mainService.storageDatabase
        .collection('settings')
        .document('last_end_work')
        .set(now.millisecondsSinceEpoch);

    if (refresh) await refreshTimer();
  }

  signup(
    String username,
    String email,
    String password,
    Function(String message) onField,
  ) async {
    try {
      UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        mainService.firebaseDatabase
            .ref('workers/${credential.user!.uid}')
            .set({
          'id': credential.user!.uid,
          'username': username,
          'email': credential.user!.email,
          'img_url':
              'https://www.shareicon.net/download/128x128//2016/09/01/822721_user_512x512.png',
          'profile_img_url':
              'https://www.indiantextilemagazine.in/wp-content/uploads/2016/10/Mayer-Cie-pic-1-768x511.jpg',
          'worked_days': 0,
          'payed_days': 0,
          'extra_time': 0,
          'joined_date': DateTime.now().millisecondsSinceEpoch,
        });
        await onAuth();
      } else {
        onField('Incorrect email or password');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        onField('The password is too weak.');
      } else if (e.code == 'email-already-in-use') {
        onField('The account already exists for that email.');
      }
    } catch (e) {
      onField(e.toString());
    }
  }

  login(String email, String password, Function(String message) onField) async {
    try {
      UserCredential auth = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (auth.user != null) {
        await onAuth();
      } else {
        onField('Incorrect email or password');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        onField('Invalid email.');
      } else if (e.code == 'wrong-password') {
        onField('Invalid password.');
      }
    } catch (e) {
      onField(e.toString());
    }
  }

  Future logout() async {
    DialogsView.loading().show();
    await firebaseAuth.signOut();
    mainService.storageDatabase.collection('settings').set({'worker': null});
    RoutePkg.to(PagesInfo.login);
  }
}
