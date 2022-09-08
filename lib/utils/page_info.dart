import 'package:get/get.dart';

import '../pages/page.dart';

class PageInfo {
  final String pageName;
  final Page Function() page;
  final List<GetMiddleware>? middlwares;

  PageInfo(this.pageName, this.page, {this.middlwares});
}
