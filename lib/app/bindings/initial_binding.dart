import 'package:get/get.dart';

import '../../data/database/database_helper.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/expense_service.dart';
import '../../data/services/export_service.dart';
import '../../modules/auth/controllers/auth_controller.dart';
import '../../modules/expense/controllers/expense_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DatabaseHelper>(DatabaseHelper(), permanent: true);
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<ExpenseService>(ExpenseService(), permanent: true);
    Get.put<ExportService>(ExportService(), permanent: true);

    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<ExpenseController>(ExpenseController(), permanent: true);
  }
}
