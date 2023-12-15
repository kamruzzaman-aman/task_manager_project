//401 Unauthorized Handling
import 'package:get/get.dart';
import 'package:task_manager_project/business_logics/controllers/auth_controller.dart';
import 'package:task_manager_project/ui/screens/auth/login_screen.dart';

class UnauthorizedHandle {
  static Future<void> backToLogin() async {
    await AuthController.clearAuthData();
    Get.offAll(() => const LoginScreen());
  }
}
