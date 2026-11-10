import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarTableState();
}

class _CalendarTableState extends State<CalendarPage> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  final DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

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
      body: TableCalendar(
        focusedDay: _focusedDay,
        firstDay: DateTime.utc(1900, 01, 01),
        lastDay: DateTime.utc(2100, 01, 01),
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
        selectedItemColor: Color(0xFFD17E7E),
        backgroundColor: Color(0xFFf7f7f4),
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
