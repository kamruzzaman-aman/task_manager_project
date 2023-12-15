import 'package:get/get.dart';
import 'package:task_manager_project/data/models/task_model/task_list_model.dart';
import 'package:task_manager_project/data/models/task_model/task_status_count.dart';
import 'package:task_manager_project/data/network_caller/network_caller.dart';
import 'package:task_manager_project/data/network_caller/network_response.dart';
import 'package:task_manager_project/data/utility/urls.dart';

class TaskListTaskStatusCountController extends GetxController {
  bool _getTaskInProgress = false;
  bool get getTaskInProgress => _getTaskInProgress;
  String _failedMessage = '';
  String get failedMessage => _failedMessage;

//Get Task New List
  TaskListModel taskNewListModel = TaskListModel();

  Future<bool> getNewTaskList() async {
    bool isSuccess = false;
    _getTaskInProgress = true;
    update();
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getNewTask);
    // await getTaskStatusCount();
    _getTaskInProgress = false;
    update();
    if (response.isSuccess) {
      taskNewListModel = TaskListModel.fromJson(response.jsonResponse);
      isSuccess = true;
    }
    return isSuccess;
  }

  //Progress task
  TaskListModel taskProgressListModel = TaskListModel();

  Future<void> getProgressTaskList() async {
    _getTaskInProgress = true;
    update();
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getProgressTask);
    _getTaskInProgress = false;
    update();
    if (response.isSuccess) {
      taskProgressListModel = TaskListModel.fromJson(response.jsonResponse);
    }
  }

//Complete Task
  TaskListModel taskCompleteListModel = TaskListModel();

  Future<void> getCompleteTaskList() async {
    _getTaskInProgress = true;
    update();
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getCompletedTask);
    _getTaskInProgress = false;
    update();
    if (response.isSuccess) {
      taskCompleteListModel = TaskListModel.fromJson(response.jsonResponse);
    }
  }

//Cancel Task

  TaskListModel taskCancelListModel = TaskListModel();

  Future<void> getCancelTaskList() async {
    _getTaskInProgress = true;
    update();
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getCanceledTask);
    _getTaskInProgress = false;
    update();
    if (response.isSuccess) {
      taskCancelListModel = TaskListModel.fromJson(response.jsonResponse);
    }
  }

//Get Task Status Count Data
  TaskStatusCountModel taskStatusCountModel = TaskStatusCountModel();
  bool _getTaskStatusInProgress = false;
  bool get getTaskStatusInProgress => _getTaskStatusInProgress;

  Future<bool> getTaskStatusCount() async {
    _getTaskStatusInProgress = true;
    update();
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.taskStatusCount);
    _getTaskStatusInProgress = false;
    update();
    if (response.isSuccess) {
      taskStatusCountModel =
          TaskStatusCountModel.fromJson(response.jsonResponse);
      return true;
    }
    return false;
  }

//Add new Task
  String _addMessage = "";
  String get addMessage => _addMessage;
  bool _addTaskInProgress = false;
  
  bool get addTaskInProgress => _addTaskInProgress;
  Future<bool> createTask(String title, String description) async {
    bool isSuccess = false;
    _addTaskInProgress = true;
    update();

    final NetworkResponse response = await NetworkCaller().postRequest(
        Urls.createTask,
        body: {"title": title, "description": description, "status": "New"});
    _addMessage = "Add New Task";
    _addTaskInProgress = false;
    if (response.isSuccess) {
      update();
      isSuccess= true;
    } else {
      _addMessage = "Add New Task Feild";
    }

    return isSuccess;
  }
}
