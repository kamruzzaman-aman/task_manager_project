import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project/business_logics/controllers/task_list_task_status_count_controller.dart';
import 'package:task_manager_project/ui/widgets/task_item_card.dart';

class CanceledTaskScreen extends StatefulWidget {
  const CanceledTaskScreen({super.key});

  @override
  State<CanceledTaskScreen> createState() => _CanceledTaskScreenState();
}

class _CanceledTaskScreenState extends State<CanceledTaskScreen> {
  TaskListTaskStatusCountController taskListStatusCountController =
      Get.find<TaskListTaskStatusCountController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      taskListStatusCountController.getCancelTaskList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: GetBuilder<TaskListTaskStatusCountController>(
              builder: (taskList) {
            return Visibility(
              visible: taskList.getTaskInProgress == false,
              replacement: const Center(
                child: CircularProgressIndicator(),
              ),
              child: RefreshIndicator(
                onRefresh: () async {
                  taskListStatusCountController.getCancelTaskList();
                },
                child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: taskList.taskCancelListModel.data?.length ?? 0,
                    itemBuilder: (_, index) {
                      final task = taskList.taskCancelListModel.data![index];

                      return TaskItemCard(
                          task: task,
                          getTaskByStatus: () {
                            taskListStatusCountController.getCancelTaskList();
                          });
                    }),
              ),
            );
          }))
        ],
      ),
    );
  }
}
