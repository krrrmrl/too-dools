import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class TodoPage extends StatefulWidget{
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoListState();
}

class _TodoListState extends State<TodoPage> {
  final List<bool> _done = [
    false, 
    false, 
    false, 
    false, 
    false,
  ];
  final List<String> _tasks = [
    'Task 1',
    'Task 2',
    'Task 3',
    'Task 4',
    'Task 5',
  ];
  final List<DateTime?> _due = [
    DateTime(2026, 11, 14),
    null,
    DateTime(2026, 11, 12),
    null,
    DateTime(2026, 11, 13),
  ];

  final TextEditingController _titleController = TextEditingController();
  DateTime? _pickedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ExpansionTile(
            initiallyExpanded: true,
            shape: Border(),
            title: Text('No due date', style: TextStyle(fontSize: 13)),
            children: [
              for (int i = 0; i < _tasks.length; i++)
                if (_due[i] == null)
                  _buildCard(i),
            ],
          ),
          for (final d in _buildDueList())
            ExpansionTile(
              initiallyExpanded: true,
              shape: Border(),
              title: Text(DateFormat('dd MMM yyyy').format(d), style: TextStyle(fontSize: 13)),
              children: [
                for (int i = 0; i < _tasks.length; i++)
                  if (_due[i] != null && isSameDay(_due[i], d))
                  _buildCard(i),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddSheet();
        },
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
    dates.sort((a, b) => a.compareTo(b));
    return dates;
  }

  void _showAddSheet() {
    _titleController.clear();
    _pickedDate = null;
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
      ),
      backgroundColor: Color(0xFFFFD8E4),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'Add Task',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        if (_titleController.text.trim().isEmpty) return;
                        setState(() {
                          _tasks.add(_titleController.text.trim());
                          _done.add(false);
                          _due.add(_pickedDate);
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Task Name',
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15), 
                      borderSide: BorderSide(color: Color(0xFFD17E7E))
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  tileColor: Colors.white,
                  title: Text(' ${_pickedDate != null ? DateFormat('dd MMM yyyy').format(_pickedDate!) : 'No due date'}'),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _pickedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setSheetState(() {
                        _pickedDate = picked;
                      });
                    }
                  },
                  trailing: _pickedDate != null
                    ? IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          setSheetState(() {
                            _pickedDate = null;
                          });
                        },
                      )
                    : null,
                )
              ],
            ),
            );
          },
        );
      }
    );
  }
}