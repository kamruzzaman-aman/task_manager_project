import 'dart:convert';

import 'package:get/get.dart';
import 'package:task_manager_project/business_logics/controllers/auth_controller.dart';
import 'package:task_manager_project/data/models/user_auth_model.dart';
import 'package:task_manager_project/data/network_caller/network_caller.dart';
import 'package:task_manager_project/data/network_caller/network_response.dart';
import 'package:task_manager_project/data/utility/urls.dart';
import 'package:task_manager_project/ui/widgets/update_task_alert_dialog.dart';

class UpdateDeleteTask extends GetxController {
  String? validationMessage;
  radioButtonValidation({TaskStatus? value, String? message}) {
    if (value != null) {
      validationMessage = null;
      update();
    } else {
      validationMessage = message;
      update();
    }
  }

//update task

  String _failedMessage = '';
  String get failedMessage => _failedMessage;
  //Update Task
  bool _updateTaskInProgress = false;
  bool get updateTaskInProgress => _updateTaskInProgress;
  Future<bool> updateTaskStatusMethod(
      String taskId, TaskStatus? selectedStatus) async {
    _updateTaskInProgress = true;
    update();
    NetworkResponse response = await NetworkCaller().getRequest(
        Urls.updateTaskStatus(
            taskId, selectedStatus.toString().split('.').last));
    _updateTaskInProgress = false;
    update();
    if (response.isSuccess) {
      _failedMessage = "Update Success";
      return true;
    }
    return false;
  }

  //delete task
  bool _deleteTaskInProgress = false;
  bool get deleteTaskInProgress => _deleteTaskInProgress;
  Future<bool> deleteTask(String taskID) async {
    _deleteTaskInProgress = true;
    update();
    NetworkResponse response =
        await NetworkCaller().getRequest(Urls.deleteTask(taskID));
    _deleteTaskInProgress = true;
    update();
    if (response.isSuccess) {
      return true;
    }
    return false;
  }

  //Profile Update
  bool _updateInProgress = false;
  bool get updateInProgress => _updateInProgress;
  String _updateMessage = "";
  String get updateMessage => _updateMessage;
  Future<bool> updateProfile(
      email, firstName, lastName, mobile, password, photo) async {
    _updateInProgress = true;
    update();
    String? photoInBase64;
    Map<String, dynamic> updateData = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };

    if (password.isNotEmpty) {
      updateData["password"] = password;
    }
    if (photo != null) {
      List<int> imageBytes = await photo!.readAsBytes();
      photoInBase64 = base64Encode(imageBytes);
      updateData["photo"] = photoInBase64;
    }

    NetworkResponse response =
        await NetworkCaller().postRequest(Urls.profileUpdate, body: updateData);
    _updateInProgress = false;
    update();
    if (response.isSuccess) {
      await Get.find<AuthController>().updateUserInformation(UserAuthModel(
          email: email,
          firstName: firstName,
          lastName: lastName,
          mobile: mobile,
          photo: photoInBase64 ?? Get.find<AuthController>().user!.photo));
      _updateMessage = "Update profile success!";
      return true;
    } else {
      _updateMessage = "Update profile Feild!";
      return false;
    }
  }
}
