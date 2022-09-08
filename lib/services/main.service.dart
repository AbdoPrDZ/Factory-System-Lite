import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:storage_database/storage_database.dart';

import '../modes/ui_theme.mode.dart';

class MainService extends GetxService {
  late StorageDatabase storageDatabase;
  late FirebaseDatabase firebaseDatabase;

  Rx<UIThemeMode> themeMode = UIThemeMode.dark.obs;

  changeTheme(UIThemeMode themeMode) async {
    this.themeMode.value = themeMode;
    await Get.forceAppUpdate();
  }

  Future init({bool clear = false}) async {
    storageDatabase = await StorageDatabase.getInstance();
    await storageDatabase.initExplorer();
    await storageDatabase.explorer!.initNetWorkFiles();
    firebaseDatabase = FirebaseDatabase.instance;
    if (clear) {
      storageDatabase.clear();
      // await FirebaseAuth.instance.signOut();
    }
    initStorageDatabaseCollections();
  }

  initStorageDatabaseCollections({bool clear = false}) {
    if (clear) storageDatabase.clear();
    storageDatabase.collection("settings").set({
      'theme-mode': themeMode.value.mode,
      'lang': 'en',
    });
  }
}
