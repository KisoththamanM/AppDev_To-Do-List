import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp(), debugShowCheckedModeBanner: false));
}

class Task {
  String task;
  String date;
  bool isDone;
  Task({required this.task, required this.date, this.isDone = false});
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Task> tasks = [];
  TextEditingController taskController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  void addTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: Text('Add a new task'),
          content: Column(
            children: [
              TextField(
                controller: taskController,
                decoration: InputDecoration(labelText: 'Task'),
              ),
              TextField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Date'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                taskController.clear();
                dateController.clear();
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  tasks.add(
                    Task(task: taskController.text, date: dateController.text),
                  );
                });
                taskController.clear();
                dateController.clear();
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('To Do List')),
      body:
          tasks.isEmpty
              ? Center(child: Text('No tasks yet.'))
              : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 5.0,
                      bottom: 5.0,
                      left: 10.0,
                      right: 10.0,
                    ),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      tileColor: Colors.black12,
                      leading: Checkbox(
                        value: tasks[index].isDone,
                        onChanged: (value) {
                          setState(() {
                            tasks[index].isDone = !tasks[index].isDone;
                          });
                        },
                      ),
                      title: Text(tasks[index].task),
                      subtitle: Text(tasks[index].date),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTaskDialog();
        },
        backgroundColor: Colors.deepPurple,
        hoverColor: Colors.deepPurpleAccent,
        elevation: 10.0,
        hoverElevation: 20.0,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
    );
  }
}
