import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date

void main() {
  runApp(ToDoApp());
}

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        brightness: Brightness.light,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 18.0, color: Colors.black87),
        ),
      ),
      home: ToDoHome(),
    );
  }
}

class ToDoHome extends StatefulWidget {
  @override
  _ToDoHomeState createState() => _ToDoHomeState();
}

class _ToDoHomeState extends State<ToDoHome> {
  final List<Map<String, dynamic>> _todoList = [];
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedPriority = 'Normal';

  void _addTodoItem(
      String task, String description, DateTime dueDate, String priority) {
    if (task.isNotEmpty) {
      setState(() {
        _todoList.add({
          'task': task,
          'description': description,
          'dueDate': dueDate,
          'priority': priority,
        });
      });
      _taskController.clear();
      _descriptionController.clear();
      _selectedDate = null;
      _selectedPriority = 'Normal';
    }
  }

  void _editTodoItem(int index, String updatedTask, String updatedDescription,
      DateTime updatedDate, String updatedPriority) {
    setState(() {
      _todoList[index] = {
        'task': updatedTask,
        'description': updatedDescription,
        'dueDate': updatedDate,
        'priority': updatedPriority,
      };
    });
  }

  void _removeTodoItem(int index) {
    setState(() {
      _todoList.removeAt(index);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _showEditDialog(int index) {
    final taskData = _todoList[index];
    TextEditingController _editTaskController =
        TextEditingController(text: taskData['task']);
    TextEditingController _editDescriptionController =
        TextEditingController(text: taskData['description']);
    DateTime _editDate = taskData['dueDate'];
    String _editPriority = taskData['priority'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _editTaskController,
                decoration: InputDecoration(
                  labelText: "Task",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _editDescriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _editPriority,
                decoration: const InputDecoration(
                  labelText: "Priority",
                  border: OutlineInputBorder(),
                ),
                items: ['Low', 'Normal', 'High'].map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                onChanged: (value) {
                  _editPriority = value!;
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  _editDate == null
                      ? "Select due date"
                      : DateFormat('yyyy-MM-dd').format(_editDate),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _editTodoItem(index, _editTaskController.text,
                    _editDescriptionController.text, _editDate, _editPriority);
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.purple[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        labelText: 'Task',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => _selectDate(context),
                            child: Text(
                              _selectedDate == null
                                  ? "Select due date"
                                  : DateFormat('yyyy-MM-dd')
                                      .format(_selectedDate!),
                              style: const TextStyle(color: Colors.purple),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedPriority,
                            decoration: const InputDecoration(
                              labelText: "Priority",
                              border: OutlineInputBorder(),
                            ),
                            items: ['Low', 'Normal', 'High'].map((priority) {
                              return DropdownMenuItem(
                                value: priority,
                                child: Text(priority),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedPriority = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => _addTodoItem(
                          _taskController.text,
                          _descriptionController.text,
                          _selectedDate!,
                          _selectedPriority),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Add Task"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _todoList.isEmpty
                  ? Center(
                      child: Text(
                        "No tasks added yet!",
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 20.0),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _todoList.length,
                      itemBuilder: (context, index) {
                        final task = _todoList[index];
                        return Dismissible(
                          key: Key(task['task']),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          direction: DismissDirection.startToEnd,
                          onDismissed: (direction) {
                            _removeTodoItem(index);
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3.0,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Colors.purple,
                                child: Icon(Icons.check, color: Colors.white),
                              ),
                              title: Text(
                                task['task'],
                                style: const TextStyle(fontSize: 18),
                              ),
                              subtitle: Text(
                                "Due: ${task['dueDate'] != null ? DateFormat('yyyy-MM-dd').format(task['dueDate']) : 'No due date'} | Priority: ${task['priority']} | Description: ${task['description']}",
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blueAccent),
                                    onPressed: () => _showEditDialog(index),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    onPressed: () => _removeTodoItem(index),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
