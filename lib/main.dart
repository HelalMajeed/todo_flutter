import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> tasks = [];
  final newTask = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTask();
  }

  Future<void> saveTask() async {
    final prefs = await SharedPreferences.getInstance();
    bool success = await prefs.setStringList('tasks', tasks);
    if (success) {
      print('Tasks saved successfully');
    } else {
      print('Failed to save tasks');
    }
  }

  Future<void> loadTask() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? loadedTasks = prefs.getStringList('tasks');
    if (loadedTasks != null) {
      setState(() {
        tasks = loadedTasks;
      });
      print('Tasks loaded successfully');
    } else {
      print('No tasks found in local storage');
    }
  }

  @override
  void dispose() {
    newTask.dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }

  void addTask() {
    if (newTask.text.isNotEmpty) {
      setState(() {
        tasks.add(newTask.text);
        newTask.clear(); // Clear the text field after adding the task
      });
      saveTask(); // Save the updated task list to local storage
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: const Icon(
            Icons.home,
            color: Colors.white,
          ),
          backgroundColor: Colors.orange,
          title: const Text("Task List"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: newTask,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Type your task...",
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: addTask,
                child: const Text("Add Your Task"),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        leading: IconButton(
                          onPressed: () {
                            setState(() {
                              tasks.removeAt(index);
                            });
                            saveTask();
                          },
                          icon: const Icon(Icons.delete),
                        ),
                        tileColor: Colors.orange[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: Text(tasks[index]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
