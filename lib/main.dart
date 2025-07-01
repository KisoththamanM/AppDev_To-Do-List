import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: ToDo(), debugShowCheckedModeBanner: false));
}

class Task {
  String task;
  String date;
  bool isDone;
  Task({required this.task, required this.date, this.isDone = false});
}

class ToDo extends StatefulWidget {
  const ToDo({super.key});

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
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

  void deleteTask(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Color(0xBEFFE311),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Are you sure you want to delete the task?',
                    maxLines: 2,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('No'),
                ),
                SizedBox(width: 5.0),
                TextButton(
                  onPressed: () {
                    setState(() {
                      tasks.removeAt(index);
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Yes'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF5DB0A),
        title: Text('To Do List'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child:
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
                        tileColor: Color(0x8DFFE311),
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
                        trailing: IconButton(
                          onPressed: () {
                            deleteTask(index);
                          },
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTaskDialog();
        },
        backgroundColor: Color(0xFFFFE311),
        hoverColor: Colors.deepPurpleAccent,
        elevation: 10.0,
        hoverElevation: 20.0,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        child: Icon(Icons.add, color: Colors.black54),
      ),
    );
  }
}
