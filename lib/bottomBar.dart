import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class bottomBar extends StatefulWidget{
  bottomBar();


  @override
  State<bottomBar> createState() => _bottomBarState();
}

class _bottomBarState extends State<bottomBar>{

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedIconTheme: IconThemeData(color: Colors.purple, size: 35),
      selectedItemColor: Colors.purple,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),

      unselectedIconTheme: IconThemeData(color: Colors.grey, size: 30),
      showUnselectedLabels: false,
      unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 14.0),

      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.work_outline, size: 30.0,),
          label: 'Jobs',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline, size: 30,),
          label: 'Resume',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined, size: 30,),
          label: 'Settings',
        ),
      ],
      currentIndex: _selectedIndex,
      //New
      onTap: _onItemTapped,);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}