import 'package:flutter/material.dart';

import 'bloc/todo_bloc.dart';
import 'data/todo.dart';
import 'main.dart';

class TodoScreen extends StatelessWidget {
  final Todo todo;
  final bool isNew;
  final txtName = TextEditingController();
  final txtDescription = TextEditingController();
  final txtCompleteBy = TextEditingController();
  final txtPriority = TextEditingController();

  final TodoBloc bloc;

  TodoScreen(this.todo, this.isNew) : bloc = TodoBloc();

  @override
  Widget build(BuildContext context) {
    final double padding = 20.0;
    txtName.text = todo.name;
    txtDescription.text = todo.description;
    txtCompleteBy.text = todo.completeBy;
    txtPriority.text = todo.priority.toString();
    return Scaffold(
        appBar: AppBar(
          title: Text('Todo Details'),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(padding),
              child: TextField(
                controller: txtName,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Name',
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(padding),
                child: TextField(
                  controller: txtDescription,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Description',
                    helperText: 'Description',
                  ),
                )),
            Padding(
                padding: EdgeInsets.all(padding),
                child: TextField(
                  controller: txtCompleteBy,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Complete by'),
                )),
            Padding(
                padding: EdgeInsets.all(padding),
                child: TextField(
                  controller: txtPriority,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Priority',
                  ),
                )),
            Padding(
                padding: EdgeInsets.all(padding),
                child: MaterialButton(
                  child: Text('Save'),
                  onPressed: () {
                    save().then((_) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (Route<dynamic> route) => false,
                        ));
                  },
                )),
          ],
        )));
  }

  Future save() async {
    todo.name = txtName.text;
    todo.description = txtDescription.text;
    todo.completeBy = txtCompleteBy.text;
    todo.priority = int.tryParse(txtPriority.text);
    if (isNew) {
      bloc.todoInsertSink.add(todo);
    } else {
      bloc.todoUpdateSink.add(todo);
    }
  }
}
