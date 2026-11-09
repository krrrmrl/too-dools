import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calendar',
          style: TextStyle(color: Colors.black, fontSize: 40),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color(0x00f7f7f4),
      ),
      body: Center(child: Text('Calendar')),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'To-do List',
          ),
        ],
        currentIndex: 0, // Set the current index to the Calendar page
        selectedItemColor: Color(0x00D17E7E),
        onTap: (index) {
          // Handle navigation based on the tapped index
          if (index == 0) {
            // Already on Calendar page, do nothing
          } else if (index == 1) {
            Navigator.pushNamed(context, '/todo');
          }
        },
      ),
    );
  }
}
