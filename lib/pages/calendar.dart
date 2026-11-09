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
    );
  }
}
