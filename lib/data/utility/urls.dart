import 'package:task_manager_project/ui/widgets/update_task_alert_dialog.dart';

class Urls {
  static const String _baseUrl = "https://task.teamrabbil.com/api/v1";

  static const String registration = "$_baseUrl/registration";
  static const String login = "$_baseUrl/login";
  static const String profileUpdate = "$_baseUrl/profileUpdate";
  static const String createTask = "$_baseUrl/createTask";

  static String getNewTask =
      "$_baseUrl/listTaskByStatus/${TaskStatus.New.name}";
  static String getCompletedTask =
      "$_baseUrl/listTaskByStatus/${TaskStatus.Complete.name}";
  static String getCanceledTask =
      "$_baseUrl/listTaskByStatus/${TaskStatus.Cancel.name}";
  static String getProgressTask =
      "$_baseUrl/listTaskByStatus/${TaskStatus.Progress.name}";
  static const String taskStatusCount = "$_baseUrl/taskStatusCount";
  static String updateTaskStatus(String taskID, String taskStatus) {
    return "$_baseUrl/updateTaskStatus/$taskID/$taskStatus";
  }

  static String deleteTask(String taskID) {
    return "$_baseUrl/deleteTask/$taskID";
  }

  static String verifyEmailForPin(String email) {
    return "$_baseUrl/RecoverVerifyEmail/$email";
  }

  static String verifyPinForReset(String email, String pin) {
    return "$_baseUrl/RecoverVerifyOTP/$email/$pin";
  }

  static const String recoverResetPassword = "$_baseUrl/RecoverResetPass";
}
