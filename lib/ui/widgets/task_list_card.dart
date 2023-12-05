import 'package:flutter/material.dart';
import 'package:task_manager_project/data/models/task_model/task_list_model.dart';
import 'package:task_manager_project/data/network_caller/network_caller.dart';
import 'package:task_manager_project/data/network_caller/network_response.dart';
import 'package:task_manager_project/data/utility/urls.dart';
import 'package:task_manager_project/ui/widgets/snack_message.dart';
import 'package:task_manager_project/ui/widgets/update_task_alert_dialog.dart';

// ignore: must_be_immutable
class TaskListCard extends StatefulWidget {
  TaskListCard(
      {super.key,
      required this.taskList,
      this.getTaskInProgress,
      required this.getTaskByStatus});

  final TaskListModel taskList;
  bool? getTaskInProgress;
  final VoidCallback getTaskByStatus;

  @override
  State<TaskListCard> createState() => _TaskListCardState();
}

class _TaskListCardState extends State<TaskListCard> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Visibility(
      visible: widget.getTaskInProgress == false,
      replacement: const Center(
        child: CircularProgressIndicator(),
      ),
      child: RefreshIndicator(
        onRefresh: () async {
          widget.getTaskByStatus();
        },
        child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: widget.taskList.data?.length ?? 0,
            itemBuilder: (_, index) {
              final task = widget.taskList.data![index];
              Color statusColor = Colors.green;
              if (task.status == "New") {
                statusColor = Colors.blue;
              } else if (task.status == "Progress") {
                statusColor = Colors.orange;
              } else if (task.status == "Cancel") {
                statusColor = Colors.red;
              }

              return Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${task.title}",
                        style: const TextStyle(
                            color: Color.fromRGBO(44, 62, 80, 1.0),
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${task.description}",
                        style: const TextStyle(
                            color: Color.fromRGBO(135, 142, 150, 1.0),
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Date : ${task.createdDate}",
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
                              "${task.status}",
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
                                      context: context,
                                      builder: (_) {
                                        return UpdateTaskStatusDialog(
                                          task: task,
                                          onStatusChange:
                                              widget.getTaskByStatus,
                                          showProgress: (bool inProgress) {
                                            widget.getTaskInProgress =
                                                inProgress;
                                            setState(() {});
                                          },
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.edit_location_alt_outlined,
                                  ),
                                  style: IconButton.styleFrom(
                                      foregroundColor: Colors.blue)),
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          title: const Text(
                                              'Want to delete?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () async {
                                                await deleteTask(task.id!);
                                                if (mounted) {
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: const Text('Yes'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
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
                                  style: IconButton.styleFrom(
                                      foregroundColor: Colors.red)),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    ));
  }

  Future<void> deleteTask(String taskID) async {
    widget.getTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
        await NetworkCaller().getRequest(Urls.deleteTask(taskID));
    if (response.isSuccess) {
      widget.getTaskByStatus();
      if (mounted) {
        showSnackMessage(context, "Successfully Delete Task");
      }
    }
    widget.getTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
