import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';

import 'pkgs/route.pkg.dart';
import 'services/main.service.dart';
import 'src/consts.dart';
import 'src/pages_info.dart';
import 'src/theme.dart';

void main() async {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBZ6L_zqRIaBNrJ0JwkAwok-4pySd4kZfU",
        authDomain: "factory-system-lite.firebaseapp.com",
        databaseURL: "https://factory-system-lite-default-rtdb.firebaseio.com",
        projectId: "factory-system-lite",
        storageBucket: "factory-system-lite.appspot.com",
        messagingSenderId: "493371924444",
        appId: "1:493371924444:web:23a177d70a71c3cb753919",
        measurementId: "G-5T2B34T4GC",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FlutterNativeSplash.remove();
    Get.put(MainService());
    return OverlaySupport(
      child: GetMaterialApp(
        title: Consts.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "DMSans",
          primaryColor: UIColors.primary1,
          backgroundColor: UIColors.primary1,
        ),
        getPages: RoutePkg.pages,
        initialRoute: PagesInfo.initialPage.pageName,
      ),
    );
  }
}
