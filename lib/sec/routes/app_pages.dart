import 'package:get/get.dart';
import 'package:jouls_labs_demo_app/sec/feature/authentication/view/login_page.dart';
import 'package:jouls_labs_demo_app/sec/feature/home/view/dashboard_page.dart';
import 'package:jouls_labs_demo_app/sec/feature/home/view/downloaded_pdf_page.dart';
import 'package:jouls_labs_demo_app/sec/feature/onboarding/splash_screen.dart';
import 'package:jouls_labs_demo_app/sec/feature/profile/profile_page.dart';
import 'package:jouls_labs_demo_app/sec/routes/app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: Routes.initial,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: Routes.splash,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const DashboardPage(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => ProfileScreen(),
    ),
    GetPage(
      name: Routes.downloadedPdf,
      page: () => const DownloadedPdfPage(),
    ),
  ];
}
