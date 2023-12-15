import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project/business_logics/controllers/task_list_task_status_count_controller.dart';
import 'package:task_manager_project/business_logics/controllers/update_delete_controller.dart';
import 'package:task_manager_project/data/models/task_model/task_datum.dart';
import 'package:task_manager_project/styles/app_style.dart';
import 'package:task_manager_project/ui/widgets/snack_message.dart';

enum TaskStatus {
  New,
  Progress,
  Complete,
  Cancel,
}

class UpdateTaskStatusDialog extends StatefulWidget {
  const UpdateTaskStatusDialog({
    super.key,
    required this.task,
    required this.onStatusChange,
  });
  final Datum task;
  final VoidCallback onStatusChange;

  @override
  // ignore: library_private_types_in_public_api
  _TaskStatusDialogState createState() => _TaskStatusDialogState();
}

class _TaskStatusDialogState extends State<UpdateTaskStatusDialog> {
  UpdateDeleteTask updateDeleteTask = Get.find<UpdateDeleteTask>();
  TaskStatus? selectedStatus;

  Future<void> updateTaskStatusMethod() async {
    //for progress Indicator
    AppStyle.progress(context);
    final response = await updateDeleteTask.updateTaskStatusMethod(
        widget.task.id!, selectedStatus);
    Get.back();
    if (response) {
      widget.onStatusChange();
      await Get.find<TaskListTaskStatusCountController>().getTaskStatusCount();
      if (mounted) {
        showSnackMessage(context, updateDeleteTask.failedMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Task Status'),
      content: GetBuilder<UpdateDeleteTask>(builder: (updateDeleteTask) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (TaskStatus status in TaskStatus.values)
              RadioListTile<TaskStatus>(
                title: Text(status.toString().split('.').last),
                value: status,
                groupValue: selectedStatus,
                onChanged: (TaskStatus? value) {
                  selectedStatus = value;
                  updateDeleteTask.radioButtonValidation(value: value);
                  log(value.toString().split('.').last);
                },
              ),
            Text(
              updateDeleteTask.validationMessage ?? "",
              style: const TextStyle(color: Colors.red),
            ),
          ],
        );
      }),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            if (selectedStatus == null) {
              updateDeleteTask.radioButtonValidation(
                  message: "Please select a task status!");
            } else {
              Get.back();
              await updateTaskStatusMethod();
            }
          },
          child: const Text('Confirm'),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            updateDeleteTask.radioButtonValidation(
                message: "");
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
