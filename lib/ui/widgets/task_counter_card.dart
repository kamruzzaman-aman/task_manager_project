import 'package:flutter/material.dart';
import 'package:task_manager_project/data/models/task_model/task_status_count.dart';

class TaskCounterCard extends StatelessWidget {
  const TaskCounterCard(
      {super.key,
      required this.taskStatusCountModel,
      required this.TaskStatusInProgress});

  final TaskStatusCountModel taskStatusCountModel;
  final bool TaskStatusInProgress;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: TaskStatusInProgress == false &&(taskStatusCountModel.data?.isNotEmpty??false),
      replacement: const LinearProgressIndicator(),
      child: SizedBox(
          height: 60,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: taskStatusCountModel.data?.length ?? 0,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              final taskCount = taskStatusCountModel.data![index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${taskCount.sum}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text("${taskCount.id}"),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}
