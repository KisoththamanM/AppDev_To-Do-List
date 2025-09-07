import 'package:flutter/material.dart';
import 'package:to_do_list/db_helper.dart';

void main() {
  runApp(MaterialApp(home: ToDo(), debugShowCheckedModeBanner: false));
}

class ToDo extends StatefulWidget {
  const ToDo({super.key});

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  DBHelper dbHelper = DBHelper();
  List<Map<String, dynamic>> tasks = [];
  DateTime? date;
  TextEditingController taskController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    loadTasks();
    super.initState();
  }

  //For Date picker/////////////////////////////////////////////////////////////
  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
        dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void loadTasks() async {
    final data = await dbHelper.getTasks();
    data.sort((a, b) {
      DateTime dateA = DateTime.parse(a["date"]);
      DateTime dateB = DateTime.parse(b["date"]);
      return dateA.compareTo(dateB);
    });
    setState(() {
      tasks = data;
    });
  }

  void addTask(String title, String date) async {
    await dbHelper.insertTask(title, date);
    loadTasks();
  }

  void deleteTask(int id) async {
    await dbHelper.deleteTask(id);
    loadTasks();
  }

  void toggleDone(int id, bool isDone) async {
    await dbHelper.updateTask(id, isDone ? 1 : 0);
    loadTasks();
  }

  void addTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: Text("Add a new task"),
          content: Column(
            children: [
              TextField(
                controller: taskController,
                decoration: InputDecoration(labelText: "Task"),
              ),
              GestureDetector(
                onTap: () => pickDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: dateController,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.calendar_today_sharp),
                      label: Text("Date"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Colors.black54,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                      ),
                    ),
                  ),
                ),
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
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                addTask(taskController.text, dateController.text);
                taskController.clear();
                dateController.clear();
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void deleteConfirmDialog(int index) {
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
              children: [
                Expanded(
                  child: Text(
                    "Are you sure you want to delete the task?",
                    maxLines: 2,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("No"),
                ),
                SizedBox(width: 5.0),
                TextButton(
                  onPressed: () {
                    deleteTask(tasks[index]["id"]);
                    Navigator.pop(context);
                  },
                  child: Text("Yes"),
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
        title: Text("To Do List"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child:
            tasks.isEmpty
                ? Center(child: Text("No tasks yet."))
                : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        tileColor: Color(0x8DFFE311),
                        leading: Checkbox(
                          value: tasks[index]["isDone"] == 1,
                          onChanged: (value) {
                            toggleDone(tasks[index]["id"], value!);
                          },
                        ),
                        title: Text(tasks[index]["title"]),
                        subtitle: Text(tasks[index]["date"]),
                        trailing: IconButton(
                          onPressed: () {
                            deleteConfirmDialog(index);
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
        elevation: 10.0,
        hoverElevation: 20.0,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        child: Icon(Icons.add, color: Colors.black54),
      ),
    );
  }
}
