import '../pages/add_edit_client/page.dart';
import '../pages/add_invoice/page.dart';
import '../pages/add_edit_order/page.dart';
import '../pages/add_unit/page.dart';
import '../pages/client/page.dart';
import '../pages/home/page.dart';
import '../pages/invoice/page.dart';
import '../pages/loading/page.dart';
import '../pages/login/page.dart';
import '../pages/order/page.dart';
import '../pages/signup/page.dart';
import '../pages/start/page.dart';
import '../utils/page_info.dart';
import 'middlewares.dart';

class PagesInfo {
  static PageInfo get loading => PageInfo(
        "/loading",
        () => LoadingPage(),
        middlwares: [Middlewares.auth],
      );
  static PageInfo get start => PageInfo(
        "/start",
        () => StartPage(),
        middlwares: [Middlewares.auth],
      );
  static PageInfo get signup => PageInfo(
        "/signup",
        () => SignupPage(),
        middlwares: [Middlewares.auth],
      );
  static PageInfo get login => PageInfo(
        "/login",
        () => LoginPage(),
        middlwares: [Middlewares.auth],
      );
  static PageInfo get home => PageInfo(
        "/home",
        () => HomePage(),
        middlwares: [Middlewares.auth],
      );
  static PageInfo get addEditClient => PageInfo(
        "/addEditClient",
        () => AddEditClientPage(),
        middlwares: [Middlewares.auth],
      );
  static PageInfo get addEditOrder => PageInfo(
        "/addEditOrder",
        () => AddEditOrderPage(),
        middlwares: [Middlewares.auth],
      );
  static PageInfo get addUnit => PageInfo(
        "/addUnit",
        () => AddUnitPage(),
        middlwares: [Middlewares.auth],
      );
  static PageInfo get addInvoice => PageInfo(
        "/addInvoice",
        () => AddInvoicePage(),
        middlwares: [Middlewares.auth],
      );
  static PageInfo get client => PageInfo(
        "/client",
        () => ClientPage(),
        middlwares: [Middlewares.auth],
      );
  static PageInfo get order => PageInfo(
        "/order",
        () => OrderPage(),
        middlwares: [Middlewares.auth],
      );
  static PageInfo get invoice => PageInfo(
        "/invoice",
        () => InvoicePage(),
        middlwares: [Middlewares.auth],
      );

  static PageInfo initialPage = loading;
  static PageInfo onAuthPage = home;
  static PageInfo onUnAuthPage = loading;

  static List<String> unAuthPages = [
    loading.pageName,
    start.pageName,
    signup.pageName,
    login.pageName,
  ];

  static List<PageInfo> get routes => [
        loading,
        start,
        signup,
        login,
        home,
        addEditClient,
        addEditOrder,
        addUnit,
        addInvoice,
        client,
        order,
        invoice,
      ];
}
