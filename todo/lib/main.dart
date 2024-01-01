// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO List',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
            primary: Colors.black,
            secondary: Colors.white,
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'isDone': isDone,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      title: map['title'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      isDone: map['isDone'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) =>
      Todo.fromMap(json.decode(source) as Map<String, dynamic>);
}

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Todo> todoList = [];
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    retrieveTodos();
  }

  retrieveTodos() async {
    prefs = await SharedPreferences.getInstance();
    final String? storedTodoList = prefs.getString('todoList');
    if (storedTodoList != null) {
      setState(() {
        todoList.addAll((jsonDecode(storedTodoList) as List)
            .map((todo) => Todo.fromJson(todo))
            .toList());
      });
    }
  }

  saveTodos() async {
    await prefs.setString('todoList', jsonEncode(todoList));
  }

  String newTitle = "";
  String newDesc = "";
  bool showDone = false;
  void addList() {
    setState(() {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(color: Colors.white, width: 2),
              ),
              title: const Text("Add Task"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Title",
                        focusColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelStyle: TextStyle(color: Colors.white)),
                    onChanged: (value) => newTitle = value,
                    cursorColor: Colors.white, // Set the cursor color
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Note",
                        focusColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelStyle: TextStyle(color: Colors.white)),
                    onChanged: (value) => newDesc = value,
                    cursorColor: Colors.white,
                  ),
                ],
              ),
              actions: [
                TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        backgroundColor: Colors.red[50]),
                    onPressed: () {
                      setState(() {
                        newTitle = "";
                        newDesc = "";
                        Navigator.pop(context);
                      });
                    },
                    child: const Text("Cancel")),
                TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                        backgroundColor: Colors.green[50]),
                    onPressed: () {
                      setState(() {
                        todoList.add(Todo(
                            title: newTitle,
                            description: newDesc,
                            isDone: false));
                        newTitle = "";
                        newDesc = "";
                        saveTodos();
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
      saveTodos();
    });
  }

  void deleteTodo(int index) {
    setState(() {
      todoList.removeAt(index);
      saveTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          bottomOpacity: 20,
          title: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (rect) => const RadialGradient(
                    center: Alignment.bottomCenter,
                    radius: 1.85,
                    colors: <Color>[
                      Color(0xFF3ecfb2),
                      Color.fromARGB(255, 0, 255, 204)
                    ],
                  ).createShader(rect),
              child: Title(
                color: Colors.white,
                child: const Text('TASKS'),
              )),
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu,
              color: Color(0xFF3ecfb2),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.filter_alt_rounded,
                color: Color(0xFF3ecfb2),
              ),
            ),
            if (todoList.where((element) => element.isDone).isNotEmpty)
              TextButton(
                onPressed: () {
                  setState(() {
                    showDone = !showDone;
                  });
                },
                child: showDone
                    ? const Icon(Icons.visibility_off_outlined,
                        color: Color(0xFF3ecfb2))
                    : const Icon(
                        Icons.visibility_outlined,
                        color: Color(0xFF3ecfb2),
                      ),
              )
          ],
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 400),
            child: ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (context, index) {
                  if (todoList[index].isDone && !showDone) return Container();
                  return ListTile(
                    title: Text(
                      todoList[index].title,
                      style: TextStyle(
                          decoration: todoList[index].isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: const Color(0xFF3ecfb2),
                          decorationThickness: 5,
                          decorationStyle: TextDecorationStyle.wavy,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: todoList[index].description != null
                        ? Text(
                            todoList[index].description!,
                            style: TextStyle(
                                decoration: todoList[index].isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                decorationColor: const Color(0xFF3ecfb2),
                                decorationThickness: 5,
                                fontWeight: FontWeight.bold),
                          )
                        : null,
                    trailing: Checkbox(
                      value: todoList[index].isDone,
                      onChanged: (bool? value) {
                        updateTodo(index, value);
                        todoList.sort((a, b) {
                          if (a.isDone && !b.isDone) return 1;
                          if (!a.isDone && b.isDone) return -1;
                          return 0;
                        });
                      },
                      activeColor: const Color(0xFF3ecfb2),
                    ),
                    onLongPress: () => deleteTodo(index),
                  );
                }),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addList,
          backgroundColor: Colors.black,
          child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (rect) => const RadialGradient(
                    center: Alignment.bottomLeft,
                    radius: 3.0,
                    colors: <Color>[Color(0xFF3ecfb2), Colors.green],
                  ).createShader(rect),
              child: const Icon(
                Icons.add,
                size: 35,
              )),
        ));
  }
}
