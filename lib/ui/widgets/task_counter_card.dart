import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project/business_logics/controllers/task_list_task_status_count_controller.dart';

class TaskCounterCard extends StatelessWidget {
  const TaskCounterCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return GetBuilder<TaskListTaskStatusCountController>(
      builder: (taskStatusCount) {
        return Visibility(
          visible: taskStatusCount.getTaskStatusInProgress == false &&
              (taskStatusCount.taskStatusCountModel.data?.isNotEmpty ?? false),
          replacement: const LinearProgressIndicator(),
          child: SizedBox(
              height: 60,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: taskStatusCount.taskStatusCountModel.data?.length ?? 0,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) {
                  final taskCount = taskStatusCount.taskStatusCountModel.data![index];
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
    );
  }
}
