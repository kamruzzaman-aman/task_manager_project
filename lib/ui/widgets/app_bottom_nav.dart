import 'package:flutter/material.dart';

class AppBottomNav extends StatelessWidget {
  AppBottomNav(
      {super.key, required this.currentIndex, required this.onItemTapped});
  final int currentIndex;
  final void Function(int onTapIndex) onItemTapped;

  final _selectedBgColor = Colors.green;
  final _unselectedBgColor = Colors.white;
  final _selectedItemColor = Colors.white;
  final _unselectedItemColor = Colors.grey;

  Color _getBgColor(int index) =>
      currentIndex == index ? _selectedBgColor : _unselectedBgColor;
  Color _getItemColor(int index) =>
      currentIndex == index ? _selectedItemColor : _unselectedItemColor;

  buildIcon(IconData iconData, String text, int index) => SizedBox(
        width: double.infinity,
        height: kBottomNavigationBarHeight,
        child: Container(
          color: _getBgColor(index),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconData),
              Text(text,
                  style: TextStyle(
                      fontSize: 12,
                      color: _getItemColor(index),
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedFontSize: 0,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: buildIcon(Icons.list_alt, 'New Task', 0),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: buildIcon(Icons.check_circle_outlined, 'Completed', 1),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: buildIcon(Icons.cancel_outlined, 'Canceled', 2),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: buildIcon(Icons.access_time_rounded, 'Progress', 3),
          label: "",
        ),
      ],
      // selectedItemColor: _selectedItemColor,
      // unselectedItemColor: _unselectedItemColor,
      // ignore: prefer_const_constructors
      selectedIconTheme: IconThemeData(color: _selectedItemColor),
      currentIndex: currentIndex,
      // onTap: onItemTapped,

      //or
      onTap: (int onTapCurrentIndex){
        onItemTapped(onTapCurrentIndex);
        print(onTapCurrentIndex);
      },
      
      type: BottomNavigationBarType.fixed,
    );
  }
}
