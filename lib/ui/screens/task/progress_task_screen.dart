

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:task_manager_project/ui/widgets/task_list_card.dart';

import '../../../data/models/task_model/task_list_model.dart';
import '../../../data/network_caller/network_caller.dart';
import '../../../data/network_caller/network_response.dart';
import '../../../data/utility/urls.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  TaskListModel taskListModel = TaskListModel();
  bool getProgressTaskInProgress = false;

  Future<void> getProgressTaskList() async {
    getProgressTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getProgressTask);
    if (response.isSuccess) {
      taskListModel = TaskListModel.fromJson(response.jsonResponse);
      log(" tasklist +$taskListModel");
    }
    getProgressTaskInProgress = false;
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
          TaskListCard(taskList: taskListModel, getTaskInProgress: getProgressTaskInProgress, getTaskByStatus: getProgressTaskList,)
        ],
      ),
    );
  }
}

