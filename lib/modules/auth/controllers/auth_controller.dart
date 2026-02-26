import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../data/models/app_user.dart';
import '../../../data/models/currency_option.dart';
import '../../../data/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final Rxn<AppUser> currentUser = Rxn<AppUser>();
  final isLoading = false.obs;

  bool get isLoggedIn => currentUser.value != null;
  String get currencyCode => currentUser.value?.currencyCode ?? 'USD';
  String get currencySymbol => AppCurrencies.byCode(currencyCode).symbol;

  @override
  void onInit() {
    super.onInit();
    restoreSession();
  }

  Future<void> restoreSession() async {
    isLoading.value = true;
    try {
      final userId = await _authService.getSessionUserId();
      if (userId != null) {
        final user = await _authService.getUserById(userId);
        currentUser.value = user;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String currencyCode,
  }) async {
    isLoading.value = true;
    try {
      final user = await _authService.register(
        name: name,
        email: email,
        password: password,
        currencyCode: currencyCode,
      );
      currentUser.value = user;
      Get.offAllNamed(AppRoutes.home);
      Get.snackbar('Success', 'Account created successfully.');
    } catch (error) {
      Get.snackbar(
        'Register Failed',
        error.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login({required String email, required String password}) async {
    isLoading.value = true;
    try {
      final user = await _authService.login(email: email, password: password);
      currentUser.value = user;
      Get.offAllNamed(AppRoutes.home);
      Get.snackbar('Welcome', 'Login successful.');
    } catch (error) {
      Get.snackbar(
        'Login Failed',
        error.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authService.clearSession();
    currentUser.value = null;
    Get.offAllNamed(AppRoutes.login);
    Get.snackbar('Logged out', 'You have been logged out.');
  }
}
