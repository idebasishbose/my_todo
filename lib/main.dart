import 'package:flutter/material.dart';

import 'bloc/todo_bloc.dart';
import 'data/todo.dart';
import 'todo_screen.dart';

void main() => runApp(TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todos App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TodoBloc todoBloc;
  List<Todo> todos;
  @override
  void initState() {
    todoBloc = TodoBloc();
    super.initState();
  }

  @override
  void dispose() {
    todoBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Todo todo = Todo('', '', '', 0);
    todos = todoBloc.todoList;
    return Scaffold(
        appBar: AppBar(
          title: Text('Todo List'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TodoScreen(todo, true)),
            );
          },
        ),
        body: Container(
          child: StreamBuilder<List<Todo>>(
              stream: todoBloc.todos,
              initialData: todos,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return ListView.builder(
                    itemCount: (snapshot.hasData) ? snapshot.data.length : 0,
                    itemBuilder: (context, index) {
                      return Dismissible(
                          key: Key(snapshot.data[index].id.toString()),
                          onDismissed: (_) =>
                              todoBloc.todoDeleteSink.add(snapshot.data[index]),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).highlightColor,
                              child: Text("${snapshot.data[index].priority}"),
                            ),
                            title: Text("${snapshot.data[index].name}"),
                            subtitle:
                                Text("${snapshot.data[index].description}"),
                            trailing: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TodoScreen(
                                          snapshot.data[index], false)),
                                );
                              },
                            ),
                          ));
                    });
              }),
        ));
  }
}
