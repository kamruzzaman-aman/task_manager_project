import 'package:get/get.dart';
import 'package:task_manager_project/business_logics/controllers/auth_controller.dart';
import 'package:task_manager_project/business_logics/controllers/login_controller.dart';
import 'package:task_manager_project/business_logics/controllers/sign_up_controller.dart';
import 'package:task_manager_project/business_logics/controllers/task_list_task_status_count_controller.dart';
import 'package:task_manager_project/business_logics/controllers/update_delete_controller.dart';
import 'package:task_manager_project/business_logics/controllers/verify_controller.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    Get.put(LoginController());
    Get.put(AuthController());
    Get.put(TaskListTaskStatusCountController());
    Get.put(UpdateDeleteTask());
    Get.put(SignUpController());
    Get.put(EmailPassVerifyController());

  }

}