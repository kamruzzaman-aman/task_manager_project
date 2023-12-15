import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project/business_logics/controllers/task_list_task_status_count_controller.dart';
import 'package:task_manager_project/ui/widgets/app_bar.dart';
import 'package:task_manager_project/ui/widgets/snack_message.dart';

import '../../widgets/body_background.dart';
import 'main_bottom_nav_screen.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _subjectTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TaskListTaskStatusCountController tasklistController =
      Get.find<TaskListTaskStatusCountController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool value){
        Get.offAll(MainBottomNavScreen());
      },
      child: Scaffold(
        appBar: taskAppsBar(context, enableOnTap: false),
        body: Column(
          children: [
            Expanded(
              child: BodyBackground(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 32,
                          ),
                          Text(
                            'Add New Task',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _subjectTEController,
                            decoration:
                                const InputDecoration(hintText: 'Subject'),
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'Enter your subject';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: _descriptionTEController,
                            maxLines: 8,
                            decoration:
                                const InputDecoration(hintText: 'Description'),
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'Enter your description';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: createTask,
                                child:
                                    GetBuilder<TaskListTaskStatusCountController>(
                                        builder: (addTask) {
                                  return Visibility(
                                    visible: addTask.addTaskInProgress == false,
                                    replacement: const SizedBox(
                                      height: 20.0,
                                      width: 20.0,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    child: const Icon(
                                        Icons.arrow_circle_right_outlined),
                                  );
                                })),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> createTask() async {
    if (_formKey.currentState!.validate()) {
      final response = await tasklistController.createTask(
          _subjectTEController.text.trim(), _subjectTEController.text.trim());
      if (response) {
        if (mounted) {
          showSnackMessage(context, tasklistController.addMessage);
        }
        controllerClear;
        // await tasklistController.getNewTaskList();
        // await tasklistController.getTaskStatusCount();
      } else {
        if (mounted) {
          showSnackMessage(context, tasklistController.addMessage, true);
        }
      }
    }
  }

  void get controllerClear {
    _subjectTEController.clear();
    _descriptionTEController.clear();
  }

  @override
  void dispose() {
    _descriptionTEController.dispose();
    _subjectTEController.dispose();
    super.dispose();
  }
}
