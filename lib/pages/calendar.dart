import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarTableState();
}

class Task {
  String title;
  DateTime date;
  bool isCompleted;

  Task({required this.title, required DateTime date, this.isCompleted = false})
    : date = DateTime(date.year, date.month, date.day);
}

class _CalendarTableState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<Task>> _events = {};
  final TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime.utc(date.year, date.month, date.day);
  }

  List<Task> _getEventsForDay(DateTime day) {
    return _events[_normalizeDate(day)] ?? [];
  }

  void _showAddEventDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Event / Task'),
        content: TextField(
          controller: _eventController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter task description...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _eventController.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_eventController.text.trim().isEmpty) return;

              final selectedDate = _selectedDay ?? _focusedDay;
              final key = _normalizeDate(selectedDate);

              setState(() {
                final newTask = Task(
                  title: _eventController.text.trim(),
                  date: key,
                  isCompleted: false,
                );

                if (_events[key] != null) {
                  _events[key]!.add(newTask);
                } else {
                  _events[key] = [newTask];
                }
              });

              _eventController.clear();
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedEvents = _selectedDay != null
        ? _getEventsForDay(_selectedDay!)
        : [];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            TableCalendar<Task>(
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(1900, 01, 01),
              lastDay: DateTime.utc(2100, 01, 01),
              calendarFormat: _calendarFormat,

              rowHeight: 42.0,
              daysOfWeekHeight: 20.0,

              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.black87,
                  shape: BoxShape.circle,
                ),

                selectedTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),

                todayDecoration: BoxDecoration(
                  color: Color(0xFFD17E7E),
                  shape: BoxShape.circle,
                ),
              ),

              headerStyle: const HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                headerPadding: EdgeInsets.symmetric(vertical: 4.0),
              ),

              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },

              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },

              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },

              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),

            const Divider(height: 1),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _selectedDay != null
                      ? 'Tasks for ${DateFormat('dd MMM yyyy').format(_selectedDay!)}'
                      : 'Select a day',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),

            Expanded(
              child: selectedEvents.isEmpty
                  ? const Center(child: Text('No tasks for this day.'))
                  : ListView.builder(
                      itemCount: selectedEvents.length,
                      itemBuilder: (context, index) {
                        final task = selectedEvents[index];

                        return ListTile(
                          trailing: IconButton(
                            icon: Icon(
                              task.isCompleted
                                  ? Icons.check_box_rounded
                                  : Icons.check_box_outline_blank_rounded,
                              color: task.isCompleted
                                  ? const Color(0xFFD17E7E)
                                  : Colors.blueGrey,
                            ),
                            onPressed: () {
                              setState(() {
                                task.isCompleted = !task.isCompleted;
                              });
                            },
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: task.isCompleted
                                  ? Colors.blueGrey
                                  : Colors.black,
                            ),
                          ),
                          leading: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Color(0xFFD17E7E),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedEvents.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        tooltip: 'Add',
        backgroundColor: Color(0xFFFFD8E4),
        shape: CircleBorder(),
        child: const Icon(Icons.add, color: Color(0xFFD17E7E)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
