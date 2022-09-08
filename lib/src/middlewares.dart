import 'package:get/get.dart';

import '../middlewares/auth.middleware.dart';

class Middlewares {
  static GetMiddleware auth = AuthMiddleware();
}
