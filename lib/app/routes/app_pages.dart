import 'package:get/get.dart';

import '../../modules/auth/views/login_view.dart';
import '../../modules/auth/views/register_view.dart';
import '../../modules/auth/views/splash_view.dart';
import '../../modules/home/views/home_view.dart';
import '../../modules/settings/views/settings_view.dart';
import 'app_middleware.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage<dynamic>(name: AppRoutes.splash, page: () => const SplashView()),
    GetPage<dynamic>(
      name: AppRoutes.login,
      page: () => LoginView(),
      middlewares: [GuestGuard()],
    ),
    GetPage<dynamic>(
      name: AppRoutes.register,
      page: () => RegisterView(),
      middlewares: [GuestGuard()],
    ),
    GetPage<dynamic>(
      name: AppRoutes.home,
      page: () => HomeView(),
      middlewares: [AuthGuard()],
    ),
    GetPage<dynamic>(
      name: AppRoutes.settings,
      page: () => SettingsView(),
      middlewares: [AuthGuard()],
    ),
  ];
}
