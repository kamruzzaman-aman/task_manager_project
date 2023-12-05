import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:task_manager_project/data/models/task_model/task_datum.dart';
import 'package:task_manager_project/data/network_caller/network_caller.dart';
import 'package:task_manager_project/data/network_caller/network_response.dart';
import 'package:task_manager_project/data/utility/urls.dart';
import 'package:task_manager_project/ui/widgets/snack_message.dart';

enum TaskStatus {
  New,
  Progress,
  Complete,
  Cancel,
}

class UpdateTaskStatusDialog extends StatefulWidget {
  const UpdateTaskStatusDialog(
      {super.key,
      required this.task,
      required this.onStatusChange,
      required this.showProgress});
  final Datum task;
  final VoidCallback onStatusChange;
  final Function(bool) showProgress;

  @override
  // ignore: library_private_types_in_public_api
  _TaskStatusDialogState createState() => _TaskStatusDialogState();
}

class _TaskStatusDialogState extends State<UpdateTaskStatusDialog> {
  TaskStatus? selectedStatus;
  String? validationMessage;

  Future<void> updateTaskStatusMethod() async {
    widget.showProgress(true);
    NetworkResponse response = await NetworkCaller().getRequest(
        Urls.updateTaskStatus(
            widget.task.id!, selectedStatus.toString().split('.').last));
    if (response.isSuccess) {
      widget.onStatusChange();
      if (mounted) {
        showSnackMessage(context, "Successfully Update Status");
      }
    }
    widget.showProgress(false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Task Status'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (TaskStatus status in TaskStatus.values)
            RadioListTile<TaskStatus>(
              title: Text(status.toString().split('.').last),
              value: status,
              groupValue: selectedStatus,
              onChanged: (TaskStatus? value) {
                setState(() {
                  selectedStatus = value;
                  validationMessage = null; // Reset validation message
                  log(selectedStatus.toString().split('.').last);
                });
              },
            ),
          if (validationMessage != null)
            Text(
              validationMessage!,
              style: const TextStyle(color: Colors.red),
            ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            if (selectedStatus == null) {
              if (mounted) {
                setState(() {
                  validationMessage = 'Please select a task status';
                });
              }
            } else {
              await updateTaskStatusMethod();
              if (mounted) {
                Navigator.pop(context);
              }
            }
          },
          child: const Text('Confirm'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
