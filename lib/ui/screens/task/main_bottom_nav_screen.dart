import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project/ui/widgets/app_bar.dart';
import 'package:task_manager_project/ui/widgets/app_bottom_nav.dart';
import 'canceled_task_screen.dart';
import 'completed_task_screen.dart';
import 'new_task_home_screen.dart';
import 'progress_task_screen.dart';


// ignore: must_be_immutable
class MainBottomNavScreen extends StatelessWidget {
  MainBottomNavScreen({super.key});
  static const List<Widget> _widgetOptions = <Widget>[
    NewTaskHomeScreen(),
    CompletedTaskScreen(),
    CanceledTaskScreen(),
    ProgressTaskScreen(),
  ];

final RxInt _currentIndex = 0.obs;
  @override
  Widget build(BuildContext context) {
    return  Obx(()=>
       Scaffold(
            appBar: taskAppsBar(context),
            body: Center(
              child: _widgetOptions[_currentIndex.value],
            ),
            bottomNavigationBar: AppBottomNav(
              onItemTapped: (onTapIndex){
                _currentIndex.value = onTapIndex;
              },
              currentIndex: _currentIndex.value,
            ),
          ),
    );
      
    
  }
}


