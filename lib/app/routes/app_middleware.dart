import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../modules/auth/controllers/auth_controller.dart';
import 'app_routes.dart';

class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    if (!authController.isLoggedIn) {
      return const RouteSettings(name: AppRoutes.login);
    }
    return null;
  }
}

class GuestGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    if (authController.isLoggedIn) {
      return const RouteSettings(name: AppRoutes.home);
    }
    return null;
  }
}
