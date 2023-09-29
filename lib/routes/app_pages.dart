import 'package:get/get.dart';
import 'package:sample/ui/views/dashboard_page.dart';
import 'package:sample/ui/views/login_page.dart';
import 'package:sample/ui/views/settings_page.dart';

part './app_routes.dart';

abstract class Pages{

  static final pages = [
    GetPage(name: Routes.DASHBOARD, page:() => const DashboardPage()),
    GetPage(name: Routes.LOGIN, page:() => const LoginPage()),
    GetPage(name: Routes.SETTINGS, page:() => const SettingsPage())
  ];
}
