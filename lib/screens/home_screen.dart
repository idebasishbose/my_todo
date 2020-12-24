import 'package:flutter/material.dart';

import '../bloc/todo_bloc.dart';
import '../data/todo.dart';
import 'todo_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TodoBloc _todoBloc;
  List<Todo> todos;
  String whatHappened;

  @override
  void initState() {
    super.initState();
    _todoBloc = TodoBloc();
  }

  @override
  void dispose() {
    _todoBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Todo todo = Todo('', '', '', 0);
    todos = _todoBloc.todoList;
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
          stream: _todoBloc.todos,
          initialData: todos,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return ListView.builder(
              itemCount: (snapshot.hasData) ? snapshot.data.length : 0,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(snapshot.data[index].id.toString()),
                  onDismissed: (_) => {
                    _todoBloc.todoDeleteSink.add(snapshot.data[index]),
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "${snapshot.data[index].name} was $whatHappened"),
                      ),
                    )
                  },
                  confirmDismiss: (DismissDirection dismissDirection) async {
                    return await dismissDirectionActions(
                        dismissDirection, context);
                  },
                  background: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.cancel),
                  ),
                  secondaryBackground: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    color: Colors.green,
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.check),
                  ),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).highlightColor,
                        child: Text("${snapshot.data[index].priority}"),
                      ),
                      title: Text("${snapshot.data[index].name}"),
                      subtitle: Text("${snapshot.data[index].description}"),
                      trailing: IconButton(
                        color: Colors.blueGrey,
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TodoScreen(snapshot.data[index], false),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<bool> dismissDirectionActions(
      DismissDirection dismissDirection, BuildContext context) async {
    switch (dismissDirection) {
      case DismissDirection.endToStart:
        whatHappened = 'ARCHIVED';
        return await _showConfirmationDialog(context, 'Archive') == true;
      case DismissDirection.startToEnd:
        whatHappened = 'DELETED';
        return await _showConfirmationDialog(context, 'Delete') == true;
      case DismissDirection.horizontal:
      case DismissDirection.vertical:
      case DismissDirection.up:
      case DismissDirection.down:
        assert(false);
    }
    return false;
  }
}

Future<bool> _showConfirmationDialog(BuildContext context, String action) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Do you want to $action this item?'),
        actions: <Widget>[
          FlatButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.pop(context, true); // showDialog() returns true
            },
          ),
          FlatButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.pop(context, false); // showDialog() returns false
            },
          ),
        ],
      );
    },
  );
}
