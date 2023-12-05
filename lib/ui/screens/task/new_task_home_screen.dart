import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:task_manager_project/data/models/task_model/task_list_model.dart';
import 'package:task_manager_project/data/models/task_model/task_status_count.dart';
import 'package:task_manager_project/data/network_caller/network_caller.dart';
import 'package:task_manager_project/data/network_caller/network_response.dart';
import 'package:task_manager_project/ui/widgets/task_list_card.dart';

import '../../../data/utility/urls.dart';
import '../../widgets/task_counter_card.dart';

class NewTaskHomeScreen extends StatefulWidget {
  const NewTaskHomeScreen({super.key});

  @override
  State<NewTaskHomeScreen> createState() => _NewTaskHomeScreenState();
}

class _NewTaskHomeScreenState extends State<NewTaskHomeScreen> {

//Get Task New List

  TaskListModel taskListModel = TaskListModel();
  bool getNewTaskInProgress = false;

  Future<void> getNewTaskList() async {
    getNewTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getNewTask);
    if (response.isSuccess) {
      await getTaskStatusCount();
      taskListModel = TaskListModel.fromJson(response.jsonResponse);
       
      log(" tasklist +$taskListModel");
    }
    getNewTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }


//Get Task Status Count Data

TaskStatusCountModel taskStatusCountModel = TaskStatusCountModel();
  bool getTaskStatusInProgress = false;

    Future<void> getTaskStatusCount() async {
    getTaskStatusInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.taskStatusCount);
    if (response.isSuccess) {
      taskStatusCountModel = TaskStatusCountModel.fromJson(response.jsonResponse);
      log(" tasklist +$taskStatusCountModel");
    }
    getTaskStatusInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.green,
      //   foregroundColor: Colors.white,
      //   onPressed: () {
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (_) => const AddNewTaskScreen()));
      //   },
      //   child: const Icon(Icons.add),
      // ),
      body: Column(
        children: [
        TaskCounterCard(taskStatusCountModel: taskStatusCountModel, TaskStatusInProgress: getTaskStatusInProgress,), 
        TaskListCard(taskList: taskListModel, getTaskInProgress: getNewTaskInProgress, getTaskByStatus: getNewTaskList,)],
      ),
    );
  }
}
