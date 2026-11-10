import 'package:flutter/material.dart';
import 'package:too_dools/pages/calendar.dart';
import 'package:too_dools/pages/todo.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const CalendarPage(),
    const TodoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Too-Dools',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontFamily: 'IngridDarling',
            height: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color(0xFFf7f7f4),
      ),

      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xFFD17E7E),
        backgroundColor: Color(0xFFf7f7f4),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'To-do List',
          ),
        ],
      ),
    );
  }
}