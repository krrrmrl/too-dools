import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
// import 'package:too_dools/services/notif_service.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarTableState();
}

class Task {
  String title;
  DateTime date;
  TimeOfDay? time;
  bool isCompleted;

  Task({
    required this.title,
    required this.date,
    this.time,
    this.isCompleted = false,
  });
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
    _eventController.clear();

    DateTime pickedDate = _selectedDay ?? _focusedDay;
    TimeOfDay? pickedTime;

    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
      ),
      backgroundColor: const Color(0xFFFFD8E4),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () {
                            if (_eventController.text.trim().isEmpty) return;

                            final key = _normalizeDate(pickedDate);

                            // Combine date & time into one DateTime object for notification
                            // DateTime dueDateTime = pickedDate;
                            // if (pickedTime != null) {
                            //   dueDateTime = DateTime(
                            //     pickedDate.year,
                            //     pickedDate.month,
                            //     pickedDate.day,
                            //     pickedTime!.hour,
                            //     pickedTime!.minute,
                            //   );
                            // }

                            final newTask = Task(
                              title: _eventController.text.trim(),
                              date: key,
                              time: pickedTime,
                              isCompleted: false,
                            );

                            setState(() {
                              if (_events[key] != null) {
                                _events[key]!.add(newTask);
                              } else {
                                _events[key] = [newTask];
                              }
                            });

                            // Schedule notification if time is selected
                            // if (pickedTime != null) {
                            //   NotificationService.scheduleNotification(
                            //     id: newTask.hashCode,
                            //     title: 'Task Due!',
                            //     body: newTask.title,
                            //     scheduledDate: dueDateTime,
                            //   );
                            // }

                            _eventController.clear();
                            Navigator.pop(context);
                          },
                        ),
                        const Text(
                          'Add Event / Task',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () {
                            if (_eventController.text.trim().isEmpty) return;

                            final key = _normalizeDate(pickedDate);

                            setState(() {
                              final newTask = Task(
                                title: _eventController.text.trim(),
                                date: key,
                                time: pickedTime,
                                isCompleted: false,
                              );

                              if (_events[key] != null) {
                                _events[key]!.add(newTask);
                              } else {
                                _events[key] = [newTask];
                              }

                              _selectedDay = pickedDate;
                              _focusedDay = pickedDate;
                            });

                            _eventController.clear();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Task Title
                    TextField(
                      controller: _eventController,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'Task Name',
                        labelStyle: const TextStyle(color: Color(0xFFD17E7E)),
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Color(0xFFD17E7E),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Date Picker
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      tileColor: Colors.white,
                      leading: const Icon(
                        Icons.calendar_today,
                        color: Color(0xFFD17E7E),
                      ),
                      title: Text(
                        'Date: ${pickedDate.day}/${pickedDate.month}/${pickedDate.year}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      onTap: () async {
                        final selected = await showDatePicker(
                          context: context,
                          initialDate: pickedDate,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );
                        if (selected != null) {
                          setSheetState(() => pickedDate = selected);
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    // Time Picker
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      tileColor: Colors.white,
                      leading: const Icon(
                        Icons.access_time,
                        color: Color(0xFFD17E7E),
                      ),
                      title: Text(
                        pickedTime != null
                            ? 'Time: ${pickedTime!.format(context)}'
                            : 'Set Start Time (Optional)',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: pickedTime != null
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                setSheetState(() => pickedTime = null);
                              },
                            )
                          : null,
                      onTap: () async {
                        final selected = await showTimePicker(
                          context: context,
                          initialTime: pickedTime ?? TimeOfDay.now(),
                        );
                        if (selected != null) {
                          setSheetState(() => pickedTime = selected);
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedEvents = _selectedDay != null
        ? _getEventsForDay(_selectedDay!)
        : [];

    selectedEvents.sort((a, b) {
      if (a.time == null && b.time == null) return 0;

      if (a.time == null) return 1; // Swap to -1 to place at the top
      if (b.time == null) return -1; // Swap to 1 to place at the top

      final aMinutes = a.time!.hour * 60 + a.time!.minute;
      final bMinutes = b.time!.hour * 60 + b.time!.minute;

      return aMinutes.compareTo(bMinutes);
    });

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
              eventLoader: _getEventsForDay,

              rowHeight: 42.0,
              daysOfWeekHeight: 20.0,

              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      bottom: 2,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: events.take(3).map((event) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1.5),
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFD17E7E),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                  return null;
                },
              ),

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
                  color: Colors.grey,
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
                          subtitle: task.time != null
                              ? Text(
                                  'Start: ${task.time!.format(context)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                )
                              : null,
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
