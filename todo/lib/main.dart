import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
            primary: Colors.black,
            secondary: Color.fromARGB(255, 213, 244, 102),
            tertiary: Colors.red),
      ),
      home: const HomePage(title: 'HOME'),
    );
  }
}

class Todo {
  final String title;
  final String? description;
  bool isDone;
  Todo({
    required this.title,
    this.description,
    this.isDone = false,
  });
}

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Todo> todoList = [];
  String newTitle = "";
  String newDesc = "";
  void addList() {
    setState(() {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Add Todo"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Title",
                    ),
                    onChanged: (value) => newTitle = value,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Description",
                    ),
                    onChanged: (value) => newDesc = value,
                  ),
                ],
              ),
              actions: [
                TextButton(
                    style: TextButton.styleFrom(primary: Colors.red),
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: const Text("Cancel")),
                TextButton(
                    style: TextButton.styleFrom(primary: Colors.green),
                    onPressed: () {
                      setState(() {
                        todoList.add(Todo(
                            title: newTitle,
                            description: newDesc,
                            isDone: false));
                        Navigator.pop(context);
                      });
                    },
                    child: const Text("Add")),
              ],
            );
          });
    });
  }

  void resetList() {
    setState(() {
      todoList.clear();
    });
  }

  void updateTodo(int index, bool? value) {
    setState(() {
      todoList[index].isDone = value!;
    });
  }

  void deleteTodo(int index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "TODO",
          ),
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 400),
            child: ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      todoList[index].title,
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    subtitle: todoList[index].description != null
                        ? Text(todoList[index].description!)
                        : null,
                    trailing: Checkbox(
                      value: todoList[index].isDone,
                      onChanged: (bool? value) {
                        updateTodo(index, value);
                      },
                    ),
                    onLongPress: () => deleteTodo(index),
                  );
                }),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addList,
          child: const Icon(Icons.add),
          foregroundColor: Colors.red,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(width: 2)),
        ));
  }
}
