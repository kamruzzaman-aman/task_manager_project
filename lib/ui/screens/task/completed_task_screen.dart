
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:task_manager_project/ui/widgets/task_list_card.dart';

import '../../../data/models/task_model/task_list_model.dart';
import '../../../data/network_caller/network_caller.dart';
import '../../../data/network_caller/network_response.dart';
import '../../../data/utility/urls.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  TaskListModel taskListModel = TaskListModel();
  bool getCompleteTaskInProgress = false;

  Future<void> getProgressTaskList() async {
    getCompleteTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getCompletedTask);
    if (response.isSuccess) {
      taskListModel = TaskListModel.fromJson(response.jsonResponse);
     log(" tasklist +$taskListModel");
    }
    getCompleteTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getProgressTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TaskListCard(taskList: taskListModel, getTaskInProgress: getCompleteTaskInProgress, getTaskByStatus: getProgressTaskList,)
        ],
      ),
    );
  }
}

