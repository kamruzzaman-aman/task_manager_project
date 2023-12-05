import 'package:flutter/material.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/app_bottom_nav.dart';
import 'canceled_task_screen.dart';
import 'completed_task_screen.dart';
import 'new_task_home_screen.dart';
import 'progress_task_screen.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainBottomNavScreenState createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    NewTaskHomeScreen(),
    CompletedTaskScreen(),
    CanceledTaskScreen(),
    ProgressTaskScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: taskAppsBar(context),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: AppBottomNav(
        // onItemTapped: _onItemTapped,
        
        //or
        onItemTapped: (onTapIndex){
          _onItemTapped(onTapIndex);
        },
        currentIndex: _selectedIndex,
      ),
    );
  }
}


