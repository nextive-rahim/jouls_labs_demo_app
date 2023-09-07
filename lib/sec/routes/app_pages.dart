import 'package:get/get.dart';
import 'package:jouls_labs_demo_app/sec/feature/authentication/view/login_page.dart';
import 'package:jouls_labs_demo_app/sec/routes/app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: Routes.initial,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
    ),
  ];
}
