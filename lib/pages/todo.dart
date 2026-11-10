import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class TodoPage extends StatefulWidget{
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoListState();
}

class _TodoListState extends State<TodoPage> {
  final List<bool> _done = [false, false, false, false, false, false, false, false, false, false];
  final List<String> _tasks = [
    'Task 1',
    'Task 2',
    'Task 3',
    'Task 4',
    'Task 5',
    'Task 6',
    'Task 7',
    'Task 8',
    'Task 9',
    'Task 10'
  ];
  final List<DateTime?> _due = [
    null,
    DateTime(2026, 11, 12),
    null,
    DateTime(2026, 11, 13),
    DateTime(2026, 11, 12),
    DateTime(2026, 11, 14),
    null,
    DateTime(2026, 11, 13),
    DateTime(2026, 11, 12),
    null,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ExpansionTile(
            title: Text('No due date'),
            children: [
              for (int i = 0; i < _tasks.length; i++)
                if (_due[i] == null)
                  _buildCard(i),
            ],
          ),
          for (final d in _buildDueList())
            ExpansionTile(
              title: Text(DateFormat('dd MMM yyyy').format(d)),
              children: [
                for (int i = 0; i < _tasks.length; i++)
                  if (_due[i] != null && isSameDay(_due[i], d))
                  _buildCard(i),
            ],
          ),
        ],
      ),
      //ListView(
        //itemCount: _tasks.length,
        //itemBuilder: (context, index) {
        //  return _buildCard(index);
        //},
      //),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add',
        backgroundColor:   Color(0xFFFFD8E4),
        shape: CircleBorder(),
        child: const Icon(Icons.add, color: Color(0xFFD17E7E)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
  Widget _buildCard(int i){
    return Card(
      color: _done[i] ? Colors.white60 : Colors.white,
      child: ListTile(
        leading: Checkbox(
          shape: CircleBorder(),
          checkColor: Colors.white,
          activeColor: Color(0xFFD17E7E),
          value: _done[i],
          onChanged: (bool? value) {
            setState(() {
              _done[i] = value!;
            });
          },
        ),
        title: Text(
          _tasks[i],
          style: TextStyle(
            fontSize: 18,
            decoration: _done[i] ? TextDecoration.lineThrough : null,
          ),
        ),
      ),
    );
  }
  List<DateTime> _buildDueList(){
    List<DateTime> dates = [];
    for (int i = 0; i < _tasks.length; i++){
      if (_due[i] != null && !dates.any((d) => isSameDay(d, _due[i]))) {
        dates.add(_due[i]!);
      }
    }
    return dates;
  }
}