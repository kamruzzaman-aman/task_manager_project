import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project/business_logics/controllers/task_list_task_status_count_controller.dart';
import 'package:task_manager_project/ui/widgets/task_counter_card.dart';
import 'package:task_manager_project/ui/widgets/task_item_card.dart';

class NewTaskHomeScreen extends StatefulWidget {
  const NewTaskHomeScreen({super.key});

  @override
  State<NewTaskHomeScreen> createState() => _NewTaskHomeScreenState();
}

class _NewTaskHomeScreenState extends State<NewTaskHomeScreen> {
  TaskListTaskStatusCountController taskListStatusCountController =
      Get.find<TaskListTaskStatusCountController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This code will be executed after the first frame is built
      // You can perform initialization tasks here
      taskListStatusCountController.getNewTaskList();
      taskListStatusCountController.getTaskStatusCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const TaskCounterCard(),
          Expanded(child: GetBuilder<TaskListTaskStatusCountController>(
              builder: (taskList) {
            return Visibility(
              visible: taskList.getTaskInProgress == false,
              replacement: const Center(
                child: CircularProgressIndicator(),
              ),
              child: RefreshIndicator(
                onRefresh: () async {
                  taskListStatusCountController.getNewTaskList();
                  taskListStatusCountController.getTaskStatusCount();
                },
                child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: taskList.taskNewListModel.data?.length ?? 0,
                    itemBuilder: (_, index) {
                      final task = taskList.taskNewListModel.data![index];

                      return TaskItemCard(
                          task: task,
                          getTaskByStatus: () {
                            taskListStatusCountController.getNewTaskList();
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
