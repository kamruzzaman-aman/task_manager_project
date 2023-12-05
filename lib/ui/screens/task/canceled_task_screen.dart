

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:task_manager_project/ui/widgets/task_list_card.dart';

import '../../../data/models/task_model/task_list_model.dart';
import '../../../data/network_caller/network_caller.dart';
import '../../../data/network_caller/network_response.dart';
import '../../../data/utility/urls.dart';

class CanceledTaskScreen extends StatefulWidget {
  const CanceledTaskScreen({super.key});

  @override
  State<CanceledTaskScreen> createState() => _CanceledTaskScreenState();
}

class _CanceledTaskScreenState extends State<CanceledTaskScreen> {
  TaskListModel taskListModel = TaskListModel();
  bool getCancelTaskInProgress = false;

  Future<void> getProgressTaskList() async {
    getCancelTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getCanceledTask);
    if (response.isSuccess) {
      taskListModel = TaskListModel.fromJson(response.jsonResponse);
      log(" tasklist +$taskListModel");
    }
    getCancelTaskInProgress = false;
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
          TaskListCard(taskList:taskListModel, getTaskInProgress: getCancelTaskInProgress, getTaskByStatus: getProgressTaskList,)
        ],
      ),
    );
  }
}

