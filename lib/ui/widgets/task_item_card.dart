import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project/business_logics/controllers/task_list_task_status_count_controller.dart';
import 'package:task_manager_project/business_logics/controllers/update_delete_controller.dart';
import 'package:task_manager_project/data/models/task_model/task_datum.dart';
import 'package:task_manager_project/styles/app_style.dart';
import 'package:task_manager_project/ui/widgets/update_task_alert_dialog.dart';

// ignore: must_be_immutable
class TaskItemCard extends StatefulWidget {
  TaskItemCard({super.key, required this.task, required this.getTaskByStatus});

  final Datum task;
  final VoidCallback getTaskByStatus;

  @override
  State<TaskItemCard> createState() => _TaskItemCardState();
}

class _TaskItemCardState extends State<TaskItemCard> {
  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.green;
    if (widget.task.status == "New") {
      statusColor = Colors.blue;
    } else if (widget.task.status == "Progress") {
      statusColor = Colors.orange;
    } else if (widget.task.status == "Cancel") {
      statusColor = Colors.red;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.task.title}",
              style: const TextStyle(
                  color: Color.fromRGBO(44, 62, 80, 1.0),
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              "${widget.task.description}",
              style: const TextStyle(
                  color: Color.fromRGBO(135, 142, 150, 1.0),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              "Date : ${widget.task.createdDate}",
              style: const TextStyle(
                  color: Color.fromRGBO(44, 62, 80, 1.0),
                  fontSize: 9,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    "${widget.task.status}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: statusColor,
                  side: BorderSide.none,
                ),
                Wrap(
                  children: [
                    IconButton(
                        onPressed: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) {
                              return UpdateTaskStatusDialog(
                                task: widget.task,
                                onStatusChange: widget.getTaskByStatus,
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.edit_location_alt_outlined,
                        ),
                        style:
                            IconButton.styleFrom(foregroundColor: Colors.blue)),
                    IconButton(
                        onPressed: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: const Text('Want to delete?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () async {
                                      Get.back();
                                      await deleteTask(widget.task.id!);
                                    },
                                    child: const Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text('No'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.delete_outlined,
                        ),
                        style:
                            IconButton.styleFrom(foregroundColor: Colors.red)),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> deleteTask(String taskID) async {
        //for progress Indicator
    AppStyle.progress(context);
    final response = await Get.find<UpdateDeleteTask>().deleteTask(taskID);
    Get.back();
    if (response) {
      widget.getTaskByStatus();
      await Get.find<TaskListTaskStatusCountController>().getTaskStatusCount();
    }
  }
}
